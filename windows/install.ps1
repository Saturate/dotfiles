# Windows Setup Script
# Run as Administrator in PowerShell:
#   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#   .\install.ps1

Write-Host "`n========================================" -ForegroundColor Blue
Write-Host "     Windows Setup Script" -ForegroundColor Blue
Write-Host "========================================`n" -ForegroundColor Blue

# =============================================================================
# Windows Settings
# =============================================================================

Write-Host "Configuring Windows settings..." -ForegroundColor Cyan

# Show file extensions
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# Show hidden files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1

# Disable Bing search in Start Menu
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -ErrorAction SilentlyContinue

# Dark mode
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0

Write-Host "  Windows settings applied" -ForegroundColor Green

# =============================================================================
# WinGet Packages
# =============================================================================

Write-Host "`nInstalling packages via WinGet..." -ForegroundColor Cyan

$packages = @(
    # Browsers
    "Mozilla.Firefox.DeveloperEdition"
    "Google.Chrome.Dev"

    # Dev tools
    "Microsoft.VisualStudioCode"
    "Git.Git"
    "GitHub.cli"
    "Ghostty.Ghostty"
    "OpenJS.NodeJS.LTS"
    "oven-sh.Bun"
    "GoLang.Go"
    "Python.Python.3.13"
    "Rustlang.Rust.MSVC"
    "Microsoft.DotNet.SDK.8"

    # Modern CLI tools
    "Starship.Starship"
    "eza-community.eza"
    "sharkdp.bat"
    "sharkdp.fd"
    "BurntSushi.ripgrep.MSVC"
    "ajeetdsouza.zoxide"
    "junegunn.fzf"
    "dandavison.delta"

    # Productivity
    "AgileBits.1Password"
    "Obsidian.Obsidian"
    "Dropbox.Dropbox"
    "RARLab.WinRAR"

    # Communication
    "Microsoft.Teams"
    "OpenWhisperSystems.Signal"
    "Discord.Discord"

    # Entertainment
    "Valve.Steam"
    "Spotify.Spotify"

    # Utilities
    "voidtools.Everything"
    "Microsoft.PowerToys"
    "Rancher.RancherDesktop"
)

foreach ($package in $packages) {
    Write-Host "  Installing $package..." -ForegroundColor Gray
    winget install --id $package --accept-source-agreements --accept-package-agreements --silent 2>$null
}

# =============================================================================
# PowerShell Profile
# =============================================================================

Write-Host "`nSetting up PowerShell profile..." -ForegroundColor Cyan

$profileDir = Split-Path $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$profileContent = Get-Content "$PSScriptRoot\Microsoft.PowerShell_profile.ps1" -ErrorAction SilentlyContinue
if ($profileContent) {
    Copy-Item "$PSScriptRoot\Microsoft.PowerShell_profile.ps1" $PROFILE -Force
    Write-Host "  PowerShell profile installed to $PROFILE" -ForegroundColor Green
}

# =============================================================================
# Shared Configs
# =============================================================================

Write-Host "`nInstalling shared configs..." -ForegroundColor Cyan

$repoRoot = Split-Path $PSScriptRoot
$commonDir = Join-Path $repoRoot "common"

# Starship
$starshipDir = "$env:USERPROFILE\.config"
if (-not (Test-Path $starshipDir)) { New-Item -ItemType Directory -Path $starshipDir -Force | Out-Null }
Copy-Item "$commonDir\starship.toml" "$starshipDir\starship.toml" -Force
Write-Host "  Installed starship.toml" -ForegroundColor Green

# Ghostty
$ghosttyDir = "$env:APPDATA\Ghostty"
if (-not (Test-Path $ghosttyDir)) { New-Item -ItemType Directory -Path $ghosttyDir -Force | Out-Null }
Copy-Item "$commonDir\ghostty\config" "$ghosttyDir\config" -Force
Write-Host "  Installed Ghostty config" -ForegroundColor Green

# Git
Copy-Item "$commonDir\.gitconfig" "$env:USERPROFILE\.gitconfig" -Force
Write-Host "  Installed .gitconfig" -ForegroundColor Green

# Check 1Password SSH signing
$sshProgram = git config --global gpg.ssh.program 2>$null
if (-not $sshProgram) {
    Write-Host "  1Password SSH signing not configured" -ForegroundColor Yellow
    Write-Host "  Open 1Password > Settings > Developer > enable 'Sign Git commits with SSH'" -ForegroundColor Yellow
}

# =============================================================================
# Done
# =============================================================================

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  Setup complete!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Restart your terminal"
Write-Host "  2. Sign into 1Password and enable SSH agent + git signing"
Write-Host "  3. Run 'p10k configure' if using PowerShell profile"
Write-Host ""
