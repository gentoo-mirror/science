# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Parsing, manipulating, and visualising SUSY Les Houches Accord data"
HOMEPAGE="
	https://box.insectnation.org/projects/pyslha
	https://gitlab.com/hepcedar/pyslha
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/tex2pix-0.1.5[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"
