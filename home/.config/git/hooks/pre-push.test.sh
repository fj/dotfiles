#!/bin/sh
#
# Tests for the pre-push hook. Run: sh ~/.config/git/hooks/pre-push.test.sh
#
# Feeds simulated pre-push stdin (see githooks(5)) to the hook and asserts the
# exit code, locking in the behaviors that are easy to break by accident:
# deletions stay allowed, and agent/* on EITHER the local or remote ref side is
# rejected.

set -u

HOOK="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/pre-push"
SHA=1111111111111111111111111111111111111111
Z40=0000000000000000000000000000000000000000
Z64=0000000000000000000000000000000000000000000000000000000000000000

FIX="$(mktemp)"
trap 'rm -f "$FIX"' EXIT
fail=0

# expect <exit> <desc> <payload with \n escapes>
expect() {
	printf '%b' "$3" > "$FIX"
	"$HOOK" origin url < "$FIX" >/dev/null 2>&1
	got=$?
	if [ "$got" -eq "$1" ]; then
		printf 'ok   %s\n' "$2"
	else
		printf 'FAIL %s (want %d, got %d)\n' "$2" "$1" "$got"
		fail=1
	fi
}

expect 1 "push agent/* is blocked"                 "refs/heads/agent/x $SHA refs/heads/agent/x $Z40\n"
expect 1 "nested agent/foo/bar is blocked"         "refs/heads/agent/foo/bar $SHA refs/heads/agent/foo/bar $Z40\n"
expect 1 "local topic pushed to remote agent/* is blocked" "refs/heads/topic/y $SHA refs/heads/agent/x $Z40\n"
expect 1 "mixed push (main + agent) is blocked"    "refs/heads/main $SHA refs/heads/main $SHA\nrefs/heads/agent/x $SHA refs/heads/agent/x $Z40\n"
expect 1 "agent/* line without trailing newline is blocked" "refs/heads/agent/x $SHA refs/heads/agent/x $Z40"

expect 0 "push topic/* is allowed"                 "refs/heads/topic/y $SHA refs/heads/topic/y $Z40\n"
expect 0 "push main is allowed"                    "refs/heads/main $SHA refs/heads/main $SHA\n"
expect 0 "delete agent/* (sha1 zero) is allowed"   "(delete) $Z40 refs/heads/agent/x $SHA\n"
expect 0 "delete agent/* (sha256 zero) is allowed" "(delete) $Z64 refs/heads/agent/x $SHA\n"
expect 0 "branch literally named 'agent' is allowed" "refs/heads/agent $SHA refs/heads/agent $Z40\n"
expect 0 "tag push is allowed"                     "refs/tags/v1 $SHA refs/tags/v1 $Z40\n"
expect 0 "empty stdin is allowed"                  ""

if [ "$fail" -eq 0 ]; then
	echo "All tests passed."
else
	echo "Some tests FAILED." >&2
fi
exit "$fail"
