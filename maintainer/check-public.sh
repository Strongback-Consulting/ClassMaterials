#!/bin/sh
# Compare the public ClassMaterials repository with the private source
# repository it is published from. Strongback maintainers only.
#
#   maintainer/check-public.sh
#
# Exit status: 0 in sync, 1 drift found, 2 could not check. It never changes
# anything - run publish.sh to put the public copy right.

set -u

PUBLIC=${CLASSMATERIALS_PUBLIC:-git@github.com:Strongback-Consulting/ClassMaterials.git}
PRIVATE=${CLASSMATERIALS_PRIVATE:-origin}
REFS="refs/heads/main refs/heads/develop refs/heads/release refs/tags/class-start"

say() { printf '%s\n' "$*"; }

priv=$(git ls-remote "$PRIVATE" 2>/dev/null) || { say "check-public: cannot read $PRIVATE"; exit 2; }
pub=$(git ls-remote "$PUBLIC" 2>/dev/null)    || { say "check-public: cannot read $PUBLIC"; exit 2; }

sha() { printf '%s\n' "$1" | awk -v r="$2" '$2 == r { print $1 }'; }

drift=0
for r in $REFS; do
    a=$(sha "$priv" "$r"); b=$(sha "$pub" "$r")
    if [ -z "$a" ]; then
        say "  ?  $r is missing from the private repository"; drift=1
    elif [ "$a" != "$b" ]; then
        say "  ≠  $r  private ${a%"${a#???????}"}  public ${b:-<missing>}"; drift=1
    else
        say "  =  $r"
    fi
done

printf '%s\n' "$pub" | awk '{ print $2 }' | grep -E '^refs/(heads|tags)/' | grep -v '\^{}$' \
| while read -r ref; do
    case " $REFS " in *" $ref "*) ;; *) say "  +  $ref is on the public copy but not on the allowlist" ;; esac
done | { out=$(cat); [ -n "$out" ] && { printf '%s\n' "$out"; exit 1; }; exit 0; } || drift=1

if [ "$drift" -eq 0 ]; then
    say "In sync."
    exit 0
fi
say "Drift found. maintainer/publish.sh puts the public copy back."
exit 1
