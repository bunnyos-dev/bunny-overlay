# Overrides

Packages in this overlay that have the same name as one in Gentoo's tree
(`::gentoo`). Bunny Linux's copy wins over Gentoo's, so each one is a small
step away from Gentoo, and each needs a reason written down here.

This list is how Bunny Linux keeps track of how far it has drifted from Gentoo
(see "Relationship to Gentoo" in the
[design doc](https://github.com/bunnyos-dev/bunnyos/blob/main/docs/DESIGN.md)).
If it keeps growing, that is the moment to stop and rethink.

The `overrides` check in CI fails when a package here shadows one in
`::gentoo` without a line below, or when a line names a package that no longer
shadows anything (so the list never goes stale). Run it yourself with:

```sh
tools/check-overrides.sh . /var/db/repos/gentoo
```

## The list

One row per package. **Upstream** is the Gentoo bug or pull request where the
change was offered back, or `bunny-only` if it only makes sense for Bunny Linux.

| Package | Why Bunny Linux carries its own | Upstream |
|---|---|---|

None yet: everything in this overlay is new to Gentoo.
