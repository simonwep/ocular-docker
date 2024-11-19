#!/usr/bin/env bash
set -eu

ADMIN_PASSWORD=$(openssl rand -hex 16)

# Copy .env.example to .env if it doesn't exist
if [ ! -f "$(dirname "$0")/.env" ]; then
  cp "$(dirname "$0")/.env.example" "$(dirname "$0")/.env"
  echo "Copied .env.example to .env"
fi

# Generate random secrets and admin user
sed -i.bak \
    -e "s#GENESIS_JWT_SECRET=.*#GENESIS_JWT_SECRET=$(openssl rand -hex 32)#g" \
    -e "s#GENESIS_CREATE_USERS=admin!:.*#GENESIS_CREATE_USERS=admin!:$ADMIN_PASSWORD#g" \
    "$(dirname "$0")/.env"

echo "Created admin user with username 'admin' and password '$ADMIN_PASSWORD'"
