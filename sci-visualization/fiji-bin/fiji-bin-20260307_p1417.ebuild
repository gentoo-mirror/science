# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper xdg

DESCRIPTION="ImageJ distribution with a lot of plugins for scientific image processing"
HOMEPAGE="http://fiji.sc/"
SRC_URI="
	amd64? (
		https://downloads.imagej.net/fiji/archive/stable/${PV/_p/-}/${PN/-bin}-stable-linux64-jdk.zip
	)
"
S="${WORKDIR}"

LICENSE="BSD GPL-3+ public-domain"
SLOT="0"
KEYWORDS="~amd64"

# Latest supported ffmpeg soname version is .61
RDEPEND="
	media-libs/freetype:2
	media-video/ffmpeg-compat:7
"
BDEPEND="app-arch/unzip"

QA_PREBUILT="*"

src_prepare() {
	default
	cd Fiji.app || die

	# Disable auto-updates
	rm -v jars/imagej-updater-*.jar || die
	rm -v scripts/Plugins/AutoRun/Check_Required_Update_Sites.js || die

	# Clean cruft
	rm -v .checksums || die

	# Drop plugins for older ffmpeg versions
	find . -type f -name "libavplugin-*[0-9]*" ! -name "*61*" -delete || die
}

src_install() {
	dodir /opt
	mv "${S}"/Fiji.app/ "${ED}/opt/${PN}" || die
	cd "${ED}/opt/${PN}" || die

	make_wrapper ${PN} /opt/${PN}/fiji-linux-x64
	newicon images/icon.png ${PN}.png
	make_desktop_entry ${PN} "Fiji (bin)" ${PN}
}
