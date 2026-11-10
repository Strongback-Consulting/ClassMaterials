#!/bin/sh
# Publish the allowlisted refs of the private source repository to the public
# ClassMaterials repository. Strongback maintainers only - see README.md here.
#
#   maintainer/publish.sh            publish (and restore - it is the same thing)
#   maintainer/publish.sh --dry-run  show what would be pushed and deleted
#
# Run it from a clone of the PRIVATE source repository whose local main,
# develop and release match origin. It force-pushes exactly the allowlist,
# deletes every other branch and tag on the public copy, and refuses to run if
# anything in the published history should not be public.

set -eu

PUBLIC=${CLASSMATERIALS_PUBLIC:-git@github.com:Strongback-Consulting/ClassMaterials.git}
BRANCHES="main develop release"
TAGS="class-start"

say() { printf '%s\n' "$*"; }
die() { printf 'publish: %s\n' "$*" >&2; exit 1; }

DRY=
[ "${1:-}" = "--dry-run" ] && DRY=--dry-run

TOP=$(git rev-parse --show-toplevel 2>/dev/null) || die "not inside a git repository."
cd "$TOP"
[ -f ClassMaterials.code-workspace ] || die "this is not a ClassMaterials repository."

origin=$(git remote get-url origin 2>/dev/null) || die "no 'origin' remote."
case "$origin" in
    *Strongback-Consulting/ClassMaterials*)
        die "origin is the PUBLIC repository. Run this from a clone of the private source repository." ;;
esac

# --- Every published ref must exist locally and match the private repository

git fetch -q --tags origin || die "could not fetch from origin."

REFS=
for b in $BRANCHES; do
    git rev-parse -q --verify "refs/heads/$b" >/dev/null || die "local branch '$b' is missing."
    l=$(git rev-parse "refs/heads/$b")
    r=$(git rev-parse -q --verify "refs/remotes/origin/$b" || true)
    [ "$l" = "$r" ] || die "local '$b' does not match origin/$b - push or pull first, so only reviewed work is published."
    REFS="$REFS refs/heads/$b"
done
for t in $TAGS; do
    l=$(git rev-parse -q --verify "refs/tags/$t^{commit}") || die "tag '$t' is missing."
    r=$(git ls-remote origin "refs/tags/$t" | cut -f1)
    [ -n "$r" ] || die "tag '$t' has not been pushed to origin."
    [ "$(git rev-parse "$r^{commit}")" = "$l" ] || die "local tag '$t' differs from origin's."
    REFS="$REFS refs/tags/$t"
done

# --- The gate: nothing in the published history may be private -------------
# Checks every commit reachable from a published ref, not just the tip: a
# secret removed in a later commit is still public in the one that added it.

say "Checking the history of:$REFS"
fail=0

# shellcheck disable=SC2086
bad_paths=$(git log --format= --name-only $REFS \
    | grep -E '(^|/)\.DS_Store$|^\.github/workflows/' | sort -u || true)
if [ -n "$bad_paths" ]; then
    say "  REFUSED: these paths appear in the published history:"
    printf '%s\n' "$bad_paths" | sed 's/^/    /'
    fail=1
fi

# shellcheck disable=SC2086
if git log -p --format=%B $REFS | grep -qE \
    'ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|glpat-[A-Za-z0-9_-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|strongback\.us|ssh -p [0-9]+ '; then
    say "  REFUSED: the history contains a token, a private key or an internal host name."
    say "  Find it with: git log -p$REFS | grep -nE 'ghp_|github_pat_|glpat-|PRIVATE KEY|strongback\\.us|ssh -p'"
    fail=1
fi

# shellcheck disable=SC2086
bad_mail=$(git log --format='%ae%n%ce' $REFS | sort -u \
    | grep -vE '@example\.invalid$|@users\.noreply\.github\.com$' || true)
if [ -n "$bad_mail" ]; then
    say "  REFUSED: commits carry personal email addresses:"
    printf '%s\n' "$bad_mail" | sed 's/^/    /'
    say "  Commit with a role identity - see maintainer/README.md."
    fail=1
fi

[ "$fail" -eq 0 ] || die "nothing was published."
say "  clean."

# --- Push the allowlist, then remove anything else from the public copy ----

SPECS=
for r in $REFS; do SPECS="$SPECS +$r:$r"; done

say ""
say "Publishing to $PUBLIC ${DRY:+(dry run)}"
# shellcheck disable=SC2086
git push $DRY --atomic "$PUBLIC" $SPECS

extra=$(git ls-remote --heads --tags "$PUBLIC" | cut -f2 | grep -v '\^{}$' | while read -r ref; do
    keep=no
    for r in $REFS; do [ "$ref" = "$r" ] && keep=yes; done
    [ "$keep" = no ] && printf '%s\n' "$ref"
done || true)

if [ -n "$extra" ]; then
    say ""
    say "Removing refs that are not on the allowlist:"
    printf '%s\n' "$extra" | sed 's/^/  /'
    # shellcheck disable=SC2086
    git push $DRY "$PUBLIC" --delete $extra
fi

say ""
if [ -n "$DRY" ]; then
    say "Dry run only - nothing was changed."
else
    say "Done. Confirm with: maintainer/check-public.sh"
fi
