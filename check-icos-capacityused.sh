#!/bin/bash

BUCKET=$1
APIKEY=$2

TOKEN=$(curl -s -k -X POST --header "Content-Type: application/x-www-form-urlencoded" --header "Accept: application/json" --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" --data-urlencode "apikey=${APIKEY}" "https://iam.cloud.ibm.com/identity/token" | jq -r ".access_token")

BYTES_USED=$(curl -s -k https://config.cloud-object-storage.cloud.ibm.com/v1/b/${BUCKET} -H "authorization: bearer $TOKEN"| jq ".bytes_used")

function bytesToHR()
{
  local SIZE=$1
  local UNITS="B KiB MiB GiB TiB PiB"
  for F in $UNITS; do
    local UNIT=$F
    test ${SIZE%.*} -lt 1024 && break;
    SIZE=$(echo "$SIZE / 1024" | bc -l)
  done

  if [ "$UNIT" == "B" ]; then
    printf "%4.0f    %s\n" $SIZE $UNIT
  else
    printf "%7.02f %s\n" $SIZE $UNIT
  fi
}

READABLE=$(bytesToHR ${BYTES_USED})

echo "${BUCKET}: ${READABLE}"
