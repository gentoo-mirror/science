# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Validator for the Brain Imaging Data Structure"
HOMEPAGE="https://github.com/bids-standard/bids-validator"
SRC_URI="https://github.com/bids-standard/bids-validator/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${P}/${PN}"
