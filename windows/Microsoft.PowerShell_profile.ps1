# PowerShell Profile

# =============================================================================
# Prompt (Starship)
# =============================================================================
Invoke-Expression (&starship init powershell)

# =============================================================================
# Tool Initializations
# =============================================================================
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# =============================================================================
# Aliases (modern CLI tools)
# =============================================================================
Set-Alias -Name cat -Value bat -Option AllScope
Set-Alias -Name grep -Value rg -Option AllScope
Set-Alias -Name find -Value fd -Option AllScope
Set-Alias -Name top -Value btop -Option AllScope

# eza (ls replacement)
function ls { eza --icons @args }
function ll { eza -lh --icons @args }
function la { eza -lah --icons @args }
function lt { eza -lah --icons --tree --level=2 @args }

# =============================================================================
# Navigation
# =============================================================================
function .. { Set-Location .. }
function ... { Set-Location ..\.. }

# =============================================================================
# Git Shortcuts
# =============================================================================
function gs { git status @args }
function ga { git add @args }
function gc { git commit @args }
function gp { git push @args }
function gd { git diff @args }
function gl { git log --oneline --graph --decorate @args }

# =============================================================================
# Utilities
# =============================================================================
function mkcd { param($dir) New-Item -ItemType Directory -Path $dir -Force; Set-Location $dir }
function weather { param($city) curl "wttr.in/$city" }
function killport { param($port) Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess | Stop-Process -Force }

# =============================================================================
# 1Password SSH Agent
# =============================================================================
$env:SSH_AUTH_SOCK = "$env:USERPROFILE\AppData\Local\1Password\app\8\ssh-agent.sock"

# =============================================================================
# Secrets (managed by 1Password)
# =============================================================================
$envFile = "$env:USERPROFILE\.env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*#' -or $_ -match '^\s*$') { return }
        $key, $value = $_ -split '=', 2
        [System.Environment]::SetEnvironmentVariable($key.Trim(), $value.Trim(), 'Process')
    }
}
