# Global git hooks

Global git hooks, managed here in the dotfiles castle and symlinked into
`~/.config/git/hooks` by homeshick, so they follow every machine and can't
silently drift.

## `pre-push`

Refuses to push `agent/*` branches to any remote. `agent/*` branches are the
local, throwaway scratch created by the `/jxf:coding:execute` fan-out; anything
that needs to reach a remote belongs on a `topic/*` branch. Branch *deletions*
are still allowed, so an accidentally pushed `agent/*` branch can be cleaned up.

## How it's wired

`~/.gitconfig` sets, for every repo on the machine:

```ini
[core]
    hooksPath = /home/jxf/.config/git/hooks
```

`~/.config/git/hooks` is a homeshick symlink to this directory. After a fresh
`homeshick clone` (or when adding a new hook), run:

```sh
homeshick link dotfiles
```

Note: `core.hooksPath` replaces the per-repo `.git/hooks` lookup for every repo
on the machine, so any hook you rely on should live here too. To bypass the
hook for a single legitimate push: `git push --no-verify`.

## Tests

```sh
sh ~/.config/git/hooks/pre-push.test.sh
```

Asserts the two non-obvious behaviors — deletions stay allowed, and `agent/*` on
either the local or remote side is blocked — so a future edit can't regress them.
