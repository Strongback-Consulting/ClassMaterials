#!/bin/sh
# Fold every Strongback commit back into "As delivered", so the published
# history is always exactly the three commits the labs read. Strongback
# maintainers only - see README.md here.
#
#   maintainer/rebuild-history.sh           rebuild and verify; change nothing
#   maintainer/rebuild-history.sh --push    ...then force-push it to origin
#
# Why: the labs treat class-start..main as "the maintenance history" and
# class-start..stable-lab as "what changed in class". A Strongback change
# committed on top of the two maintenance commits would show up in both.
# Run this after committing such a change and before publish.sh.
#
# It rebuilds from the current main: the whole tree goes into "As
# delivered" except src/cobol/SANDBOX.cbl, which is taken from class-start,
# and git-bootstrap.sh then adds the two maintenance commits. It refuses
# to push unless the rebuilt main has exactly the same tree as today's -
# so a change to SANDBOX.cbl itself, which this cannot fold, stops it.
#
# Afterwards: run maintainer/backup.sh, then maintainer/publish.sh.

set -eu

say() { printf '%s\n' "$*"; }
die() { printf 'rebuild-history: %s\n' "$*" >&2; exit 1; }

PUSH=no
[ "${1:-}" = "--push" ] && PUSH=yes

TOP=$(git rev-parse --show-toplevel 2>/dev/null) || die "not inside a git repository."
cd "$TOP"
[ -f ClassMaterials.code-workspace ] || die "this is not a ClassMaterials repository."
origin=$(git remote get-url origin 2>/dev/null) || die "no 'origin' remote."
case "$origin" in
    *Strongback-Consulting/ClassMaterials*) die "origin is the PUBLIC repository. Run this in the private source repository." ;;
esac
[ -z "$(git status --porcelain)" ] || die "commit or stash your changes first."
git fetch -q --tags origin
[ "$(git rev-parse main)" = "$(git rev-parse origin/main)" ] || die "main does not match origin/main - push or pull first."
git rev-parse -q --verify refs/tags/class-start >/dev/null || die "there is no class-start tag to rebuild from."

n=$(git rev-list --count main)
if [ "$n" -eq 3 ]; then
    say "main is already the three teaching commits - nothing to fold."
    exit 0
fi
say "main has $n commits; folding the $((n - 3)) after the teaching history into \"As delivered\"."

SCRATCH=$(mktemp -d "${TMPDIR:-/tmp}/rebuild-history.XXXXXX")
trap 'rm -rf "$SCRATCH"' EXIT
WORK="$SCRATCH/ClassMaterials"
mkdir "$WORK"

git archive main | tar -x -C "$WORK"
git show class-start:src/cobol/SANDBOX.cbl > "$WORK/src/cobol/SANDBOX.cbl"

(
    cd "$WORK"
    GIT_COMMITTER_NAME="Strongback Consulting" \
    GIT_COMMITTER_EMAIL="training@example.invalid" \
        sh ./git-bootstrap.sh >/dev/null
    git branch release class-start
    git branch develop main
)

old=$(git rev-parse 'main^{tree}')
new=$(git -C "$WORK" rev-parse 'main^{tree}')
[ "$old" = "$new" ] || die "the rebuilt main differs from today's (tree $new, not $old) - nothing was pushed.
  Most likely src/cobol/SANDBOX.cbl changed outside the maintenance commits; fold that by hand."
[ "$(git -C "$WORK" rev-list --count main)" -eq 3 ] || die "the rebuild did not produce three commits - nothing was pushed."
say "Rebuilt: three commits, and the same tree as today's main ($(printf '%.7s' "$new"))."

if [ "$PUSH" = no ]; then
    say "Nothing pushed. Run again with --push to replace origin's history."
    exit 0
fi

git -C "$WORK" push -q --force --atomic "$origin" \
    +refs/heads/main:refs/heads/main \
    +refs/heads/develop:refs/heads/develop \
    +refs/heads/release:refs/heads/release \
    +refs/tags/class-start:refs/tags/class-start

git fetch -q --force --tags origin
git reset -q --hard origin/main
git branch -f develop origin/develop >/dev/null
git branch -f release origin/release >/dev/null
say "origin and this clone now carry the rebuilt history:"
git --no-pager log --oneline --decorate main
say ""
say "Next: maintainer/backup.sh <backup-folder>, then maintainer/publish.sh."
