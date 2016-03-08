
EAPI=5
XORG_DRI=always
inherit autotools-utils xorg-2 git-2
SRC_URI=""
EGIT_REPO_URI="https://github.com/ssvb/xf86-video-fbturbo.git"
EGIT_COMMIT="f9a6ed78419f0b98cf2c3ce3cdd4c97fe9a46195"
KEYWORDS="~arm"
SLOT="0"
DESCRIPTION="FBTurbo ARM video driver (based on sunxifb)"

RDEPEND=">=x11-base/xorg-server-1.3
   gles2? (
       ( >=x11-libs/libdrm-2.4.36 )
       ( x11-libs/libump )
       )"

DEPEND="${RDEPEND}"
IUSE="gles2"

AUTOTOOLS_IN_SOURCE_BUILD="yes"
AUTOTOOLS_AUTORECONF="yes"

