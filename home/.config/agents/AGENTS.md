# Guidelines for agents

## Post-work review

After finishing any nontrivial implementation task — and before reporting it as complete — review the resulting changes with these subagents (defined in `agents/` next to this file):

- `modularity-reviewer`
- `atomicity-reviewer`
- `test-quality-reviewer`

Run them through the `jxf:coding:write:post` workflow rather than launching them yourself: it invokes all three in parallel, asks each for structured findings carrying an explicit severity, and returns one merged list ranked most-severe first. Launching them directly instead yields three separately ranked lists with no severity labels to gate on, because `ReportFindings` has no severity field and the reviewers express severity as ordering.

These three deliberately cover only what `/code-review` does not. Correctness bugs, duplicated logic, dead code, and fixes applied at the wrong depth are its own angles, and it can only be invoked by the user — so run it too when the change warrants a full review, and say so rather than assuming those dimensions were covered.

Report the workflow's `reportFindings` list through a single `ReportFindings` call — it is already ranked and projected to the tool's fields, and capped at the tool's limit of 32, so say how many were omitted — and re-report it with each finding's `outcome` set (`fixed` / `skipped` / `no_change_needed`) once fixes are applied.

Resolve findings rather than merely reporting them: every high-severity finding must be fixed and re-verified before the work is declared done, and medium and low findings are either fixed or explicitly deferred, with the reason appended to that finding's `summary` when you set `outcome: skipped`. Nothing is left silently outstanding.

Skip the review only for trivial changes (docs, comments, config tweaks with no runtime surface).

## Git worktrees

Do code work in a git worktree rather than directly on the main checkout when appropriate:

- risky changes
- investigative explorations
- work on multiple independent tasks
- any time the checkout already has unrelated in-progress work

Additionally:

- Always use worktrees when fanning out multiple subagents that modify files.
- Remove worktrees once their work is merged or abandoned.

## Coding guidelines

- Comments:
  - Be sparing with the use of comments. They should be terse and deal with the immediate code, at most a sentence or two.
  - Do not reference past events leading to the existence of a code snippet, unless it is a truly unusual exception worth noting.
  - If the code is confusing without the comments, simplify or further modularize the code rather than expand the comment.
- Avoid using magic numbers. If a number is not 0, 1, or -1, give it a name and use the name instead.

## Tool use guidelines

- Use virtual environments rather than installing into the system's shared instances of tools (e.g. Python).
- Do not invoke `python`, `python3`, or `pip` directly; use `uv` instead (e.g. `uv run`, `uv pip`, `uv venv`).

## Markdown

- Markdown paragraphs should not get line breaks to justify text. One line per paragraph.

## Subagents

- Aggressively use subagents (if appropriate and available) when conducting exploration or parallel work to avoid polluting the main context. Do this even if only one activity is happening.

## Temporary files

- When you create temporary files, do so in `/tmp/claude/agent-{{session-id}}-{{iso-8601-timestamp}}/*`.
