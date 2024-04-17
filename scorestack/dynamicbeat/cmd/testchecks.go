package cmd

import (
	"fmt"
	"os"

	"github.com/scorestack/scorestack/dynamicbeat/pkg/checksource"
	"github.com/scorestack/scorestack/dynamicbeat/pkg/config"
	"github.com/scorestack/scorestack/dynamicbeat/pkg/dynamicbeat"
	"github.com/spf13/cobra"
)

const testShort = `Run check definitions from the specified directory for testing`
const testLong = testShort + `
Dynamicbeat will pull check configurations from the configured Scorestack
Dynamicbeat loads the checks from the provided directory and executes the 
checks immediately and then at regular intervals, printing success/failure 
messages to the screen. This process is repeated until Dynamicbeat is terminated.`

// testCmd represents the test command
var testCmd = &cobra.Command{
	Use:   "test [path to checks]",
	Short: testShort,
	Long:  testLong,
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		c := config.Get()

		// Filter out teams if specified
		var teams []config.Team
		if team != "" {
			for _, t := range c.Teams {
				if t.Name == team {
					teams = append(teams, t)
				}
			}
		} else {
			teams = c.Teams
		}

		// Make sure at least one team exists
		if len(teams) == 0 {
			fmt.Printf("No teams found. If you passed -t/--team, make sure the team you specified actually exists.")
			os.Exit(1)
		}

		f := &checksource.Filesystem{
			Path:  args[0],
			Teams: teams,
		}
		cobra.CheckErr(dynamicbeat.TestChecks(f))
	},
}

func init() {
	rootCmd.AddCommand(testCmd)
}
