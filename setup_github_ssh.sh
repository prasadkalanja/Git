#!/bin/bash

# Prompt for your email (default: Gmail)
read -p "Enter your GitHub email (default: your_gmail@gmail.com): " email
email=${email:-your_gmail@gmail.com}

# Generate SSH key
echo "Generating SSH key..."
ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/github_ssh_key -N ""

# Add the SSH key to the ssh-agent
echo "Adding SSH key to ssh-agent..."
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_ssh_key

# Display public key to copy
echo "Your SSH key has been generated. Here's your public key:"
cat ~/.ssh/github_ssh_key.pub

echo
read -p "Do you want to upload the SSH key to GitHub automatically? (y/n): " upload_choice

if [[ $upload_choice == "y" || $upload_choice == "Y" ]]; then
  # Ask for GitHub username and token
  read -p "Enter your GitHub username: " github_user
  read -sp "Enter your GitHub personal access token: " github_token
  echo

  # Upload SSH key to GitHub using the API
  ssh_key=$(cat ~/.ssh/github_ssh_key.pub)
  curl -u "$github_user:$github_token" \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"title\": \"$(hostname) SSH Key\", \"key\": \"$ssh_key\"}" \
    https://api.github.com/user/keys

  if [[ $? -eq 0 ]]; then
    echo "SSH key successfully uploaded to GitHub."
  else
    echo "Failed to upload the SSH key to GitHub. Please check your credentials."
  fi
else
  echo "You chose not to upload the key automatically."
  echo "Please add the following public key to your GitHub account manually:"
  echo
  echo "1. Copy the following key:"
  echo
  cat ~/.ssh/github_ssh_key.pub
  echo
  echo "2. Open: https://github.com/settings/keys"
  echo "3. Click 'New SSH Key', paste the key, and save."
fi

# Configure Git to use SSH for GitHub
echo "Configuring Git to use SSH for GitHub..."
git config --global user.email "$email"
git config --global user.name "$github_user"
git config --global core.sshCommand "ssh -i ~/.ssh/github_ssh_key"

echo "Setup complete. You can now use Git with SSH to push code to GitHub!"
