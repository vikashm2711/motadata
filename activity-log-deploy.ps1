param (
    $SubscriptionId = "5807cfb0-41a6-4da6-b920-71d934d4a2af",
    $EventhubNamespace = "motadataEventhubNamespace",
    $FunctionAppName = "motadata-functionapp",
    $ResourceGroupLocation = "westus2",
    $ResourceGroupName = "motadata-rg",
    $EventhubName = "motadataEventhub",
    $FunctionName = "motadata-function",
    $DiagnosticSettingName = "motadata-activity-logs-diagnostic-setting"
)

# Set the Azure context to the specified subscription
Set-AzContext -SubscriptionId $SubscriptionId

# Download Python code for the function app
$functionCode = (New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/Jayshreea0402/motadata/main/__init__.py")

# Create a new resource group
New-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation
Write-Host "Resource group '$ResourceGroupName' created successfully."

# Deploy the Event Hub
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
    -TemplateUri "https://raw.githubusercontent.com/Jayshreea0402/motadata/main/eventHub.json" `
    -eventHubNamespace $EventhubNamespace `
    -eventHubName $EventhubName `
    -Location $ResourceGroupLocation
Write-Host "Event Hub '$EventhubName' deployed successfully."

# Create the Azure Function App
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
    -TemplateUri "https://raw.githubusercontent.com/Jayshreea0402/motadata/main/function-app.json" `
    -functionCode $functionCode `
    -functionName $FunctionName `
    -location $ResourceGroupLocation
Write-Host "Azure Function App '$FunctionName' deployed successfully."

# # # Create the diagnostic setting for Event Hubs
# $storageAccountId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Storage/storageAccounts/<storage-account-name>"
# $eventHubAuthorizationRuleId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.EventHub/namespaces/$EventhubNamespace/authorizationrules/<authorization-rule-name>"
# $eventHubRuleId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.EventHub/namespaces/$EventhubNamespace/eventhubs/$EventhubName/authorizationrules/RootManageSharedAccessKey"

# Set-AzDiagnosticSetting -ResourceId "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.EventHub/namespaces/$EventhubNamespace/eventhubs/$EventhubName" `
#     -Name $DiagnosticSettingName `
#     -StorageAccountId $storageAccountId `
#     -EventHubAuthorizationRuleId $eventHubAuthorizationRuleId `
#     -EventHubRuleId $eventHubRuleId `
#     -MetricCategory "AllMetrics" `
#     -LogCategory "AuditEvent"
# Write-Host "Diagnostic setting '$DiagnosticSettingName' created successfully."

Write-Host "Event Hub and Azure Function deployment completed successfully."
