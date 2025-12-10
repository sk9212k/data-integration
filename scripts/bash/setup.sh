#!/usr/bin/env bash
set -e

echo "=== Data Integration Platform Setup Script ==="

# --- Helper function to check tool installation ---
check_installed() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "[OK] $1 is installed."
    else
        echo "[MISSING] $1 is NOT installed."
        MISSING_TOOLS+=("$1")
    fi
}

MISSING_TOOLS=()

echo "Checking required tools..."

check_installed az
check_installed bicep
check_installed docker
check_installed dotnet

echo ""
echo "Creating folder structure (idempotent)..."

mkdir -p api workers mappings schemas scripts/bash

echo "[OK] Folder structure ensured."

# --- Environment file creation ---
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cat <<EOF > .env
AZURE_SUBSCRIPTION_ID=
AZURE_TENANT_ID=
ENVIRONMENT=local
EOF
else
    echo "[OK] .env already exists, not overwriting."
fi

echo ""
echo "Validating setup..."

if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
    echo "All tools installed!"
else
    echo "Missing tools detected:"
    printf '%s\n' "${MISSING_TOOLS[@]}"
    echo "Please install the missing tools manually:"
    echo "Azure CLI: https://learn.microsoft.com/cli/azure/install-azure-cli"
    echo "Bicep: https://learn.microsoft.com/azure/azure-resource-manager/bicep/install"
    echo "Docker: https://docs.docker.com/get-docker/"
    echo ".NET 8 SDK: https://dotnet.microsoft.com/download/dotnet/8.0"
fi

echo "=== Setup script completed ==="


