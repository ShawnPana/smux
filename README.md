# smux

One-command tmux setup with terminal automation for AI agents.

- **For you** — keyboard-driven tmux config with Option-key bindings, mouse support, and pane labels
- **For agents** — `tmux-bridge` CLI lets any agent read, type, and send keys to any pane
- **Agent-to-agent** — Claude Code can prompt Codex in the next pane, and Codex replies back. Any agent that can run bash can participate.

```bash
tmux-bridge read codex 20          # read the pane
tmux-bridge type codex "review src/auth.ts"  # type into it
tmux-bridge keys codex Enter       # press enter
```

https://github.com/user-attachments/assets/9d5463ba-5972-4bbd-a07e-b585f1178011

## Install

```bash
curl -fsSL https://shawnpana.com/smux/install.sh | bash
```

This installs:
- **tmux** if not already installed (via Homebrew, apt, dnf, pacman, or apk)
- **tmux.conf** with Option-key bindings, mouse support, pane labels, and a minimal status bar
- **tmux-bridge** CLI for cross-pane agent communication

Everything lives in `~/.smux/`.

## Keybindings

All keybindings use **Option (Alt)** with no prefix required.

### Panes

| Key | Action |
|---|---|
| `Option+i/k/j/l` | Navigate up/down/left/right (no wrap) |
| `Option+Shift+i/k/j/l` | Swap pane with neighbor up/down/left/right (no wrap) |
| `Option+z` / `Option+Shift+z` | Undo / redo pane resizing |
| `Option+n` | New pane (split + auto-tile) |
| `Option+w` | Close pane |
| `Option+o` | Cycle layouts |
| `Option+g` | Mark pane |
| `Option+y` | Swap with marked pane |

> Undo/redo (`Option+z` / `Option+Shift+z`) covers pane **resizing** — including
> mouse-drag resizes, which collapse into a single step. It can't undo a split,
> swap, or close: tmux can't re-create a closed pane or reorder panes by replaying
> a saved layout, so undo stops at those boundaries.

### Windows

| Key | Action |
|---|---|
| `Option+m` | New window |
| `Option+u` | Next window |
| `Option+h` | Previous window |
| `Option+Shift+u` | Move window forward in the list (no wrap) |
| `Option+Shift+h` | Move window backward in the list (no wrap) |
| `Option+s` | Toggle the status bar (navbar) |

### Scrolling

| Key | Action |
|---|---|
| `Option+Tab` | Toggle scroll mode |
| `i/k` | Scroll up/down |
| `Shift+I/K` | Half-page up/down |
| `q` or `Escape` | Exit scroll mode |

### Mouse

- Click to select panes
- Drag to select text (auto-copies to clipboard)
- Scroll wheel to scroll

## tmux-bridge

A CLI for cross-pane communication. Any tool that can run bash can use it — Claude Code, Codex, Gemini CLI, or a plain shell script.

| Command | Description |
|---|---|
| `tmux-bridge list` | Show all panes with target, process, label |
| `tmux-bridge read <target> [lines]` | Read last N lines from a pane |
| `tmux-bridge type <target> <text>` | Type text into a pane (no Enter) |
| `tmux-bridge keys <target> <key>...` | Send keys (Enter, Escape, C-c, etc.) |
| `tmux-bridge name [target] <label>` | Label a pane (defaults to the current pane) |
| `tmux-bridge resolve <label>` | Look up a pane by label |
| `tmux-bridge id` | Print this pane's ID |

See the [smux skill](skills/smux/SKILL.md) for full documentation on agent-to-agent workflows.

## Rename a pane

From inside any pane, label the pane you're typing in (shown in its border):

```bash
smux rename api-server
```

Equivalent: `tmux-bridge name api-server`.

## Update

```bash
smux update
```

## Uninstall

```bash
smux uninstall
```

## AI Agent Skills

Install the smux skill to teach your agents how to use tmux-bridge:

```bash
npx skills add ShawnPana/smux
```

Works with Claude Code, Codex, Cursor, Copilot, and [40+ other agents](https://skills.sh).

## Requirements

- macOS (requires [Homebrew](https://brew.sh)) or Linux
- tmux 3.2+ (installed automatically)
