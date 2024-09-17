#!/bin/sh

# Configurable server address which can be passed as argument to the script
DEFAULT_SERVER_ADDRESS="http://localhost:8084/fhir"
SERVER_ADDRESS=${1:-$DEFAULT_SERVER_ADDRESS}

api_endpoint="$SERVER_ADDRESS"
curl --header "Content-Type: application/json" --data "@samples/transaction.json" "$api_endpoint"

