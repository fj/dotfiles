# Post-work review

After finishing any nontrivial implementation task — and before reporting it
as complete — launch these reviewer subagents (defined in `agents/` next to
this file) in parallel on the resulting changes:

- `modularity-reviewer`
- `atomicity-reviewer`
- `test-quality-reviewer`

Then summarize their confirmed findings, fix anything high-severity, and only
then declare the work done. Skip the review only for trivial changes (docs,
comments, config tweaks with no runtime surface).

# Git worktrees

Do code work in a git worktree rather than directly on the main checkout when
appropriate: risky or exploratory changes, work on multiple independent tasks,
or any time the checkout already has unrelated in-progress work. Always use
worktrees when fanning out multiple subagents that modify files — give each
parallel workstream its own worktree so their changes cannot conflict. Remove
worktrees once their work is merged or abandoned.

# Coding guidelines

- Use virtual environments rather than installing into the system's shared instances of tools (e.g. Python).
- Do not invoke `python`, `python3`, or `pip` directly; use `uv` instead (e.g. `uv run`, `uv pip`, `uv venv`).
