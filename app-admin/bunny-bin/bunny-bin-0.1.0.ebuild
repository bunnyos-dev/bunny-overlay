# Copyright 2026 BunnyOS contributors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="One file describes your Gentoo system; bunny makes it so (prebuilt)"
HOMEPAGE="https://github.com/bunnyos-dev/bunnyos"
SRC_URI="https://github.com/bunnyos-dev/bunnyos/releases/download/v${PV}/bunny-x86_64-linux -> ${P}-x86_64-linux"
S="${WORKDIR}"

LICENSE="GPL-3"
# Licences of the Rust crates built into the binary.
LICENSE+=" Apache-2.0 MIT Unicode-3.0 Unlicense"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="strip"

# bunny runs emerge and Portage's own Python library, takes btrfs snapshots,
# and reads security advisories with glsa-check.
RDEPEND="
	!app-admin/bunny
	sys-apps/portage
	sys-fs/btrfs-progs
"

QA_PREBUILT="usr/bin/bunny"

src_unpack() {
	cp "${DISTDIR}/${P}-x86_64-linux" "${S}/bunny" || die
}

src_install() {
	dobin bunny
}

pkg_postinst() {
	elog "Start with:  bunny import > bunny.toml"
	elog "The guide:   https://bunnyos-dev.github.io/bunnyos/"
}
