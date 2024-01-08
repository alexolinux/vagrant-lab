#!/bin/bash

# This script checks if the file .env exists, and if it exists
# it reads it line by line checking each variable.
# If one or more variable is empty RESULT receives false,
# otherwise RESULT receives true.

# Variable to store the result
RESULT=true

# Check if .env exists
if [ -f "./.env" ]; then
    # Read .env line by line and check each variable
    while IFS= read -r line 
    do
        # Skip processing if the line is empty
        if [ -z "$line" ]; then
            continue
        fi

        # Split variable NAME and VALUE, and store each VALUE in a variable
        NAME=$(echo "$line" | cut -d '=' -f 1)
        VALUE=$(echo "$line" | cut -d '=' -f 2)

        # Check if the variable VALUE is empty (null or an empty string)
        if [ -z "$VALUE" ] || [ "$VALUE" == \"\" ] || [ "$VALUE" == \'\' ]; then
            RESULT=false
            echo -e "Variable ${NAME} is not declared in .env\n"
            break
        else
            echo "${NAME} : ${VALUE}"
            echo -e "Variable OK.\n"
        fi
    done < ./.env
fi

echo -e "\n$RESULT%"
