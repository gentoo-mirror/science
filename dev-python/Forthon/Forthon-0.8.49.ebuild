# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit eutils distutils-r1

DESCRIPTION="Python interface generator for Fortran based codes"
HOMEPAGE="http://hifweb.lbl.gov/Forthon"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

python_install_all() {
	dodoc -r {example,simpleexample}
	dohtml docs/index.html

	distutils-r1_python_install_all
}
