#!/bin/bash

# Note we did not run this for regionals :D

TEAM_NUMBER="0"

API_TOKEN="API_TOKEN"

PROJECT_ID=$(curl -XGET --header "PRIVATE-TOKEN: ${API_TOKEN}" "https://gitlab.${TEAM_NUMBER}.rust.energy/api/v4/projects?owned=true" | jq 'map(select(.name == "shop")) | .[0].id')

echo "Project ID = ${PROJECT_ID}"

# https://docs.gitlab.com/ee/api/tags.html#create-a-new-tag
curl --request POST \
  --header "PRIVATE-TOKEN: ${API_TOKEN}" \
  --url "https://gitlab.${TEAM_NUMBER}.rust.energy/api/v4/projects/${PROJECT_ID}/repository/tags?tag_name=latest&ref=main"
