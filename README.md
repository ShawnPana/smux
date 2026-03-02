# tmux + Claude Code Config

Tmux configuration and Claude Code settings, including a hook that turns your tmux pane red when Claude Code needs approval.

## Setup

Clone the repo and create symlinks:

```bash
git clone https://github.com/ShawnPana/tmux-config.git ~/Projects/tmux-config

# Tmux config
ln -sf ~/Projects/tmux-config/.tmux.conf ~/.config/tmux/tmux.conf

# Claude Code settings
ln -sf ~/Projects/tmux-config/claude-settings.json ~/.claude/settings.json

# Pane alert script
mkdir -p ~/.config/tmux
ln -sf ~/Projects/tmux-config/scripts/claude-pane-alert.sh ~/.config/tmux/claude-pane-alert.sh
```

Reload tmux config:

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

Restart any running Claude Code sessions to pick up the new hooks.

## What's included

### Tmux

- **Option+arrow** pane navigation
- **Option+n** split and tile, **Option+w** kill pane
- **Option+o** cycle layouts, **Option+m** new window
- **Option+u/h** next/previous window
- **Option+Tab** scroll mode (i/k to scroll, q to exit)
- Mouse support with auto-copy to clipboard

### Claude Code

- **Pane alert hook** — pane background turns red when Claude Code shows a permission prompt, resets when you approve or when Claude finishes responding
- MCP server configs (Adobe Premiere Pro, Browser Use)

## How the pane alert works

Three hooks in `claude-settings.json`:

| Event | Action |
|---|---|
| `PermissionRequest` | Pane turns red |
| `PostToolUse` | Pane resets (approved, tool ran) |
| `Stop` | Pane resets (fallback) |

The script uses `$TMUX_PANE` to target only the correct pane — no interference with other panes.
