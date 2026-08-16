# Guidelines for agents

## Agent responses

- Write all prose in ASD-STE100 (Simplified Technical English).
- Follow Zinsser's four principles of Simplicity, Brevity, Clarity, and Humanity.
  - Scope: chat replies, commit messages, docs, comments, and PRs.
  - Not in scope:
    - quoted text, log lines, or error messages
    - code, which follows its conventions

## Post-work review

After finishing any nontrivial implementation task — and before reporting it as complete — review the resulting changes with these subagents (defined in `agents/` next to this file):

- `modularity-reviewer`
- `atomicity-reviewer`
- `test-quality-reviewer`

Run them through the `jxf:coding:write:post` workflow rather than launching them yourself: it invokes all three in parallel, asks each for structured findings carrying an explicit severity, and returns one merged list ranked most-severe first. Launching them directly instead yields three separately ranked lists with no severity labels to gate on, because `ReportFindings` has no severity field and the reviewers express severity as ordering.

These three deliberately cover only what `/code-review` does not. Correctness bugs, duplicated logic, dead code, and fixes applied at the wrong depth are its own angles, and it can only be invoked by the user — so run it too when the change warrants a full review, and say so rather than assuming those dimensions were covered.

* Report workflow's `reportFindings` list through a single `ReportFindings` call.
  - It is already ranked and projected to the tool's fields, and capped at the tool's limit of 32, so say how many were omitted.
  - Re-report it with each finding's `outcome` set (`fixed` / `skipped` / `no_change_needed`) once fixes are applied.

* Resolve findings rather than merely reporting them.
  - High-severity findings should be fixed and re-verified before the work is declared done.
  - Medium and low findings are either fixed or explicitly deferred, with the reason appended to that finding's `summary` when you set `outcome: skipped`.
  - Nothing is left silently outstanding.

* Skip reviews only for trivial changes (docs, comments, config tweaks with no runtime surface).

## Git worktrees

Do code work in a git worktree rather than directly on the main checkout when appropriate:

- Risky changes
- Investigative explorations
- Work on multiple independent tasks
- Any time the checkout already has unrelated in-progress work

Additionally:

- Always use worktrees when fanning out multiple subagents that modify files.
- Remove worktrees once their work is merged, stale, or abandoned.

## Coding guidelines

- Comments:
  - Strive to make code so straightforward that it doesn't need comments at all. The default is no comments.
  - If comments are absolutely necessary, they should be terse and deal with the immediate code, at most a sentence or two.
  - If code is confusing without the comments, simplify or further modularize the code rather than expand the comment.
  - Do not reference historical past events leading to the existence of a code snippet, unless it is a truly unusual exception worth noting.

- Avoid using magic numbers. If a number is used in code and is not 0, 1, or -1, give it a useful name and use the name instead.

- Commit messages:
  - Should generally take the form of [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) style.
  - Strive for brevity and concision; a couple of sentences maximum of further explanation per commit.
  - If it's more complicated than that, the commit should be smaller.

## Tool use guidelines

- Use virtual environments rather than installing into the system's shared instances of tools (e.g. Python).
- Do not invoke `python`, `python3`, or `pip` directly; use `uv` instead (e.g. `uv run`, `uv pip`, `uv venv`).

## Markdown

- Markdown paragraphs should not get line breaks to justify text. One line per paragraph.

## Subagents

- Aggressively use subagents (if appropriate and available) when conducting exploration or parallel work to avoid polluting the main context.
- Do this even if only one activity is happening.

## Temporary files

- When you create temporary files, do so in `/tmp/claude-agents/agent-{{session-id}}-{{iso-8601-timestamp}}/*`.
