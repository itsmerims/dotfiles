# dotfiles

Personal developer configs, shell profiles, AI agent guidelines, design system, and workspace setup.

## Structure

```
dotfiles/
├── install.ps1      # Setup script to link/copy configs to system
├── terminal/        # WezTerm configuration (.wezterm.lua)
├── powershell/      # PowerShell profile (Microsoft.PowerShell_profile.ps1)
├── ai/              # CLAUDE.md, AGENTS.md, antigravity, opencode
├── design-system/   # Design guidelines, UI standards
└── dev/             # Dev scripts and environment tools
```

## Setup

Deploy configurations to system paths:

```powershell
# Copy configs into place (with automatic backups)
.\install.ps1

# Or symlink (run PowerShell as Administrator)
.\install.ps1 -Symlink
```
