{ lib
, stdenv
, callPackage
, fetchurl
, gcc7
, gcc9
}:

let
  common = callPackage ./common.nix;
in rec {
  cudatoolkit_10_0 = common {
    version = "10.0.130";
    driverVersion = "410.48";
    sha256 = {
      x86_64-linux = "16p3bv1lwmyqpxil8r951h385sy9asc578afrc7lssa68c71ydcj";
    }.${stdenv.hostPlatform.system};
    gcc = gcc7;
  };

  cudatoolkit_10_1 = common {
    version = "10.1.243";
    driverVersion = "418.87.00";
    sha256 = {
      x86_64-linux = "0caxhlv2bdq863dfp6wj7nad66ml81vasq2ayf11psvq2b12vhp7";
    }.${stdenv.hostPlatform.system};
    gcc = gcc7;
  };

  cudatoolkit_10_2 = common {
    version = "10.2.89";
    driverVersion = "440.33.01";
    sha256 = {
      x86_64-linux = "04fasl9sjkb1jvchvqgaqxprnprcz7a8r52249zp2ijarzyhf3an";
      powerpc64le-linux = "06f61wf0nwbnxfds9wm983r2syjxlwbagw0lhwnvs44brd7pf9sj";
    }.${stdenv.hostPlatform.system};
    gcc = gcc7;
  };

  cudatoolkit_10 = cudatoolkit_10_2;

  cudatoolkit_11_0 = common {
    version = "11.0.3";
    driverVersion = "450.51.06";
    sha256 = {
      x86_64-linux = "1h4c69nfrgm09jzv8xjnjcvpq8n4gnlii17v3wzqry5d13jc8ydh";
      powerpc64le-linux = "15075qnh8386rllgxh7l162h0p074jili6zzmwxl7c84y0fv4xa7";
    }.${stdenv.hostPlatform.system};
    gcc = gcc9;
  };

  cudatoolkit_11_1 = common {
    version = "11.1.1";
    driverVersion = "455.32.00";
    sha256 = {
      x86_64-linux = "13yxv2fgvdnqqbwh1zb80x4xhyfkbajfkwyfpdg9493010kngbiy";
      powerpc64le-linux = "sha256-Aj5XH+Ju6CnJgTjfwwWpInmFSqx9GE0lX9WMBsavPBc=";
    }.${stdenv.hostPlatform.system};
    gcc = gcc9;
  };

  cudatoolkit_11_2 = common {
    version = "11.2.1";
    driverVersion = "460.32.03";
    sha256 = {
      x86_64-linux = "sha256-HamMuJfMX1inRFpKZspPaSaGdwbLOvWKZpzc2Nw9F8g=";
      powerpc64le-linux = "sha256-s+i2zXaHLes6zQUNMuGXvBxlXhQrFpBw8Pl1NoBGGj8=";
    }.${stdenv.hostPlatform.system};
    gcc = gcc9;
  };

  cudatoolkit_11 = cudatoolkit_11_2;
}
