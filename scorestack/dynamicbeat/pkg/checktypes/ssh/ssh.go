package ssh

import (
	"context"
	"crypto/x509"
	"encoding/base64"
	"encoding/pem"
	"fmt"
	"log"
	"regexp"
	"strconv"
	"time"

	"github.com/scorestack/scorestack/dynamicbeat/pkg/check"
	"go.uber.org/zap"
	"golang.org/x/crypto/ssh"
)

// The Definition configures the behavior of the SSH check
// it implements the "check" interface
type Definition struct {
	Config       check.Config // generic metadata about the check
	Host         string       `optiontype:"required"` // IP or hostname of the host to run the SSH check against
	Username     string       `optiontype:"required"` // The user to login with over ssh
	Password     string       `optiontype:"optional"` // The password for the user that you wish to login with
	PrivKey      string       `optiontype:"optional"`
	Cmd          string       `optiontype:"required"`                    // The command to execute once ssh connection established
	MatchContent string       `optiontype:"optional"`                    // Whether or not to match content like checking files
	ContentRegex string       `optiontype:"optional" optiondefault:".*"` // Regex to match if reading a file
	Port         string       `optiontype:"optional" optiondefault:"22"` // The port to attempt an ssh connection on
}

// Run a single instance of the check
func (d *Definition) Run(ctx context.Context) check.Result {
	// Initialize empty result
	result := check.Result{Timestamp: time.Now(), Metadata: d.Config.Metadata}

	// Config SSH client
	// TODO: change timeout to be relative to the parent context's timeout
	auth := []ssh.AuthMethod{}
	if d.Password != "" {
		auth = append(auth, ssh.Password(d.Password))
	}
	if d.PrivKey != "" {
		// decode the provided key data
		dataBytes, err := base64.StdEncoding.DecodeString(d.PrivKey)
		if err != nil {
			log.Fatalf("unable to parse private key base64: %v", err)
		}
		// rebuild into a PEM
		//block := &pem.Block{
		//	Type:  "RSA PRIVATE KEY",
		//	Bytes: dataBytes,
		//}
		block, _ := pem.Decode(dataBytes)
		if block == nil {
			log.Fatalf("unable to parse block: %v", err)
		}
		
		// Parse the RSA private key
		rsaPrivateKey, err := x509.ParsePKCS1PrivateKey(block.Bytes)
		if err != nil {
			log.Fatalf("unable to parse rsaPrivateKey: %v", err)
		}

		// encode the PEM to a byte string
		//encodedPEM := pem.EncodeToMemory(block)
		
		// create a signer for the SSH client to use
		//signer, err := ssh.ParsePrivateKey(encodedPEM)
		//if err != nil {
		//	log.Fatalf("unable to use parsed private key: %v", err)
		//}
		signer, err := ssh.NewSignerFromKey(rsaPrivateKey)
		if err != nil {
			log.Fatalf("unable to use create signer: %v", err)
		}

		// add public key auth as an auth method
		auth = append(auth, ssh.PublicKeys(signer))
	}
	config := &ssh.ClientConfig{
		User:            d.Username,
		Auth:            auth,
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
		Timeout:         20 * time.Second,
	}

	// Create the ssh client
	client, err := ssh.Dial("tcp", fmt.Sprintf("%s:%s", d.Host, d.Port), config)
	if err != nil {
		result.Message = fmt.Sprintf("Error creating ssh client: %s", err)
		return result
	}
	defer func() {
		err = client.Close()
		if err != nil {
			zap.S().Warnf("Failed to close SSH connection: %s", err)
		}
	}()

	// Create a session from the connection
	session, err := client.NewSession()
	if err != nil {
		result.Message = fmt.Sprintf("Error creating a ssh session: %s", err)
		return result
	}
	defer func() {
		err = session.Close()
		if err != nil && err.Error() != "EOF" {
			zap.S().Warnf("Failed to close SSH session connection: %s", err)
		}
	}()

	// Run a command
	output, err := session.CombinedOutput(d.Cmd)
	if err != nil {
		result.Message = fmt.Sprintf("Error executing command: %s", err)
		return result
	}

	// Check if we are going to match content
	if matchContent, _ := strconv.ParseBool(d.MatchContent); !matchContent {
		// If we made it here the check passes
		result.Message = fmt.Sprintf("Command %s executed successfully: %s", d.Cmd, output)
		result.Passed = true
		return result
	}

	// Match some content
	regex, err := regexp.Compile(d.ContentRegex)
	if err != nil {
		result.Message = fmt.Sprintf("Error compiling regex string %s : %s", d.ContentRegex, err)
		return result
	}

	// Check if the content matches
	if !regex.Match(output) {
		result.Message = "Matching content not found"
		return result
	}

	// If we reach here the check is successful
	result.Passed = true
	return result
}

// GetConfig returns the current CheckConfig struct this check has been
// configured with.
func (d *Definition) GetConfig() check.Config {
	return d.Config
}

// SetConfig reconfigures this check with a new CheckConfig struct.
func (d *Definition) SetConfig(c check.Config) {
	d.Config = c
}
