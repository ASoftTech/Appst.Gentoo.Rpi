# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/userland"

inherit git-2
EGIT_REPO_URI="git://github.com/${PN/-//}.git"
EGIT_COMMIT="8369e390999f4a7c3bc57e577247e0dd502c51f7"
SRC_URI=""
KEYWORDS=""

LICENSE="BSD"
SLOT="0"

# TODO:
# * port vcfiled init script
# * stuff is still installed to hardcoded /opt/vc location, investigate whether
#   anything else depends on it being there
# * live ebuild

src_prepare() {
	# init script for Debian, not useful on Gentoo
	sed -i "/DESTINATION \/etc\/init.d/,+2d" interface/vmcs_host/linux/vcfiled/CMakeLists.txt || die
}

src_configure() {
	# toolchain file not needed, but build fails if it is not specified
	local mycmakeargs="-DCMAKE_TOOLCHAIN_FILE=/dev/null"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doenvd "${FILESDIR}"/04${PN}

	# enable dynamic switching of the GL implementation
	dodir /usr/lib/opengl
	dosym ../../../opt/vc /usr/lib/opengl/${PN}

	# tell eselect opengl that we do not have libGL
	touch "${ED}"/opt/vc/.gles-only
}
