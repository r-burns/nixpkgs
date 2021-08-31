{ lib, stdenv
, fetchFromGitHub
, zlib
}:

let
  version = "unstable-20210830";
  rev = "db097f7849366ac560f6c4de4d1c7d0e7e768ab5";
in

stdenv.mkDerivation rec {
  pname = "mrustc";
  inherit version;

  # Always update minicargo.nix and bootstrap.nix in lockstep with this
  src = fetchFromGitHub {
    owner = "thepowersgang";
    repo = "mrustc";
    inherit rev;
    sha256 = "0yw1mlngf2m27f0zmqyn9y9fdv1y2jly0mdwnkh479sf2y8l8jbw";
  };

  postPatch = ''
    sed -i 's/\$(shell git show --pretty=%H -s)/${rev}/' Makefile
    sed -i 's/\$(shell git symbolic-ref -q --short HEAD || git describe --tags --exact-match)/${rev}/' Makefile
    sed -i 's/\$(shell git diff-index --quiet HEAD; echo $$?)/0/' Makefile
  '';

  strictDeps = true;
  buildInputs = [ zlib ];
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp bin/mrustc $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Mutabah's Rust Compiler";
    longDescription = ''
      In-progress alternative rust compiler, written in C++.
      Capable of building a fully-working copy of rustc,
      but not yet suitable for everyday use.
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ progval r-burns ];
    platforms = [ "x86_64-linux" ];
  };
}
