#!/bin/sh
# Class repository helper for the IDz on VS Code Git track.
#
# The normal path for a student is NOT this script: it is cloning the class
# repository your instructor gives you (see CLASS-REPO-SETUP.md). Use this
# only in the two cases below.
#
#   ./git-bootstrap.sh
#       No repository here yet, and no class repository to clone (no network,
#       no fork). Creates a local repository from this folder with the same
#       starting history a clone would have given you.
#
#   ./git-bootstrap.sh --seed-existing
#       Instructor use, inside a fresh clone of the class repository. Adds the
#       teaching history the labs read - an as-delivered tag and two
#       maintenance commits - if it is not already there. Push afterwards so
#       every student's clone carries it.
#
# Safe to re-run: it never touches a repository that already has the history.
#
# Windows: use git-bootstrap.ps1 instead.

set -eu

say() { printf '%s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

SEED_EXISTING=no
[ "${1:-}" = "--seed-existing" ] && SEED_EXISTING=yes

# --- Guards ---------------------------------------------------------------

command -v git >/dev/null 2>&1 || die "git is not on your PATH. Install Git, reopen the terminal, and try again."

[ -f ClassMaterials.code-workspace ] || die "run this from inside the ClassMaterials folder (the one holding ClassMaterials.code-workspace)."

HERE=$(pwd -P)
TOP=$(git rev-parse --show-toplevel 2>/dev/null || true)

if [ -n "$TOP" ] && [ "$(cd "$TOP" && pwd -P)" != "$HERE" ]; then
    die "this folder sits inside the git repository at:
       $TOP
     Copy ClassMaterials somewhere outside it, then work there."
fi

HAVE_REPO=no
[ -n "$TOP" ] && HAVE_REPO=yes

if [ "$HAVE_REPO" = no ] && [ "$SEED_EXISTING" = yes ]; then
    die "--seed-existing expects an existing clone of the class repository here."
fi

if [ "$HAVE_REPO" = yes ] && [ "$SEED_EXISTING" = no ]; then
    say "This folder is already a git repository - nothing to do."
    say ""
    say "If you cloned the class repository, you are ready: open"
    say "ClassMaterials.code-workspace in VS Code and start the git-repositories lab."
    say ""
    say "Instructors preparing a fork can add the teaching history with:"
    say "    ./git-bootstrap.sh --seed-existing"
    exit 0
fi

# --- Create the repository, when there is nothing to clone ----------------

if [ "$HAVE_REPO" = no ]; then
    say "No class repository to clone, so creating one here instead."
    say "Creating a git repository in $HERE ..."
    git init -q -b main 2>/dev/null || { git init -q; git symbolic-ref HEAD refs/heads/main; }
fi

# Identity: only set one if the student has none, so we never overwrite a
# developer's real name. git-repositories teaches them to set their own.
if [ -z "$(git config user.email || true)" ]; then
    git config user.name  "Class Student"
    git config user.email "student@example.invalid"
    IDENTITY_PLACEHOLDER=yes
else
    IDENTITY_PLACEHOLDER=no
fi

# --- The as-delivered commit ----------------------------------------------

if [ "$HAVE_REPO" = no ]; then
    # Many delivered samples arrived with Windows line endings; .gitattributes
    # normalises them to LF on the way in. That conversion is intended and
    # one-time, so silence git's per-file warning for this bulk import only -
    # the student's own edits still get the default warnings.
    git -c core.safecrlf=false add -A
    git commit -q -m "Class materials, as delivered

The COBOL, JCL, REXX and copybook samples the labs work on, plus the
workspace, ZAPP and connection templates. This is the pristine starting
point; the class-start tag marks it." \
        --author="Strongback Consulting <training@example.invalid>"
    say "  commit 1/3  class materials imported"
fi

if git rev-parse -q --verify refs/tags/class-start >/dev/null 2>&1; then
    say "  tag class-start already present"
else
    git tag class-start
    say "  tagged class-start"
fi

# --- Seeded history so blame, log and revert have something to show --------
# Two later maintenance edits by two different people, in the style of a real
# shop's change log. git-history-recovery reads these.

if git log --oneline 2>/dev/null | grep -q "tighten ward code validation"; then
    say ""
    say "The teaching history is already here - nothing further to do."
    exit 0
fi

# Insert a block of lines after the first line containing a literal anchor.
# The block arrives in a file rather than an awk -v variable: awk on macOS
# rejects embedded newlines in -v values.
insert_after() {   # file  literal-anchor  block-file
    _file=$1; _anchor=$2; _block=$3
    _tmp="$_file.bootstrap.$$"
    awk -v anchor="$_anchor" -v block="$_block" '
        { print }
        (!done && index($0, anchor)) {
            while ((getline line < block) > 0) print line
            close(block)
            done = 1
        }
    ' "$_file" > "$_tmp" && mv "$_tmp" "$_file"
}

SANDBOX=src/cobol/SANDBOX.cbl
[ -f "$SANDBOX" ] || die "$SANDBOX is missing — is this a complete ClassMaterials folder?"

BLOCK="./.bootstrap-block.$$"
trap 'rm -f "$BLOCK"' EXIT

cat > "$BLOCK" <<'EOF'
      *
      *  MAINTENANCE LOG
      *  2026-02-11  A.RIVERA   Ward code validation tightened (RFC 4471)
EOF
insert_after "$SANDBOX" '*REMARKS.' "$BLOCK"
git -c core.safecrlf=false add "$SANDBOX"
git commit -q -m "SANDBOX: tighten ward code validation

Ward codes coming off the daily patient file were accepted without a
range check, so a mistyped ward silently reported under ward 0.
Raised by the night shift as RFC 4471." \
    --author="A. Rivera <a.rivera@example.invalid>"
say "  commit 2/3  ward code validation note (A. Rivera)"

cat > "$BLOCK" <<'EOF'
      *  2026-05-03  M.OKAFOR   Bed-count rounding corrected (INC 55219)
EOF
insert_after "$SANDBOX" 'MAINTENANCE LOG' "$BLOCK"
git -c core.safecrlf=false add "$SANDBOX"
git commit -q -m "SANDBOX: correct bed-count rounding

Occupancy percentages rounded down at every control break, so a full
ward could report 99%. Reported as INC 55219." \
    --author="M. Okafor <m.okafor@example.invalid>"
say "  commit 3/3  bed-count rounding note (M. Okafor)"

# --- Report ---------------------------------------------------------------

say ""
say "Done. The class repository history now reads:"
say ""
git --no-pager log --oneline --decorate -5
say ""
if [ "$SEED_EXISTING" = yes ]; then
    say "Instructor: push this so every student's clone carries it, e.g."
    say "    git push origin main --tags"
    say ""
fi
if [ "$IDENTITY_PLACEHOLDER" = yes ]; then
    say "Your commits will be signed 'Class Student' until you set your own name."
    say "The git-repositories lab shows you how:"
    say "    git config user.name  \"Your Name\""
    say "    git config user.email \"you@your-company.com\""
    say ""
fi
say "Next: open ClassMaterials.code-workspace in VS Code and look at the"
say "Source Control view - it now shows this repository."
