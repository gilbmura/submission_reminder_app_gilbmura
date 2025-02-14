#!/bin/bash

function check_submissions() {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Read the submissions file and process it line by line
    while IFS=, read -r student assignment status; do
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == " not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 $submissions_file)
}
