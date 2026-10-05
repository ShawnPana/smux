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
- **smux-pane** CLI that lets closed panes and windows be reopened, like browser tabs
- **jq** if not already installed (used by smux-pane)

Everything lives in `~/.smux/`.

## Keybindings

All keybindings use **Option (Alt)** with no prefix required.

### Panes

| Key | Action |
|---|---|
| `Option+i/k/j/l` | Navigate up/down/left/right (no wrap) |
| `Option+Shift+i/k/j/l` | Swap pane with its neighbor up/down/left/right |
| `Option+n` | New pane (split + auto-tile) |
| `Option+w` | Close pane |
| `Option+Shift+w` | Close window |
| `Option+Shift+n` | Reopen the last closed pane or window (see [Reopening](#reopening-closed-panes-and-windows)) |
| `Option+o` | Cycle layouts |
| `Option+g` | Mark pane |
| `Option+y` | Swap with marked pane |

### Windows

| Key | Action |
|---|---|
| `Option+m` | New window, placed right after the current one |
| `Option+u` | Next window |
| `Option+h` | Previous window |
| `Option+Shift+u/h` | Move window right/left |

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

## Reopening closed panes and windows

Closing works like closing a browser tab: the process really ends, but enough is remembered to bring the pane back with `Option+Shift+n`.

- A pane returns to the slot it had in its window, with its label and working directory. If the window is gone, it is recreated at its old number.
- `Option+Shift+w` closes a whole window as one entry, and reopening brings back all of its panes together.
- A pane that was running **Claude Code resumes the exact conversation** it had. The session is read from the file Claude Code keeps for each running process, so it survives moving the pane around. Other processes are not restarted; you get a shell where they were.
- The last 25 closes are kept, newest first, and survive a tmux restart. Scrollback is not kept.

The keys call `smux-pane`, which you can also use directly:

| Command | Description |
|---|---|
| `smux-pane close <pane>` | Remember the pane, then kill it |
| `smux-pane close-window <pane>` | Remember every pane in the window, then kill the window |
| `smux-pane revive` | Reopen whatever was closed most recently |
| `smux-pane list` | Show what can be reopened, newest first |
| `smux-pane peek <pane>` | Show what closing a pane would record, without closing it |

Window numbers always match their position in the status bar: `Option+m` opens the new window right after the current one, and numbers close up when a window goes away.

## tmux-bridge

A CLI for cross-pane communication. Any tool that can run bash can use it — Claude Code, Codex, Gemini CLI, or a plain shell script.

| Command | Description |
|---|---|
| `tmux-bridge list` | Show all panes with target, process, label |
| `tmux-bridge read <target> [lines]` | Read last N lines from a pane |
| `tmux-bridge type <target> <text>` | Type text into a pane (no Enter) |
| `tmux-bridge keys <target> <key>...` | Send keys (Enter, Escape, C-c, etc.) |
| `tmux-bridge name <target> <label>` | Label a pane for easy addressing |
| `tmux-bridge resolve <label>` | Look up a pane by label |
| `tmux-bridge id` | Print this pane's ID |

See the [smux skill](skills/smux/SKILL.md) for full documentation on agent-to-agent workflows.

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
- jq (installed automatically)

## Sponsor

smux is free and maintained in my own time.
[Sponsoring](https://github.com/sponsors/ShawnPana) keeps it that way.
