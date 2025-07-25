# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cuda toolchain-funcs prefix

DESCRIPTION="Analysis of functional, structural, and diffusion MRI brain imaging data"
HOMEPAGE="https://www.fmrib.ox.ac.uk/fsl"
SRC_URI="https://fsl.fmrib.ox.ac.uk/fsldownloads/${P}-sources.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="FSL BSD-2 newmat"
SLOT="0"
KEYWORDS=""
IUSE="cuda"

DEPEND="
	dev-cpp/libxmlpp:=
	dev-cpp/tbb
	dev-db/sqlite
	dev-libs/boost
	dev-libs/libfmt
	dev-libs/libxml2
	dev-libs/pugixml
	>=dev-python/fslpy-3.7.0
	media-gfx/graphviz
	media-libs/gd
	media-libs/glu
	media-libs/libpng:0=
	sci-libs/gsl
	sci-libs/ciftilib
	sci-libs/fftw
	sci-libs/nlopt
	sci-libs/vtk
	sys-libs/zlib
	dev-lang/tcl:0=
	dev-lang/tk:0=
	>=virtual/lapack-3.8
	>=virtual/blas-3.8
	cuda? (
		=dev-util/nvidia-cuda-toolkit-11* sys-devel/gcc
	)
	"
# initial constraints were:
# =dev-util/nvidia-cuda-toolkit-11* =sys-devel/gcc-9*:*
# could not test cuda on later versions yet
RDEPEND="${DEPEND}"

UPSTREAM_FSLDIR="/usr/share/fsl"

