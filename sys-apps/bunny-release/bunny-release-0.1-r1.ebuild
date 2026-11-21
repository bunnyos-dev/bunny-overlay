# Copyright 2026 Bunny Linux contributors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bunny Linux's name for the system (os-release) and its fastfetch logo"
HOMEPAGE="https://github.com/bunnyos-dev/bunnyos"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

# Gentoo's sys-apps/baselayout installs /usr/lib/os-release (from
# branding.eclass, so it says Gentoo) and the link /etc/os-release ->
# ../usr/lib/os-release. Programs read /etc/os-release first (os-release(5)).
# This package installs Bunny Linux's file beside Gentoo's and points the
# link at it, so nothing collides with baselayout. /etc is config-protected,
# links included, so a baselayout update doesn't put Gentoo's link back; it
# offers it as a waiting config update instead (see OVERRIDES.md).
RDEPEND="sys-apps/baselayout"

OUR_LINK="../usr/lib/bunny-release/os-release"
GENTOO_LINK="../usr/lib/os-release"

src_install() {
	insinto /usr/lib/bunny-release
	newins - os-release <<-EOF
	NAME="Bunny Linux"
	ID=bunny
	ID_LIKE=gentoo
	PRETTY_NAME="Bunny Linux"
	VERSION="${PV}"
	VERSION_ID=${PV}
	HOME_URL="https://github.com/bunnyos-dev/bunnyos"
	DOCUMENTATION_URL="https://bunnyos-dev.github.io/bunnyos/"
	BUG_REPORT_URL="https://github.com/bunnyos-dev/bunnyos/issues"
	EOF

	# PLACEHOLDER logo, until the real one is designed.
	insinto /usr/share/bunny-release
	doins "${FILESDIR}"/logo.txt

	# fastfetch reads /etc/xdg/fastfetch/config.jsonc when the user has
	# none of their own.
	insinto /etc/xdg/fastfetch
	newins "${FILESDIR}"/fastfetch-config.jsonc config.jsonc
}

pkg_postinst() {
	local link="${EROOT}/etc/os-release"
	local now
	now=$(readlink "${link}" 2>/dev/null) || now=""
	if [[ ${now} == "${OUR_LINK}" ]]; then
		return
	fi
	# Only replace Gentoo's own link (or nothing): a file someone made by
	# hand is theirs.
	if [[ ${now} == "${GENTOO_LINK}" || ! -e ${link} && ! -L ${link} ]]; then
		ln -sfn "${OUR_LINK}" "${link}" || die "Couldn't point /etc/os-release at Bunny Linux's"
		elog "/etc/os-release now says Bunny Linux (Gentoo's is still in /usr/lib/os-release)."
	else
		ewarn "/etc/os-release was changed by hand, so it was left alone."
		ewarn "To use Bunny Linux's: ln -sfn ${OUR_LINK} /etc/os-release"
	fi
}

pkg_postrm() {
	# Removed, not updated: give Gentoo's link back.
	[[ -n ${REPLACED_BY_VERSION} ]] && return
	local link="${EROOT}/etc/os-release"
	if [[ $(readlink "${link}" 2>/dev/null) == "${OUR_LINK}" ]]; then
		ln -sfn "${GENTOO_LINK}" "${link}" || die
		elog "/etc/os-release points at Gentoo's again."
	fi
}
