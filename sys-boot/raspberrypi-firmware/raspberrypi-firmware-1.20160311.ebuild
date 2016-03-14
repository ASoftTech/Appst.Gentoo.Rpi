# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 readme.gentoo

DESCRIPTION="Raspberry PI boot loader and firmware"
HOMEPAGE="https://github.com/raspberrypi/firmware"
SRC_URI=""

LICENSE="GPL-2 raspberrypi-videocore-bin"
SLOT="0"
KEYWORDS="~arm -*"
IUSE=""

DEPEND=""
RDEPEND=""

EGIT_REPO_URI="https://github.com/raspberrypi/firmware"
EGIT_COMMIT="8b4e5482b52e6fb438dddc0d88ba0ba8d44af54b"

RESTRICT="binchecks strip"

pkg_preinst() {
    if ! grep "${ROOT}boot" /proc/mounts >/dev/null 2>&1; then
        ewarn "${ROOT}boot is not mounted, the files might not be installed at the right place"
    fi
}

src_install() {
	insinto /boot
	cd boot
	doins bootcode.bin COPYING.linux fixup*.dat LICENCE.broadcom start*elf
	newenvd "${FILESDIR}"/${PN}-envd 90${PN}
	readme.gentoo_create_doc
}

DOC_CONTENTS="Please configure your ram setup by editing /boot/config.txt"
