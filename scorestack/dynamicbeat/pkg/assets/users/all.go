package users

import (
	"io"

	"github.com/scorestack/scorestack/dynamicbeat/pkg/assets"
	"github.com/scorestack/scorestack/dynamicbeat/pkg/config"
)

func Dynamicbeat() io.Reader {
	return assets.Read("users/dynamicbeat.json")
}

func Team(team config.Team) io.Reader {
	return assets.ReadTeam("users/team.json", team)
}
