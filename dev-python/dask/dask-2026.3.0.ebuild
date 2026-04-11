# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

inherit distutils-r1

DESCRIPTION="Flexible parallel computing library for analytics"
HOMEPAGE="https://github.com/dask/dask"
SRC_URI="https://github.com/dask/dask/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/fsspec[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/partd[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-no-codecov.patch"
)

EPYTEST_DESELECT=(
	# does raise expected warning but is not recognized by test
	dask/array/tests/test_reductions.py::test_nanquantile_all_nan
	dask/array/tests/test_array_core.py::test_zarr_risky_shards_warns
	# testing deprecated functionality, should be skipped
	dask/dataframe/tests/test_dataframe.py::test_combine_first_all_nans
	# Internet
	dask/bytes/tests/test_http.py::test_read_csv
	dask/bytes/tests/test_http.py::test_bag
	dask/bytes/tests/test_http.py::test_parquet
)
distutils_enable_tests pytest
