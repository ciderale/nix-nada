{ stdenv, fetchurl, python, cairomm, sparsehash, pycairo, automake, m4,
pkgconfig, boost, expat, scipy, numpy, cgal, gmp, mpfr, lndir, makeWrapper,
gobjectIntrospection, pygobject3, gtk3, matplotlib, autoconf, libtool,
ncurses, gcc }:

stdenv.mkDerivation rec {
#buildPythonPackage rec {
  version = "2.26";
  name = "${python.libPrefix}-graph-tool-${version}";

  meta = with stdenv.lib; {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage    = http://graph-tool.skewed.de/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainer  = [ stdenv.lib.maintainers.joelmo ];
  };

  src = fetchurl {
    #url = "https://github.com/count0/graph-tool/archive/release-${version}.tar.gz";
    #sha256 = "12w58djyx6nn00wixqnxnxby9ksabhzdkkvynl8b89parfvfbpwl";
    url = "https://git.skewed.de/count0/graph-tool/repository/release-${version}/archive.tar.gz";
    sha256 = "1j5aa7r0mjx2cbqn1rjslrr7d8dpin25wbkbqsr8r8d8xmflwa92";
  };

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
    configureFlags="--with-python-module-path=$out/${python.sitePackages} --enable-openmp --with-boost-libdir=${boost.out}/lib --with-expat=${expat.out} --with-cgal=${cgal}"
  '';

  shellHook = ''
    #export NIX_CXXSTDLIB_LINK=""
    '';

  buildInputs = [ automake m4 pkgconfig makeWrapper autoconf libtool ncurses gcc expat];

  propagatedBuildInputs = [
    boost
    cgal
    expat
    gmp
    mpfr
    python
    scipy
    # optional
    sparsehash
    # drawing
    cairomm
    gobjectIntrospection
    gtk3
    pycairo
    matplotlib
    pygobject3
  ];

  enableParallelBuilding = false;
}