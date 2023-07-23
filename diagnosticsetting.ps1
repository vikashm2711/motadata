# Set variables for the diagnostic setting
$ResourceGroupName = "motadata-rg"
$DiagnosticSettingName = "motadata-activity-logs-diagnostic-setting"
$TemplateUri = "https://raw.githubusercontent.com/Jayshreea0402/motadata/main/diagnostic-setting.json"

# Create the diagnostic setting for Event Hub using the template URI
# Download the diagnostic setting template file
$diagnosticSettingContent = (New-Object System.Net.WebClient).DownloadString($TemplateUri)

# Convert the JSON content to a PowerShell object
$diagnosticSettingTemplate = ConvertFrom-Json $diagnosticSettingContent

# Deploy the diagnostic setting using the template
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
    -TemplateObject $diagnosticSettingTemplate `
    -Name $DiagnosticSettingName

Write-Host "Diagnostic setting '$DiagnosticSettingName' created successfully."