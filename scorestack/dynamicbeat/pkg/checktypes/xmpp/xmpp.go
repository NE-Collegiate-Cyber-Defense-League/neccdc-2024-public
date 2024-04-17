package xmpp

import (
	"context"
	"crypto/tls"
	"fmt"
	"strconv"
	"time"

	"go.uber.org/zap"
	"gosrc.io/xmpp/stanza"

	"github.com/scorestack/scorestack/dynamicbeat/pkg/check"
	"gosrc.io/xmpp"
)

// The Definition configures the behavior of the XMPP check
// it implements the "check" interface
type Definition struct {
	Config    check.Config // generic metadata about the check
	Host      string       `optiontype:"required"`                      // IP or hostname of the xmpp server
	Username  string       `optiontype:"required"`                      // Username to use for the xmpp server
	Password  string       `optiontype:"required"`                      // Password for the user
	Encrypted string       `optiontype:"optional" optiondefault:"true"` // TLS support or not
	Port      string       `optiontype:"optional" optiondefault:"5222"` // Port for the xmpp server
}

// Run a single instance of the check
func (d *Definition) Run(ctx context.Context) check.Result {
	// Initialize empty result
	result := check.Result{Timestamp: time.Now(), Metadata: d.Config.Metadata}

	// Convert Encrypted to bool
	encrypted, _ := strconv.ParseBool(d.Encrypted)

	// Create xmpp config
	config := xmpp.Config{
		TransportConfiguration: xmpp.TransportConfiguration{
			Address:   fmt.Sprintf("%s:%s", d.Host, d.Port),
			TLSConfig: &tls.Config{InsecureSkipVerify: true},
			// ConnectTimeout: 20,
		},
		Jid:        fmt.Sprintf("%s@%s", d.Username, d.Host),
		Credential: xmpp.Password(d.Password),
		Insecure:   !encrypted,
		// ConnectTimeout: 20,
	}

	// Create a client
	client, err := xmpp.NewClient(&config, xmpp.NewRouter(), errorHandler)
	if err != nil {
		result.Message = fmt.Sprintf("Creating a xmpp client failed : %s", err)
		return result
	}

	// Create IQ xmpp message
	iq, err := stanza.NewIQ(stanza.Attrs{
		Type: stanza.IQTypeGet,
		From: d.Host,
		To:   "localhost",
		Id:   "Scorestack-check",
	})
	if err != nil {
		result.Message = fmt.Sprintf("Creating IQ message failed : %s", err)
		return result
	}

	// Set Disco as the payload of IQ
	disco := iq.DiscoInfo()
	iq.Payload = disco

	// Connect the client
	err = client.Connect()
	if err != nil {
		result.Message = fmt.Sprintf("Connecting to %s failed : %s", d.Host, err)
		return result
	}
	defer func() {
		err = client.Disconnect()
		if err != nil {
			zap.S().Warnf("Failed to close XMPP connection: %s", err)
		}
	}()

	// Send the IQ message
	err = client.Send(iq)
	if err != nil {
		result.Message = fmt.Sprintf("Sending IQ message to %s failed %s", d.Host, err)
		return result
	}

	// If we make it here the check should pass
	result.Passed = true
	return result
}

// Without this function, the xmpp "client" calls will seg fault
func errorHandler(err error) {
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
