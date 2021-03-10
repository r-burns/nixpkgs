# QEMU flags shared between various Nix expressions.
{ pkgs }:

let
  zeroPad = n:
    pkgs.lib.optionalString (n < 16) "0" +
      (if n > 255
       then throw "Can't have more than 255 nets or nodes!"
       else pkgs.lib.toHexString n);
in

rec {
  qemuNicMac = net: machine: "52:54:00:12:${zeroPad net}:${zeroPad machine}";

  qemuNICFlags = nic: net: machine:
    [ "-device virtio-net-pci,netdev=vlan${toString nic},mac=${qemuNicMac net machine}"
      "-netdev vde,id=vlan${toString nic},sock=$QEMU_VDE_SOCKET_${toString net}"
    ];

  qemuSerialDevice = if (with pkgs.stdenv.hostPlatform; isi686 || isx86_64 || isRiscV) then "ttyS0"
        else if (with pkgs.stdenv.hostPlatform; isAarch32 || isAarch64 || isPower) then "ttyAMA0"
        else throw "Unknown QEMU serial device for system '${pkgs.stdenv.hostPlatform.system}'";

  qemuBinary = {
    qemuGuestPkgs ? pkgs
  , qemuHostPkgs ? pkgs.pkgsBuildBuild
  , qemuPkg ? qemuHostPkgs.qemu
  }: let
    qemuHost = qemuHostPkgs.stdenv.hostPlatform;
    qemuGuest = qemuGuestPkgs.stdenv.hostPlatform;

    # If the QEMU host/guest systems match, we can enable KVM.
    native = {
      aarch64-linux = "${qemuPkg}/bin/qemu-system-aarch64 -enable-kvm -machine virt,gic-version=host -cpu host";
      armv7l-linux = "${qemuPkg}/bin/qemu-system-arm -enable-kvm -machine virt -cpu host";
      x86_64-darwin = "${qemuPkg}/bin/qemu-kvm -cpu max";
      x86_64-linux = "${qemuPkg}/bin/qemu-kvm -cpu max";
    }.${qemuGuest.system} or "${qemuPkg}/bin/qemu-kvm";

    throwSystem = throw "Unsupported guest system ${qemuGuest.system}";

    # If the platforms don't match, everything is emulated (no KVM).
    emulated = {
      powerpc64-linux = "${qemuPkg}/bin/qemu-system-ppc64 -machine powernv";
      powerpc64le-linux = "${qemuPkg}/bin/qemu-system-ppc64 -machine powernv";
      riscv64-linux = "${qemuPkg}/bin/qemu-system-riscv64 -machine virt";
    }."${qemuGuest.system}" or throwSystem;

  in if qemuHost.system == qemuGuest.system then native else emulated;
}
