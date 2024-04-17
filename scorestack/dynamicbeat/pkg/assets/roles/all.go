package roles

import (
	"io"

	"github.com/scorestack/scorestack/dynamicbeat/pkg/assets"
	"github.com/scorestack/scorestack/dynamicbeat/pkg/config"
)

func AttributeAdmin() io.Reader {
	return assets.Read("roles/attribute-admin.json")
}

func CheckAdmin() io.Reader {
	return assets.Read("roles/check-admin.json")
}

func Common() io.Reader {
	return assets.Read("roles/common.json")
}

func Dynamicbeat() io.Reader {
	return assets.Read("roles/dynamicbeat.json")
}

func Spectator() io.Reader {
	return assets.Read("roles/spectator.json")
}

func Team(team config.Team) io.Reader {
	return assets.ReadTeam("roles/team.json", team)
}
