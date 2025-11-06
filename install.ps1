param(
  [string]$TargetPath = "C:\Users\Veteran\Documents\GitHub"
)

$ErrorActionPreference = "Stop"

Write-Host "Creating target path: $TargetPath" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $TargetPath | Out-Null

$repoName = "shopify-store-builder-pro"
$dest = Join-Path $TargetPath $repoName

Write-Host "Copying repository to $dest" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $dest | Out-Null

# Copy all files from the current script directory (assuming extracted ZIP)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item -Recurse -Force -Path (Join-Path $scriptDir $repoName "*") -Destination $dest

# Initialize git repo if needed
if (!(Test-Path (Join-Path $dest ".git"))) {
  Write-Host "Initializing git..." -ForegroundColor Cyan
  Push-Location $dest
  git init
  git add .
  git commit -m "feat: initial repository setup with complete documentation"
  Pop-Location
}

Write-Host "Done! Repository is at $dest" -ForegroundColor Green
