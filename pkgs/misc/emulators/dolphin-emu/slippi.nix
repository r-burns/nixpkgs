{ stdenv, lib
, bluez
, cmake
, curl
, fetchFromGitHub
, fetchpatch
, ffmpeg_3
, gettext
, glib
, gtest
, gtk2
, libao
, libevdev
, libGL
, libGLU
, libpthreadstubs
, libpulseaudio ? null
, libSM
, libudev
, libusb1
, libXdmcp
, libXext
, libXinerama
, libXrandr
, libXxf86vm
, lzo
, mbedtls
, miniupnpc
, ninja
, openal
, pcre
, pkgconfig
, portaudio
, readline
, sfml
}:

stdenv.mkDerivation rec {
  pname = "slippi-dolphin";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "project-slippi";
    repo = "Ishiiruka";
    rev = "v${version}";
    sha256 = "0jj4s8ykl2qqwkg78gnl1n042y5f3hs003zdnxcp2r7cacsa0dsg";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/project-slippi/Ishiiruka/commit/bd7da4245eae7182c34daba11f123587a914436e.patch";
      sha256 = "1vjzvn8877qvrbq8ni1bda5cpsdc55dga62n502a818pmmcv1jqd";
    })
  ];

  postPatch = ''
    rm -rf Externals/{ffmpeg,portaudio,libpng}
  '';

  CXXFLAGS = "-Wno-format-security";

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${gtk2.dev}/include/gtk-2.0"
    "-DENABLE_LTO=True"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkgconfig
  ];

  buildInputs = [
    bluez
    curl
    ffmpeg_3
    gettext
    glib
    gtest
    gtk2
    libao
    libGLU
    libGL
    libSM
    libevdev
    libpthreadstubs
    libpulseaudio
    libudev
    libusb1
    libXdmcp
    libXext
    libXinerama
    libXrandr
    libXxf86vm
    lzo
    mbedtls
    miniupnpc
    openal
    pcre
    portaudio
    readline
    sfml
  ];

  postInstall = ''
    rm -r $out/{include,lib,share/locale}
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -D $src/Data/51-usb-device.rules $out/etc/udev/rules.d/51-usb-device.rules
  '';

  meta = with lib; {
    homepage = "https://slippi.gg";
    description = "Custom Dolphin build for SSBM netplay";
    longDescription = ''
      The goal of Slippi is to bring Melee into the future
      and invigorate the sport surrounding the game.
      So far this has come in the form of enabling:
      - Portable replay files
      - Complex gameplay stats
      - Improved streaming video quality
      - Improved online netcode
      - Online matchmaking
      - And more
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ r-burns ];
    platforms = [ "x86_64-linux" ];
  };
}
