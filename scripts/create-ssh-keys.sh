#!/bin/bash

# setup_github_ssh.sh
# A script to generate a new SSH key for GitHub and guide the user through adding it.

# 1. Setup variables
KEY_ALGO="ed25519"
DEFAULT_KEY_NAME="id_ed25519"
SSH_DIR="$HOME/.ssh"

echo "----------------------------------------------------"
echo "   GitHub SSH Key Generator"
echo "----------------------------------------------------"

# 2. Get User Email
read -r -p "Enter your GitHub email address: " USER_EMAIL
if [[ -z "$USER_EMAIL" ]]; then
	echo "Error: Email is required."
	exit 1
fi

# 3. Ask for custom filename (optional)
read -r -p "Enter file name for the key (Press Enter for default: $DEFAULT_KEY_NAME): " KEY_NAME
KEY_NAME=${KEY_NAME:-$DEFAULT_KEY_NAME}
KEY_PATH="$SSH_DIR/$KEY_NAME"

# 4. Create .ssh directory if it doesn't exist
if [ ! -d "$SSH_DIR" ]; then
	echo "Creating .ssh directory..."
	mkdir -p "$SSH_DIR"
	chmod 700 "$SSH_DIR"
fi

# 5. Generate the SSH Key
# We let ssh-keygen handle the password prompt securely.
echo ""
echo "Generating secure $KEY_ALGO key..."
echo "When prompted, set a strong passphrase (recommended)."
if ! ssh-keygen -t "$KEY_ALGO" -C "$USER_EMAIL" -f "$KEY_PATH"; then
	echo "Error: Key generation failed."
	exit 1
fi

echo "Adding key to agent..."
ssh-add "$KEY_PATH"

# 8. Output Instructions
echo ""
echo "----------------------------------------------------"
echo "   SUCCESS! Next Steps:"
echo "----------------------------------------------------"

if [ "$COPIED" = true ]; then
	echo "✅ The public key has been copied to your clipboard!"
else
	echo "⚠️  Could not auto-copy. Please manually copy the key below (starts with 'ssh-'):"
	echo ""
	echo "------------------ BEGIN PUBLIC KEY ------------------"
	cat "$KEY_PATH.pub"
	echo "------------------- END PUBLIC KEY -------------------"
	echo ""
fi

echo "1. Open https://github.com/settings/keys"
echo "2. Click 'New SSH key'"
echo "3. Title it whatever you want (e.g., 'My Laptop')"
echo "4. Paste the key into the 'Key' field"
echo "5. Click 'Add SSH key'"
echo "6. If you used a custom key name, add it to your agent config (e.g., keychain) so it loads automatically."
echo ""
echo "Test your connection by running: ssh -T git@github.com"
