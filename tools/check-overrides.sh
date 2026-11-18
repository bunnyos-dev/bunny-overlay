#!/bin/sh
# Check that OVERRIDES.md matches the packages this overlay shadows in Gentoo.
#
#   tools/check-overrides.sh <overlay> <gentoo tree>
#
# Fails if a package in the overlay also exists in the Gentoo tree but has no
# row in OVERRIDES.md, or if a row names a package that no longer shadows one.
# Rows look like: | `category/name` | why | upstream |
set -eu

if [ $# -ne 2 ]; then
	echo "usage: $0 <overlay> <gentoo tree>" >&2
	exit 2
fi
overlay=$1
gentoo=$2

if [ ! -d "$gentoo/profiles" ]; then
	echo "✗ $gentoo doesn't look like a Gentoo tree (no profiles/ folder)." >&2
	exit 2
fi
if [ ! -f "$overlay/OVERRIDES.md" ]; then
	echo "✗ $overlay/OVERRIDES.md is missing." >&2
	exit 1
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Packages in the overlay: category/name folders that hold an ebuild.
(cd "$overlay" && find . -mindepth 3 -maxdepth 3 -name '*.ebuild' \
	| sed 's|^\./||; s|/[^/]*$||' | sort -u) >"$tmp/overlay"

# Of those, the ones Gentoo also has.
: >"$tmp/shadowed"
while read -r pkg; do
	if [ -d "$gentoo/$pkg" ]; then
		echo "$pkg" >>"$tmp/shadowed"
	fi
done <"$tmp/overlay"
sort -u -o "$tmp/shadowed" "$tmp/shadowed"

# Packages listed in OVERRIDES.md (first column, in backticks).
sed -n 's/^| *`\([^`/]*\/[^`]*\)` *|.*/\1/p' "$overlay/OVERRIDES.md" \
	| sort -u >"$tmp/listed"

missing=$(comm -23 "$tmp/shadowed" "$tmp/listed")
stale=$(comm -13 "$tmp/shadowed" "$tmp/listed")
status=0

if [ -n "$missing" ]; then
	echo "✗ These packages replace Gentoo's own, but OVERRIDES.md doesn't say why:"
	echo "$missing" | sed 's/^/    /'
	echo "  Add a row for each one, or rename the package if it shouldn't replace Gentoo's."
	status=1
fi
if [ -n "$stale" ]; then
	echo "✗ OVERRIDES.md lists packages that no longer replace one of Gentoo's:"
	echo "$stale" | sed 's/^/    /'
	echo "  Remove their rows (Gentoo dropped them, or the overlay did)."
	status=1
fi
if [ $status -eq 0 ]; then
	count=$(wc -l <"$tmp/shadowed" | tr -d ' ')
	echo "✓ OVERRIDES.md is up to date ($count package(s) replace Gentoo's)."
fi
exit $status
