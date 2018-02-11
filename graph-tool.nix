{ stdenv, fetchurl, python, cairomm, sparsehash, pycairo, automake, m4,
pkgconfig, boost, expat, scipy, numpy, cgal, gmp, mpfr, lndir, makeWrapper,
gobjectIntrospection, pygobject3, gtk3, matplotlib, autoconf, libtool,
ncurses }:

stdenv.mkDerivation rec {
  version = "2.26";
  name = "${python.libPrefix}-graph-tool-${version}";

  pythonModule = python; # in order to be detected by python.buildEnv extraLibs

  meta = with stdenv.lib; {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage    = http://graph-tool.skewed.de/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainer  = [ stdenv.lib.maintainers.joelmo ];
  };

  src = fetchurl {
    url = "https://git.skewed.de/count0/graph-tool/repository/release-${version}/archive.tar.gz";
    sha256 = "1j5aa7r0mjx2cbqn1rjslrr7d8dpin25wbkbqsr8r8d8xmflwa92";
  };

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
    configureFlags="--with-python-module-path=$out/${python.sitePackages} --enable-openmp \
                    --with-boost-libdir=${boost}/lib --with-expat=${expat} --with-cgal=${cgal}"
  '';

  buildInputs = [ automake m4 pkgconfig makeWrapper autoconf libtool ncurses ];

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