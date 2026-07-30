#!/usr/bin/env bash
# Stop hook: block Claude from finishing if implementation changes exist but
# the post-work review hasn't run. The reviewers themselves never write, so
# Claude touches the marker file once the review is resolved.
set -u

marker=".claude/.review-done"

# Not a git repo, or nothing changed vs default branch and working tree clean:
# nothing to review.
git rev-parse --git-dir >/dev/null 2>&1 || exit 0
default_branch=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
default_branch=${default_branch:-main}

if git diff --quiet 2>/dev/null \
   && git diff --cached --quiet 2>/dev/null \
   && git diff --quiet "${default_branch}...HEAD" 2>/dev/null; then
  exit 0
fi

if [ -f "$marker" ]; then
  rm -f "$marker"
  exit 0
fi

cat >&2 <<'MSG'
Implementation changes detected but the post-work review has not run.
Run it as the Post-work review section of your global instructions describes:
review the diff, then resolve what it finds — high-severity findings fixed and
re-verified, medium and low fixed or explicitly deferred with a reason, nothing
left silently outstanding. Then `touch .claude/.review-done` and finish.
MSG
exit 2
