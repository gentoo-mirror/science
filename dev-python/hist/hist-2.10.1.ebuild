# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
inherit distutils-r1 pypi

DESCRIPTION="Histogramming for analysis powered by boost-histogram "
HOMEPAGE="
	https://github.com/scikit-hep/hist
	https://hist.readthedocs.io/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/boost-histogram-1.6[${PYTHON_USEDEP}]
	<dev-python/boost-histogram-1.8[${PYTHON_USEDEP}]
	>=dev-python/histoprint-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.21.3[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-mpl-0.12[${PYTHON_USEDEP}]
		>=sci-physics/mplhep-0.3.33[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
