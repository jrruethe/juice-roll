#!/bin/bash
# Azure Static Web App deployment script for Juice Roll
# Usage: ./deploy-azure.sh [resource-group] [static-web-app-name] [location]

set -e

# Default values
DEFAULT_RESOURCE_GROUP="rg-juice-roll"
DEFAULT_SWA_NAME="swa-juice-roll-$(date +%s | tail -c 5)"
DEFAULT_LOCATION="eastus2"

# Parse arguments
RESOURCE_GROUP="${1:-$DEFAULT_RESOURCE_GROUP}"
SWA_NAME="${2:-$DEFAULT_SWA_NAME}"
LOCATION="${3:-$DEFAULT_LOCATION}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Juice Roll Azure Static Web App Deployment ===${NC}"
echo ""
echo "Configuration:"
echo "  Resource Group: $RESOURCE_GROUP"
echo "  Static Web App Name: $SWA_NAME"
echo "  Location: $LOCATION"
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}Error: Azure CLI is not installed.${NC}"
    echo "Please install it from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if logged in to Azure
echo "Checking Azure login status..."
if ! az account show &> /dev/null; then
    echo -e "${YELLOW}Not logged in to Azure. Running 'az login'...${NC}"
    az login
fi

# Display current subscription
SUBSCRIPTION=$(az account show --query name -o tsv)
echo -e "${GREEN}Using subscription: $SUBSCRIPTION${NC}"
echo ""

# Create resource group if it doesn't exist
echo "Checking resource group..."
if ! az group show --name "$RESOURCE_GROUP" &> /dev/null; then
    echo -e "${YELLOW}Creating resource group: $RESOURCE_GROUP${NC}"
    az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
else
    echo "Resource group '$RESOURCE_GROUP' already exists."
fi

# Deploy Bicep template
echo ""
echo "Deploying Bicep template..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRA_DIR="$SCRIPT_DIR/../infra"

az deployment group create \
    --resource-group "$RESOURCE_GROUP" \
    --template-file "$INFRA_DIR/main.bicep" \
    --parameters staticWebAppName="$SWA_NAME" location="$LOCATION" sku="Free" \
    --query "properties.outputs" \
    --output table

echo ""
echo -e "${GREEN}Deployment complete!${NC}"

# Get and display the deployment token
echo ""
echo "Retrieving deployment token for GitHub Actions..."
DEPLOYMENT_TOKEN=$(az staticwebapp secrets list \
    --name "$SWA_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "properties.apiKey" \
    --output tsv 2>/dev/null || echo "")

if [ -n "$DEPLOYMENT_TOKEN" ]; then
    echo ""
    echo -e "${GREEN}=== IMPORTANT: GitHub Actions Setup ===${NC}"
    echo ""
    echo "Add this secret to your GitHub repository:"
    echo "  Secret name: AZURE_STATIC_WEB_APPS_API_TOKEN"
    echo "  Secret value: (shown below)"
    echo ""
    echo -e "${YELLOW}$DEPLOYMENT_TOKEN${NC}"
    echo ""
    echo "Steps:"
    echo "  1. Go to your GitHub repository"
    echo "  2. Navigate to Settings > Secrets and variables > Actions"
    echo "  3. Click 'New repository secret'"
    echo "  4. Name: AZURE_STATIC_WEB_APPS_API_TOKEN"
    echo "  5. Value: Paste the token above"
    echo ""
else
    echo -e "${YELLOW}Could not retrieve deployment token. You can get it manually:${NC}"
    echo "  az staticwebapp secrets list --name $SWA_NAME --resource-group $RESOURCE_GROUP --query 'properties.apiKey' -o tsv"
fi

# Get the default hostname
DEFAULT_HOSTNAME=$(az staticwebapp show \
    --name "$SWA_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "defaultHostname" \
    --output tsv 2>/dev/null || echo "")

if [ -n "$DEFAULT_HOSTNAME" ]; then
    echo ""
    echo -e "${GREEN}Your app will be available at: https://$DEFAULT_HOSTNAME${NC}"
fi
