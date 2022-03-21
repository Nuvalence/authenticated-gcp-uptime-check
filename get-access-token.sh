#/bin/sh

token=$(curl --location --request POST "https://accounts.spotify.com/api/token" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=client_credentials' \
--data-urlencode "client_id=$1" \
--data-urlencode "client_secret=$2" | jq -r '.access_token')

echo "{\"token\":\"${token}\"}"
