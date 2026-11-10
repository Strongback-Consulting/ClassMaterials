#!/bin/sh
# Keep a restore copy of the private source repository OUTSIDE GitHub.
# Strongback maintainers only - see README.md here.
#
#   maintainer/backup.sh <backup-folder>
#   CLASSMATERIALS_BACKUP_DIR=<backup-folder> maintainer/backup.sh
#
# Run it from a clone of the PRIVATE source repository. Each run:
#
#   1. refreshes a bare mirror of every branch and tag, in
#      <backup-folder>/class-materials.git
#   2. writes a dated single-file bundle of the same refs, in
#      <backup-folder>/bundles/class-materials-YYYYMMDD-HHMMSS.bundle,
#      and keeps the newest $KEEP of them
#   3. checks both match the private repository before saying so
#
# Point <backup-folder> at storage GitHub cannot reach: a NAS, a backup
# volume, or a folder your cloud drive syncs. Restoring is in README.md.

set -eu

KEEP=${CLASSMATERIALS_BACKUP_KEEP:-12}
DEST=${1:-${CLASSMATERIALS_BACKUP_DIR:-}}

say() { printf '%s\n' "$*"; }
die() { printf 'backup: %s\n' "$*" >&2; exit 1; }

[ -n "$DEST" ] || die "say where to keep the backup: maintainer/backup.sh <backup-folder>"

TOP=$(git rev-parse --show-toplevel 2>/dev/null) || die "not inside a git repository."
cd "$TOP"
[ -f ClassMaterials.code-workspace ] || die "this is not a ClassMaterials repository."

SRC=$(git remote get-url origin 2>/dev/null) || die "no 'origin' remote."
case "$SRC" in
    *Strongback-Consulting/ClassMaterials*)
        die "origin is the PUBLIC repository. Back up the private source repository instead." ;;
esac

mkdir -p "$DEST/bundles" || die "cannot create $DEST"
DEST=$(cd "$DEST" && pwd -P)
MIRROR="$DEST/class-materials.git"

# --- 1. the bare mirror ----------------------------------------------------

if [ -d "$MIRROR" ]; then
    say "Refreshing $MIRROR"
    git -C "$MIRROR" remote set-url origin "$SRC"
    git -C "$MIRROR" remote update --prune >/dev/null || die "could not fetch from origin."
else
    say "Creating $MIRROR"
    git clone -q --mirror "$SRC" "$MIRROR" || die "could not clone origin."
fi

# --- 2. a dated bundle of the same refs ------------------------------------

STAMP=$(date +%Y%m%d-%H%M%S)
BUNDLE="$DEST/bundles/class-materials-$STAMP.bundle"
git -C "$MIRROR" bundle create -q "$BUNDLE" --all || die "could not write $BUNDLE"

# --- 3. verify before reporting success ------------------------------------

want=$(git ls-remote "$SRC" 'refs/heads/*' 'refs/tags/*' | grep -v '\^{}$' | sort)
have=$(git -C "$MIRROR" for-each-ref --format='%(objectname)	%(refname)' refs/heads refs/tags | sort)
[ "$want" = "$have" ] || die "the mirror does not match origin - nothing was pruned; investigate before relying on it."
git -C "$MIRROR" fsck --no-dangling >/dev/null 2>&1 || die "the mirror failed git fsck."
git -C "$MIRROR" bundle verify -q "$BUNDLE" >/dev/null 2>&1 || die "$BUNDLE failed git bundle verify."

# keep the newest $KEEP bundles; only ever touch files this script wrote
ls -1 "$DEST/bundles"/class-materials-*.bundle 2>/dev/null | sort -r | tail -n +$((KEEP + 1)) \
| while read -r old; do rm -f "$old"; done

refs=$(printf '%s\n' "$have" | grep -c .)
say "Backed up $refs refs."
say "  mirror: $MIRROR"
say "  bundle: $BUNDLE"
say "Bundles kept: $(ls -1 "$DEST/bundles"/class-materials-*.bundle | wc -l | tr -d ' ') (newest $KEEP)"
