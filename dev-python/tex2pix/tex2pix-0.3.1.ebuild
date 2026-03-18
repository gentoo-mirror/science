# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Lightweight renderer of LaTeX to a variety of graphics formats"
HOMEPAGE="https://pypi.org/project/tex2pix/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
