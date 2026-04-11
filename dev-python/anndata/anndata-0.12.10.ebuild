# Copyright 1999-2026 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

inherit distutils-r1

DESCRIPTION="Handling annotated data matrices in memory and on disk"
HOMEPAGE="http://anndata.readthedocs.io/"
SRC_URI="https://github.com/scverse/anndata/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/array-api-compat[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/natsort[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	<dev-python/pandas-3[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/awkward[${PYTHON_USEDEP}]
		dev-python/boltons[${PYTHON_USEDEP}]
		dev-python/dask[${PYTHON_USEDEP}]
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/joblib[${PYTHON_USEDEP}]
		dev-python/numba[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP}]
		dev-python/scikit-learn[${PYTHON_USEDEP}]
		dev-python/zarr[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}/${PN}-0.11.4-testargs.patch" )

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# requires dask[distributed], not included in dask ebuild
	tests/test_dask.py::test_dask_distributed_write
	tests/test_io_elementwise.py::test_read_lazy_h5_cluster
	# requires openpyxl
	tests/test_readwrite.py::test_read_excel
)
