
EAPI=5
inherit git-2
SRC_URI=""
EGIT_REPO_URI="https://github.com/RPi-Distro/firmware-nonfree.git"
EGIT_COMMIT="54bab3d6a6d43239c71d26464e6e10e5067ffea7"
KEYWORDS="arm arm64"
SLOT="0"
DESCRIPTION="Rpi3 Wireless Firmware"
HOMEPAGE="https://github.com/RPi-Distro/firmware-nonfree.git"

DEPEND="sys-kernel/linux-firmware"

src_unpack() {
    git-2_src_unpack
}

src_install() {
	insinto /lib/firmware/brcm/
	doins brcm80211/brcm/brcmfmac43430-sdio.txt
	doins brcm80211/brcm/brcmfmac43430-sdio.bin
}

