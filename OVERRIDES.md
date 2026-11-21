# Overrides

Packages in this overlay that have the same name as one in Gentoo's tree
(`::gentoo`), and files from Gentoo's packages that a package here replaces.
Bunny Linux's copy wins over Gentoo's, so each one is a small step away from
Gentoo, and each needs a reason written down here.

This list is how Bunny Linux keeps track of how far it has drifted from Gentoo
(see "Relationship to Gentoo" in the
[design doc](https://github.com/bunnyos-dev/bunnyos/blob/main/docs/DESIGN.md)).
If it keeps growing, that is the moment to stop and rethink.

The `overrides` check in CI fails when a package here shadows one in
`::gentoo` without a line below, or when a line names a package that no longer
shadows anything (so the list never goes stale). It also checks that each
replaced file names a package that's in this overlay. Run it yourself with:

```sh
tools/check-overrides.sh . /var/db/repos/gentoo
```

## The list

One row per package. **Upstream** is the Gentoo bug or pull request where the
change was offered back, or `bunny-only` if it only makes sense for Bunny Linux.

| Package | Why Bunny Linux carries its own | Upstream |
|---|---|---|

None yet: every package in this overlay has a name of its own.

## Files replaced

A package here can also take over a single file from one of Gentoo's
packages without replacing the whole package. One row per file.

| File | Replaced by | Gentoo's owner | Why, and how | Upstream |
|---|---|---|---|---|
| `/etc/os-release` | `sys-apps/bunny-release` | `sys-apps/baselayout` | So programs (fastfetch, desktop "About" pages, bug-report tools) say Bunny Linux instead of Gentoo. baselayout writes `/usr/lib/os-release` from `branding.eclass` (NAME=Gentoo) and installs the link `/etc/os-release -> ../usr/lib/os-release`; programs read `/etc/os-release` first. bunny-release installs its own `/usr/lib/bunny-release/os-release` (ID=bunny, ID_LIKE=gentoo) and points the link there after installing, only if it's still Gentoo's link, and points it back when removed. Gentoo's file stays untouched. `/etc` is config-protected, links included (Portage bug 485598), so a baselayout update offers Gentoo's link as a waiting config update instead of putting it back: don't accept that one. Later, with Bunny Linux's own profile, the cleaner way is to set the `BRANDING_OS_*` variables there and let baselayout write the file itself (it needs baselayout built from source, since Gentoo's prebuilt one says Gentoo). | `bunny-only` |
