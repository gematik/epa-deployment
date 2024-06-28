#!/bin/sh

# Configurable server address which can be passed as argument to the script
DEFAULT_SERVER_ADDRESS="http://localhost:8084/fhir"
SERVER_ADDRESS=${1:-$DEFAULT_SERVER_ADDRESS}

# Function to process JSON files in a folder
process_folder() {
  folder="$1"

  # Prevents globbing from expanding to a literal '*' if no matches are found
  set -- "$folder"/*.json
  # Reverts nullglob option to its previous state
  [ -e "$1" ] || return

  if [ "$#" -eq 0 ]; then
    echo "No JSON files found in $folder"
    return
  fi

  folder_name=$(basename "$folder")

  case $folder_name in
    "01_organization") context="Organization" ;;
    "02_practitioner") context="Practitioner" ;;
    "03_practitioner-role") context="PractitionerRole" ;;
    "04_patient") context="Patient" ;;
    "05_medication") context="Medication" ;;
    "06_medication-request") context="MedicationRequest" ;;
    "07_medication-dispense") context="MedicationDispense" ;;
    *)   echo "Warning: No context mapping found for $folder_name"; return ;;
  esac

  for file in "$@"; do
    #echo "Processing $file"
    # Construct the API endpoint based on the context mapping
    api_endpoint="$SERVER_ADDRESS/$context"
    curl --header "Content-Type: application/json" --data "@$file" "$api_endpoint"
  done
}

root_folder="samples"

# Loop through subfolders
for subfolder in $root_folder/*; do
  if [ -d "$subfolder" ]; then
    process_folder "$subfolder"
  fi
done
