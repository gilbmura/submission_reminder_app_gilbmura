#!/bin/bash

# Prompt user for their name
echo -n "Enter your name: "
read user_name

# Set up the base directory with the user's name
base_dir="submission_reminder_${user_name}"

# Create the directory structure
echo "Creating directory structure..."
mkdir -p "$base_dir/app"
mkdir -p "$base_dir/config"
mkdir -p "$base_dir/modules"
mkdir -p "$base_dir/assets"

# Create reminder.sh
echo "Creating reminder.sh..."
cat << 'EOF' > "$base_dir/app/reminder.sh"
#!/bin/bash
# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "$submissions_file"
EOF

# Create functions.sh
echo "Creating functions.sh..."
cat << 'EOF' > "$base_dir/modules/functions.sh"
#!/bin/bash

function check_submissions() {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file")
}
EOF

# Create config.env
echo "Creating config.env..."
cat << 'EOF' > "$base_dir/config/config.env"
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Create submissions.txt
echo "Creating submissions.txt and adding student records..."
echo "student,assignment,submission status" > "$base_dir/assets/submissions.txt"
cat << 'EOF' >> "$base_dir/assets/submissions.txt"
Chinemerem,Shell Navigation,not submitted
Chiagoziem,Git,submitted
Divine,Shell Navigation,not submitted
Anissa,Shell Basics,submitted
Noel,Shell Navigation,not submitted
Melinda,Shell Navigation,not submitted
Desire,Shell Navigation,submitted
Betty,Shell Navigation,not submitted
John,Shell Navigation,submitted
Eva,Shell Navigation,not submitted
Mike,Shell Navigation,not submitted
Anna,Shell Navigation,submitted
Tom,Shell Navigation,submitted
Sara,Shell Navigation,not submitted
EOF

# Create startup.sh
echo "Creating startup.sh..."
cat << 'EOF' > "$base_dir/startup.sh"
#!/bin/bash

bash ./app/reminder.sh
EOF
# Set permissions to make scripts executable
chmod +x "$base_dir/app/reminder.sh"
chmod +x "$base_dir/modules/functions.sh"
chmod +x "$base_dir/startup.sh"

echo "Environment setup is complete!"
#In case you want to run the startup immediately while running this script, you need to remove # sign on the two lines below
#cd "$base_dir"
#./startup.sh