PATCHES=(
#	"${FILESDIR}/${PN}"-6.0.4-gcc10_include.patch
	"${FILESDIR}/${PN}"-6.0.4-setup.patch
# 	"${FILESDIR}/${PN}"-6.0.2-no_xmlpp.patch
# 	"${FILESDIR}/${PN}"-5.0.11-niftiio_var_fix.patch
# 	"${FILESDIR}/${PN}"-5.0.11-fslsurface_parallel_make.patch
# 	"${FILESDIR}/${PN}"-6.0.2-qstring_compat.patch
# 	"${FILESDIR}/${PN}"-5.0.9-headers.patch
	"${FILESDIR}/${PN}"-6.0.4-flameo_std.patch
	"${FILESDIR}/${PN}"-6.0.4-melodic_std.patch
	"${FILESDIR}/${PN}"-6.0.4-remove_fslpy_collisions-p1.patch
	"${FILESDIR}/${PN}"-6.0.4-remove_fslpy_collisions-p2.patch
# 	"${FILESDIR}/${PN}"-6.0.4-fdt_cuda.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:@@GENTOO_RANLIB@@:$(tc-getRANLIB):" \
		-e "s:@@GENTOO_CC@@:$(tc-getCC):" \
		-e "s:@@GENTOO_CXX@@:$(tc-getCXX):" \
		config/buildSettings.mk || die

	eprefixify $(grep -rl GENTOO_PORTAGE_EPREFIX src/*) \
		etc/js/label-div.html

# 	# Disable mist the hard way for now.
# 	rm -r src/mist || die
#
# 	# Disable ptx2 for now
# 	rm -r src/ptx2 || die
#
	makefilelist=$(find src/ -name Makefile)

# 	sed -i \
# 		-e "s:-I\${INC_BOOST}::" \
# 		-e "s:-I\${INC_ZLIB}::" \
# 		-e "s:-I\${INC_GD}::" \
# 		-e "s:-I\${INC_PNG}::" \
# 		-e "s:-L\${LIB_GD}::" \
# 		-e "s:-L\${LIB_PNG}::" \
# 		-e "s:-L\${LIB_ZLIB}::" \
# 		${makefilelist} || die

	sed -e "s:\${FSLDIR}/bin/::g" \
		-e "s:\$FSLDIR/bin/::g" \
		-i $(grep -rl "\${FSLDIR}/bin" src/*) \
		-i $(grep -rl "\$FSLDIR/bin" src/*) \
		$(grep -rl "\${FSLDIR}/bin" etc/matlab/*)\
		$(grep -rl "\$FSLDIR/bin" etc/matlab/*) || die

	sed -e "s:\$FSLDIR/data:${EPREFIX}/usr/share/fsl/data:g" \
		-e "s:\${FSLDIR}/data:${EPREFIX}/usr/share/fsl/data:g" \
		-i $(grep -rl "\$FSLDIR/data" src/*) \
		$(grep -rl "\${FSLDIR}/data" src/*) || die

	sed -e "s:\$FSLDIR/doc:${EPREFIX}/usr/share/fsl/doc:g" \
		-e "s:\${FSLDIR}/doc:${EPREFIX}/usr/share/fsl/doc:g" \
		-i $(grep -rl "\$FSLDIR/doc" src/*) \
		$(grep -rl "\${FSLDIR}/doc" src/*) || die

	sed -e "s:/usr/share/fsl/doc:${EPREFIX}/usr/share/fsl/doc:g" \
		-i $(grep -rl "/usr/share/fsl/doc" src/*) || die

	sed -e "s:\$FSLDIR/etc:${EPREFIX}/etc:g" \
		-e "s:\${FSLDIR}/etc:${EPREFIX}/etc:g" \
		-i $(grep -rlI "\$FSLDIR/etc" *) \
		-i $(grep -rlI "\${FSLDIR}/etc" *) || die

	# Use generic blas/lapack rather than openblas
	sed -e "s:-lopenblas:-llapack -lblas:g" \
		-i $(grep -rlI lopenblas *) || die

	# script wanting to have access to fslversion at buildtime
	sed -e "s:/etc/fslversion:${S}/etc/fslversion:g" \
		-i ${makefilelist} || die

	if use cuda; then
		einfo

		gcc_ver=`gcc-fullversion`
		einfo "GCC version: ${gcc_ver}"

		cuda_gcc=`cuda_gccdir`
		cuda_NVCC_flags=`cuda_gccdir -f`
		einfo "CUDA GCC path: ${cuda_gcc}"
		einfo "  ${cuda_NVCC_flags}"

		CUDA_INSTALLATION="/opt/cuda"
		CUDAVER=`cuda_toolkit_version`

		eapply "${FILESDIR}/${PN}-6.0.4-eddy_cuda.patch"
		eapply "${FILESDIR}/${PN}-6.0.4-cuda_buildsettings.patch"

		sed -i \
			-e "s:@@GENTOO_NVCC_FLAGS@@:${cuda_NVCC_flags}:" \
			src/eddy/Makefile || die

		cuda_sanitize
	fi
}

src_compile() {
	export FSLDIR=${WORKDIR}/${PN}
	export FSLCONDIR=${WORKDIR}/${PN}/config
	export FSLMACHTYPE=generic

	# define the default build system to match upstream official standard
	#  -> individual projects may overwrite the '-std=' flag
	export ANSI_CFLAGS="-std=c99"
	export ANSI_CXXFLAGS="-std=c++98"

	export USERLDFLAGS="${LDFLAGS}"
	export USERCFLAGS="${CFLAGS}"
	export USERCPPFLAGS="${CPPFLAGS}"
	export USERCXXFLAGS="${CXXFLAGS}"

	export CIFTICFLAGS="$($(tc-getPKG_CONFIG) --cflags CiftiLib)"
	export CIFTILIBS="$($(tc-getPKG_CONFIG) --libs-only-l CiftiLib)"

	if use cuda; then
		einfo "CUDA_INSTALLATION: ${CUDA_INSTALLATION}"
		einfo "CUDAVER: ${CUDAVER}"
	fi

	./build || die
}

src_install() {
	sed -i "s:\${FSLDIR}/tcl:/usr/libexec/fsl:g" \
		$(grep -lI "\${FSLDIR}/tcl" bin/*) \
		$(grep -l "\${FSLDIR}/tcl"  tcl/*) || die
	sed -i "s:\$FSLDIR/tcl:/usr/libexec/fsl:g" \
		$(grep -l "\$FSLDIR/tcl" tcl/*) || die

	dobin bin/*

	insinto /usr/share/${PN}
	doins -r data
	dodoc -r doc/. refdoc

	insinto /usr/libexec/fsl
	doins -r tcl/*

	insinto /etc/fslconf
	doins etc/fslconf/fsl.sh

	insinto /etc
	doins etc/fslversion
	doins -r etc/default_flobs.flobs etc/flirtsch etc/js etc/luts

	#the following is needed for FSL and depending programs to be able
	#to find its files, since FSL uses an uncommon installation path:
	#https://github.com/gentoo-science/sci/pull/612#r60289295
	dosym ../../../etc ${UPSTREAM_FSLDIR}/etc
	dosym ../doc/${PF} ${UPSTREAM_FSLDIR}/doc
	dosym ../../bin ${UPSTREAM_FSLDIR}/bin

	doenvd "$(prefixify_ro "${FILESDIR}"/99fsl)"
	mv "${ED}"/usr/bin/{,fsl_}cluster || die
}

pkg_postinst() {
	echo
	einfo "Please run the following commands if you"
	einfo "intend to use fsl from an existing shell:"
	einfo "env-update && source /etc/profile"
	echo
}
