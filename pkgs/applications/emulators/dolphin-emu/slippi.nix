{ lib, stdenv
, alsa-lib
, bluez
, cmake
, curl
, fetchFromGitHub
, fetchpatch
, ffmpeg
, gettext
, glib
, gtest
, gtk3
, libGL
, libGLU
, libSM
, libXdmcp
, libXext
, libXinerama
, libXrandr
, libXxf86vm
, libao
, libevdev
, libpthreadstubs
, libpulseaudio ? null
, udev
, libusb1
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
, soil
, vulkan-loader
, webkitgtk
, wxGTK31
}:

stdenv.mkDerivation rec {
  pname = "slippi-dolphin";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "project-slippi";
    repo = "Ishiiruka";
    rev = "v${version}";
    sha256 = "sha256-MlWIVxH/5R0a1Vz823BWou2fNPDu09yMjBlbwaBw/L8=";
  };

  postPatch = ''
    rm -r Externals/{ffmpeg,libpng,portaudio,SOIL}

    [[ -e '${vulkan-loader}/lib/libvulkan.so.1' ]] && \
      substituteInPlace Source/Core/VideoBackends/Vulkan/VulkanLoader.cpp \
        --replace '"libvulkan.so.1"' '"${vulkan-loader}/lib/libvulkan.so.1"'
  '';

  CXXFLAGS = "-Wno-format-security";

  cmakeFlags = [
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK3_GDKCONFIG_INCLUDE_DIR=${gtk3.out}/lib/gtk-2.0/include"
    "-DGTK3_INCLUDE_DIRS=${gtk3.dev}/include/gtk-2.0"
    "-DENABLE_LTO=True"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkgconfig
  ];

  buildInputs = [
    alsa-lib
    bluez
    curl
    ffmpeg
    gettext
    glib
    gtest
    gtk3
    libGL
    libGLU
    libSM
    libXdmcp
    libXext
    libXinerama
    libXrandr
    libXxf86vm
    libao
    libevdev
    libpthreadstubs
    libpulseaudio
    udev
    libusb1
    lzo
    mbedtls
    miniupnpc
    openal
    pcre
    portaudio
    readline
    sfml
    soil
    webkitgtk
    (wxGTK31.override { withGtk2 = false; })
  ];

  postInstall = ''
    rm -r $out/{include,lib,share/locale}
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 $src/Data/51-usb-device.rules $out/etc/udev/rules.d/51-usb-device.rules
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
