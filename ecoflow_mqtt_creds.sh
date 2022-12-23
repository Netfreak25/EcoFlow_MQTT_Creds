#!/bin/bash

echo "Checking if jq is installed"
echo "exiting if not"
which jq >/dev/null 2>&1 || exit 1

echo "Checking if base64 is installed"
echo "exiting if not"
which base64 >/dev/null 2>&1 || exit 1

echo "Checking if curl is installed"
echo "exiting if not"
which which >/dev/null 2>&1 || exit 1


echo "Checking if sed is installed"
echo "exiting if not"
which sed >/dev/null 2>&1 || exit 1


echo
echo "Everything is ready to extract the mqtt data"
echo "please log in now:"
echo

# Read Email
echo -n Email:
read email

# Read Password
echo -n Password:
read -s password
echo

# Convert Password to base64
mypass=$(echo -n $password | base64)

# Get token
token=$(curl -s -H "Host: api.ecoflow.com" -H "lang: de-de" -H "lang: de-de" -H "platform: android" -H "sysversion: 11" -H "version: 4.1.2.02" -H "phonemodel: SM-X200" -H "content-type: application/json" -H "user-agent: okhttp/3.14.9" --data-binary "{\"appVersion\":\"4.1.2.02\",\"email\":\"$email\",\"os\":\"android\",\"osVersion\":\"30\",\"password\":\"$mypass\",\"scene\":\"IOT_APP\",\"userType\":\"ECOFLOW\"}" --compressed "https://api.ecoflow.com/auth/login" | jq .data.token | sed 's/"//' | sed 's/"//')

## Get UserId
userid=$(curl -s -H "Host: api.ecoflow.com" -H "lang: de-de" -H "lang: de-de" -H "platform: android" -H "sysversion: 11" -H "version: 4.1.2.02" -H "phonemodel: SM-X200" -H "content-type: application/json" -H "user-agent: okhttp/3.14.9" --data-binary "{\"appVersion\":\"4.1.2.02\",\"email\":\"$email\",\"os\":\"android\",\"osVersion\":\"30\",\"password\":\"$mypass\",\"scene\":\"IOT_APP\",\"userType\":\"ECOFLOW\"}" --compressed "https://api.ecoflow.com/auth/login" | jq .data.user.userId | sed 's/"//' | sed 's/"//')

# Get MQTT Credentials
curl -s -H "Host: api.ecoflow.com" -H "lang: de-de" -H "platform: android" -H "authorization: Bearer $token" -H "sysversion: 11" -H "version: 4.1.2.02" -H "phonemodel: SM-X200" -H "user-agent: okhttp/3.14.9" --compressed "https://api.ecoflow.com/iot-auth/app/certification?userId=$userid" | jq .

echo
echo "Subscribe to /app/device/property/YourSerialNumber"
echo "Subscribing to # does not work at all"
echo
echo "UserID: "$userid
echo "have fun"
