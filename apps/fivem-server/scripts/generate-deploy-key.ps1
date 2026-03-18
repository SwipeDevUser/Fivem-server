# Generate SSH key pair for GitHub Actions deployments
# Usage: .\scripts\generate-deploy-key.ps1
# Generates deploy_key (private) and deploy_key.pub (public)

param(
    [string]$KeyPath = ".\deploy_key",
    [string]$Comment = "GitHub Actions FiveM Deploy Key"
)

Write-Host "Generating SSH key pair for deployments..."
Write-Host "Key path: $KeyPath"
Write-Host ""

# Check if ssh-keygen is available
$sshKeygen = Get-Command ssh-keygen -ErrorAction SilentlyContinue
if (-not $sshKeygen) {
    Write-Host "ERROR: ssh-keygen not found. Make sure Git for Windows is installed." -ForegroundColor Red
    exit 1
}

# Generate key (no passphrase)
ssh-keygen -t rsa -b 4096 -f $KeyPath -N "" -C $Comment

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ SSH key pair generated successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Files created:"
    Write-Host "  Private key: $KeyPath (keep secret!)"
    Write-Host "  Public key:  $KeyPath.pub"
    Write-Host ""
    
    # Display private key for GitHub Secrets
    Write-Host "📋 COPY THIS → GitHub Secrets 'SSH_PRIVATE_KEY':" -ForegroundColor Yellow
    Write-Host "---" 
    Get-Content $KeyPath
    Write-Host "---"
    Write-Host ""
    
    # Display public key for servers
    Write-Host "📋 COPY THIS → ~/.ssh/authorized_keys on each deployment host:" -ForegroundColor Yellow
    Write-Host "---"
    Get-Content "$KeyPath.pub"
    Write-Host "---"
    Write-Host ""
    
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. On each BLUE/GREEN host, add the public key to ~/.ssh/authorized_keys"
    Write-Host "2. In GitHub repo Settings → Secrets → New secret 'SSH_PRIVATE_KEY'"
    Write-Host "3. Paste the private key content above"
} else {
    Write-Host "ERROR: Failed to generate SSH key" -ForegroundColor Red
    exit 1
}
