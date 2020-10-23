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
    url = "https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux";
    sha256 = "16p3bv1lwmyqpxil8r951h385sy9asc578afrc7lssa68c71ydcj";

    gcc = gcc7;
  };

  cudatoolkit_10_1 = common {
    version = "10.1.243";
    url = "https://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.243_418.87.00_linux.run";
    sha256 = "0caxhlv2bdq863dfp6wj7nad66ml81vasq2ayf11psvq2b12vhp7";

    gcc = gcc7;
  };

  cudatoolkit_10_2 = let
    downloads = {
      x86_64-linux = {
        url = "http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run";
        sha256 = "04fasl9sjkb1jvchvqgaqxprnprcz7a8r52249zp2ijarzyhf3an";
      };
      powerpc64le-linux = {
        url = "http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux_ppc64le.run";
        sha256 = "06f61wf0nwbnxfds9wm983r2syjxlwbagw0lhwnvs44brd7pf9sj";
      };
    };
  in common ({
    version = "10.2.89";
    gcc = gcc7;
  } // downloads."${stdenv.hostPlatform.system}");

  cudatoolkit_10 = cudatoolkit_10_2;

  cudatoolkit_11_0 = let
    downloads = {
      x86_64-linux = {
        url = "https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda_11.0.3_450.51.06_linux.run";
        sha256 = "1h4c69nfrgm09jzv8xjnjcvpq8n4gnlii17v3wzqry5d13jc8ydh";
      };
      powerpc64le-linux = {
        url = "https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda_11.0.3_450.51.06_linux_ppc64le.run";
        sha256 = "15075qnh8386rllgxh7l162h0p074jili6zzmwxl7c84y0fv4xa7";
      };
    };
  in common ({
    version = "11.0.3";
    gcc = gcc9;
  } // downloads."${stdenv.hostPlatform.system}");

  cudatoolkit_11_1 = common {
    version = "11.1.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda_11.1.1_455.32.00_linux.run";
    sha256 = "13yxv2fgvdnqqbwh1zb80x4xhyfkbajfkwyfpdg9493010kngbiy";
    gcc = gcc9;
  };

  cudatoolkit_11_2 = common {
    version = "11.2.1";
    url = "https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda_11.2.1_460.32.03_linux.run";
    sha256 = "sha256-HamMuJfMX1inRFpKZspPaSaGdwbLOvWKZpzc2Nw9F8g=";
    gcc = gcc9;
  };

  cudatoolkit_11 = cudatoolkit_11_2;
}
