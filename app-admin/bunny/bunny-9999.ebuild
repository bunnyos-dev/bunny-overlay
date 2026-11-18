# Copyright 2026 Bunny Linux contributors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo git-r3

DESCRIPTION="One file describes your Gentoo system; bunny makes it so"
HOMEPAGE="https://github.com/bunnyos-dev/bunnyos"
EGIT_REPO_URI="https://github.com/bunnyos-dev/bunnyos.git"

LICENSE="GPL-3"
# Licences of the Rust crates bunny is built from.
LICENSE+=" Apache-2.0 MIT Unicode-3.0 Unlicense"
SLOT="0"

RDEPEND="
	!app-admin/bunny-bin
	sys-apps/portage
	sys-fs/btrfs-progs
"

src_unpack() {
	git-r3_src_unpack
	# cargo fetches the crates from the checkout's Cargo.toml.
	cd "${S}" || die
	cargo_live_src_unpack
}

src_install() {
	dobin "$(cargo_target_dir)/bunny"
	einstalldocs
}

pkg_postinst() {
	elog "Start with:  bunny import > bunny.toml"
	elog "The guide:   https://bunnyos-dev.github.io/bunnyos/"
}
