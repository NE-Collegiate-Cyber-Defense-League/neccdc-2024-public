import requests
import json
from datetime import datetime, timezone

teams = 21 # 1 == team 0
wireguard_public_host = "vpn.rust.energy"
timestamp_format = "%Y-%m-%dT%H:%M:%S.%fZ"


def query_user_info(team_number):
  tcp_port = f"519{team_number:02}"
  wireguard_password = "BlueTeamPassword"

  # tcp_port = "51999"
  # wireguard_password = "admin-password-here"

  authenticate_session_response = requests.post(
      f"http://{wireguard_public_host}:{tcp_port}/api/session",
      json={"password": wireguard_password}
  )

  authenticate_session_response = requests.get(
    f"http://{wireguard_public_host}:{tcp_port}/api/wireguard/client",
    headers={"Cookie": f"connect.sid={authenticate_session_response.cookies.get('connect.sid')}"}
  )

  return authenticate_session_response.text

def parse_user_information(user_information):
  for user in json.loads(user_information):
    current_time = datetime.utcnow().replace(tzinfo=timezone.utc)
    if (user['latestHandshakeAt'] == None):
      formatted_time_diff = "None"
    else:
      given_timestamp = datetime.strptime(user['latestHandshakeAt'], timestamp_format).replace(tzinfo=timezone.utc)

      time_difference = current_time - given_timestamp
      formatted_time_diff = str(time_difference).rsplit('.', 1)[0]
    print(f"  {user['name']} --- {formatted_time_diff}")

for i in range(teams):
  print(f"Team number: {i}")
  parse_user_information(query_user_info(i))
