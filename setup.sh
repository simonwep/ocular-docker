#!/usr/bin/env bash
set -eu

# Function to check if a command exists
command_exists() {
  $1 &>/dev/null
}

# Function to get the latest release version from a GitHub repository
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}

# Check if Docker is installed
if ! command_exists docker; then
  echo "Docker is not installed. Please install Docker and try again."
  exit 1
fi

# Check if Docker Compose is installed
if ! command_exists "docker compose"; then
  echo "Docker Compose is not available. Please install the latest version of Docker and try again."
  exit 1
fi

# Get the latest release version
repository="simonwep/ocular-docker"
latest_version=$(get_latest_release "$repository")
latest_version_clean="${latest_version#v}"
echo "The latest release version of $repository is $latest_version"

# Check if the folder already exists and if it should be removed first
if [ -d "ocular-docker-$latest_version_clean" ]; then
  echo "The folder ocular-docker-$latest_version_clean already exists."
  read -r -p " ? Do you want to remove it and continue? This will remove all data! (yes/no): " confirm
  if [ "$confirm" == "yes" ]; then
    echo " ✔ Removing existing folder..."
    rm -rf "ocular-docker-$latest_version_clean"
  else
    echo " ⅹ Aborting setup."
    exit 1
  fi
fi

# Download the latest release source code
echo "Downloading the latest release source code..."
curl -sL "https://github.com/$repository/archive/refs/tags/$latest_version.tar.gz" -o ocular-docker.tar.gz

# Extract the release
echo " → Extracting the release..."
tar -xzf ocular-docker.tar.gz
rm -rf ocular-docker.tar.gz
cd "ocular-docker-$latest_version_clean" || { echo "Failed to enter the ocular-docker directory"; exit 1; }

# Copy .env.example to .env
echo "Setting up environment variables..."
cp .env.example .env

# Ask the user if the service should be available via HTTP
read -r -p " ? Should the service be available via HTTP? (yes/no): " allow_http
if [ "$allow_http" == "yes" ]; then
  sed -i.bak 's/GENESIS_JWT_COOKIE_ALLOW_HTTP=false/GENESIS_JWT_COOKIE_ALLOW_HTTP=true/' .env
  echo " ✔ The service will be available via HTTP."
else
  echo " ⅹ The service will not be available via HTTP."
fi

# Generate secrets and an initial admin user
echo "Generating secrets and an initial admin user..."
./gen-passwords.sh > /dev/null

# Start Docker Compose services
echo "Starting Docker Compose services..."
docker compose up -d

# Extract generated credentials
GENESIS_CREATE_USERS=$(grep 'GENESIS_CREATE_USERS' .env | cut -d '=' -f2)
ADMIN_USER=$(echo "$GENESIS_CREATE_USERS" | cut -d '!' -f1)
ADMIN_PASSWORD=$(echo "$GENESIS_CREATE_USERS" | cut -d ':' -f2)

# Texts for the info box
texts=(
  "Setup complete!"
  "Ocular should be accessible under http://localhost:3030 in your browser :)"
  ""
  "You can log in as admin using the following credentials:"
  " → Username: $ADMIN_USER"
  " → Password: $ADMIN_PASSWORD"
  ""
  "What's next?"
  " → cd into the 'ocular-docker-$latest_version_clean' directory and run 'docker compose down' to stop the services."
  " → your data is located under the 'ocular-docker-$latest_version_clean/data' directory."
)

# Print info box
max_length=$(printf "%s\n" "${texts[@]}" | awk '{ if ( length > L ) { L=length } } END { print L }')
box_width=$((max_length + 4))

printf '┌%*s┐\n' "$box_width" '' | tr ' ' '─'
for text in "${texts[@]}"; do
  printf "│ %-${max_length}s   │\n" "$text"
done
printf '└%*s┘\n' "$box_width" '' | tr ' ' '─'
