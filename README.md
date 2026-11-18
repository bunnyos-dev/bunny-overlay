# bunny-overlay

The Gentoo overlay for [Bunny Linux](https://github.com/bunnyos-dev/bunnyos):
`bunny` today, and the Bunny Linux desktop packages later.

| Package | What it is |
|---|---|
| `app-admin/bunny-bin` | The latest bunny release, prebuilt. Installs in seconds. |
| `app-admin/bunny` | bunny built from the latest code on GitHub (`-9999`). For testing what's coming. |

## Add the overlay

With `eselect repository` (it needs git for syncing):

```sh
sudo emerge --ask app-eselect/eselect-repository dev-vcs/git
sudo eselect repository add bunny git https://github.com/bunnyos-dev/bunny-overlay.git
sudo emaint sync -r bunny
```

## Install bunny

```sh
sudo emerge --ask app-admin/bunny-bin
bunny --version
```

Then follow the guide: https://bunnyos-dev.github.io/bunnyos/

## Licence

The ebuilds and other files here are GPL-2, like Gentoo's own tree. bunny
itself is GPL-3.
