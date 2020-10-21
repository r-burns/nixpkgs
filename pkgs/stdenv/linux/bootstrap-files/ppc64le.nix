let
  # https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.powerpc64le.build/latest
  baseurl = "https://hydra.nixos.org/build/135361687/download/1/stdenv-bootstrap-tools-powerpc64le-unknown-linux-gnu/on-server/";
in {
  busybox = import <nix/fetchurl.nix> {
    url = baseurl + "busybox";
    sha256 = "1m6jxdakxnb19s54xqd2vqj8cpb1h4jg3nm2b8zpqb7zax6as2c0";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = baseurl + "bootstrap-tools.tar.xz";
    sha256 = "0nlrl9sxs8myjs7acb1lwdfp9b50lg8nd3pksa973cs0rdxvx2bc";
  };
}
