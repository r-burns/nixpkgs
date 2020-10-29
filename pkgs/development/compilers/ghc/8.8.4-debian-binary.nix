{ stdenv, lib, fetchurl
, dpkg
, glibc
, gmp
, libffi
, ncurses
, patchelf
, perl
, which
}:

# Prebuilt only does native
assert stdenv.targetPlatform == stdenv.hostPlatform;

let
  srcs = {
    powerpc64le-linux = fetchurl {
      url = "http://ftp.debian.org/debian/pool/main/g/ghc/ghc_8.8.4-1_ppc64el.deb";
      sha256 = "e72c0fa97b92666c98efeea01843a717c522b8ac34dfaad2a9cd0e25ca13aa33";
    };
  };
in stdenv.mkDerivation rec {

  version = "8.8.4";
  name = "ghc-${version}-debian-binary";

  src = srcs."${stdenv.system}";
  unpackCmd = "dpkg-deb -x ${src} .";
  sourceRoot = ".";

  nativeBuildInputs = [
    dpkg
    patchelf
    perl
    which
  ];
  buildInputs = [
    glibc
    gmp
    libffi
    ncurses
    stdenv.cc.cc.lib
  ];
  propagatedBuildInputs = [
    gmp
    libffi
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    mv usr/* $out/

    # Replace broken symlink
    rm $out/lib/ghc/package.conf.d
    mv var/lib/ghc/package.conf.d $out/lib/ghc/

    # Patch wrappers to point to store path
    for f in $out/bin/* $out/lib/ghc/package.conf.d/*.conf; do
      substituteInPlace $f --replace "/usr" "$out"
    done

    rm $out/lib/ghc/bin/ghc-split
    for f in $out/lib/ghc/bin/*; do
      oldrpath="$(patchelf --print-rpath $f)"
      patchelf $f --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${lib.makeLibraryPath buildInputs}:$oldrpath"
    done
    for f in $out/lib/ghc/*/*.so; do
      oldrpath="$(patchelf --print-rpath $f)"
      patchelf $f --set-rpath "${lib.makeLibraryPath buildInputs}:$oldrpath"
    done


    substituteInPlace $out/lib/ghc/settings \
      --replace '/bin/false' "$(which false)" \
      --replace '/usr/bin/perl' "$(which perl)" \

    for exe in gcc ar ranlib ld.gold; do
      sed -i "s,[a-z0-9]*-linux-gnu-$exe,$(which $exe)," $out/lib/ghc/settings
    done

    # Recompute package cache
    (cd $out/lib/ghc/package.conf.d && $out/bin/ghc-pkg recache -v)
  '';

  passthru = {
    targetPrefix = "";
    enableShared = true;
  };

  meta = with lib; {
    platforms = attrNames srcs;
    maintainers = with maintainers; [ r-burns ];
    license = licenses.bsd3;
  };
}
