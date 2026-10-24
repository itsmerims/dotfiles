<#
.SYNOPSIS
    Links or copies dotfiles to user system paths.
#>

[CmdletBinding()]
param(
    [switch]$Symlink
)

$dotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 1. WezTerm
$weztermSrc = Join-Path $dotfilesDir "terminal\.wezterm.lua"
$weztermDst = Join-Path $HOME ".wezterm.lua"

# 2. PowerShell Profile
$profileSrc = Join-Path $dotfilesDir "powershell\Microsoft.PowerShell_profile.ps1"
$profileDst = $PROFILE

# Ensure profile directory exists
$profileDir = Split-Path -Parent $profileDst
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# 3. Antigravity MCP Config
$antigravityMcpSrc = Join-Path $dotfilesDir "ai\antigravity\mcp_config.json"
$antigravityMcpDst = Join-Path $HOME ".gemini\config\mcp_config.json"

# 4. OpenCode Configs
$opencodeDir = Join-Path $HOME ".config\opencode"
$opencodeJsonSrc = Join-Path $dotfilesDir "ai\opencode\opencode.json"
$opencodeJsonDst = Join-Path $opencodeDir "opencode.json"
$opencodeJsoncSrc = Join-Path $dotfilesDir "ai\opencode\opencode.jsonc"
$opencodeJsoncDst = Join-Path $opencodeDir "opencode.jsonc"
$opencodeCliSrc = Join-Path $dotfilesDir "ai\opencode\cli.json"
$opencodeCliDst = Join-Path $opencodeDir "cli.json"

function Deploy-Config($src, $dst, [switch]$useLink) {
    if (-not (Test-Path $src)) {
        Write-Warning "Source not found: $src"
        return
    }

    $dstParent = Split-Path -Parent $dst
    if (-not (Test-Path $dstParent)) {
        New-Item -ItemType Directory -Path $dstParent -Force | Out-Null
    }

    if (Test-Path $dst) {
        $backup = "$dst.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Move-Item -Path $dst -Destination $backup -Force
        Write-Host "Backed up existing $(Split-Path -Leaf $dst) to $backup" -ForegroundColor Yellow
    }

    if ($useLink) {
        New-Item -ItemType SymbolicLink -Path $dst -Target $src -Force | Out-Null
        Write-Host "Symlinked $dst -> $src" -ForegroundColor Green
    } else {
        Copy-Item -Path $src -Destination $dst -Force
        Write-Host "Copied $src -> $dst" -ForegroundColor Green
    }
}

Deploy-Config -src $weztermSrc -dst $weztermDst -useLink:$Symlink
Deploy-Config -src $profileSrc -dst $profileDst -useLink:$Symlink
Deploy-Config -src $antigravityMcpSrc -dst $antigravityMcpDst -useLink:$Symlink
Deploy-Config -src $opencodeJsonSrc -dst $opencodeJsonDst -useLink:$Symlink
Deploy-Config -src $opencodeJsoncSrc -dst $opencodeJsoncDst -useLink:$Symlink
Deploy-Config -src $opencodeCliSrc -dst $opencodeCliDst -useLink:$Symlink

Write-Host "Dotfiles deployment complete." -ForegroundColor Cyan
