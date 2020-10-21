let
  # https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.powerpc64le.build/latest
  baseurl = "https://hydra.nixos.org/build/148773741/download/1/stdenv-bootstrap-tools-powerpc64le-unknown-linux-gnu/on-server/";
in {
  busybox = import <nix/fetchurl.nix> {
    url = baseurl + "busybox";
    sha256 = "sha256-C2gcxq8s7dpdM530LJuLgEHgbXyacUUJO3jQUUpltLc=";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = baseurl + "bootstrap-tools.tar.xz";
    sha256 = "sha256-Nv0jYFN/3YEwHQQw3CWYjFuIiExYquT+4RH5IhMsLtI=";
  };
}
