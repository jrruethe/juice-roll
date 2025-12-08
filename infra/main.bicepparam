using './main.bicep'

// ============================================================================
// Azure Static Web App Parameters
// ============================================================================
// 
// INSTRUCTIONS:
// 1. Copy this file to main.bicepparam.local (or similar) for local deployments
// 2. Fill in your specific values
// 3. Deploy using: az deployment group create --resource-group <rg-name> --template-file main.bicep --parameters main.bicepparam
//
// NOTE: This file should NOT contain any sensitive or subscription-specific values
// when checked into source control.
// ============================================================================

// Required: Name for your Static Web App (must be globally unique)
param staticWebAppName = 'swa-juice-roll'

// Azure region for deployment
// Azure Static Web Apps is available in limited regions, see:
// https://azure.microsoft.com/en-us/global-infrastructure/services/?products=app-service
param location = 'eastus2'

// SKU tier: 'Free' for personal/hobby projects, 'Standard' for production
param sku = 'Free'

// Optional: Repository URL (leave empty to configure manually or via GitHub Actions)
param repositoryUrl = ''

// Optional: Branch name (only used if repositoryUrl is provided)
param repositoryBranch = 'main'

// Optional: Additional tags
param tags = {
  project: 'juice-roll'
  purpose: 'flutter-web-app'
}
