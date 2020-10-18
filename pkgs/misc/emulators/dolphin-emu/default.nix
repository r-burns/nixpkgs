{ stdenv
, lib
, fetchpatch
, pkgconfig
, cmake
, bluez
, ffmpeg_3
, libao
, gtk2
, glib
, gtest
, libGLU
, libGL
, gettext
, libpthreadstubs
, libXrandr
, libXext
, readline
, openal
, libXdmcp
, portaudio
, fetchFromGitHub
, libusb1
, libevdev
, wxGTK30
, soundtouch
, miniupnpc
, mbedtls
, curl
, lzo
, sfml
, libpulseaudio ? null
, darwin
, wxmac
, enet
, xxHash
}:

stdenv.mkDerivation rec {
  pname = "dolphin-emu";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    rev = version;
    sha256 = "07mlfnh0hwvk6xarcg315x7z2j0qbg9g7cm040df9c8psiahc3g6";
  };

  patches = [
    # Fix build with soundtouch 2.1.2
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/dolphin-emu/raw/a1b91fdf94981e12c8889a02cba0ec2267d0f303/f/dolphin-emu-5.0-soundtouch-exception-fix.patch";
      name = "dolphin-emu-5.0-soundtouch-exception-fix.patch";
      sha256 = "0yd3l46nja5qiknnl30ryad98f3v8911jwnr67hn61dzx2kwbbaw";
    })
    # Use shared libs whenever possible
    ./5.0-no-external.patch
  ] ++ lib.optionals stdenv.cc.isGNU [
    # Fix build with gcc 8
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/dolphin-emu/raw/9b7b4aeac1b60dcf28bdcafbed6bc498b2aeb0ad/debian/patches/03_gcc8.patch";
      name = "03_gcc8.patch";
      sha256 = "1da95gb8c95kd5cjhdvg19cv2z863lj3va5gx3bqc7g8r36glqxr";
    })
  ];

  postPatch = ''
    substituteInPlace Source/Core/VideoBackends/OGL/RasterFont.cpp \
      --replace "CHAR_WIDTH" "CHARWIDTH"

    # On Darwin, Dolphin fudges the install prefix - let's thwart that
    substituteInPlace CMakeLists.txt \
      --replace 'set(CMAKE_INSTALL_PREFIX' 'set(DONT_MODIFY_CMAKE_INSTALL_PREFIX'
    substituteInPlace Source/Core/DolphinWX/CMakeLists.txt \
      --replace 'DESTINATION /Applications' 'DESTINATION Applications'
  '';

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${gtk2.dev}/include/gtk-2.0"
    "-DENABLE_LTO=True"
    "-DUSE_SHARED_ENET=ON"
    "-DUSE_SHARED_GTEST=ON"
    "-DXXHASH_FOUND=TRUE"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig
    cmake
  ];

  buildInputs = [
    ffmpeg_3
    libao
    libGLU
    libGL
    gtk2
    glib
    gettext
    libpthreadstubs
    libXrandr
    libXext
    readline
    openal
    libXdmcp
    portaudio
    libpulseaudio
    libXdmcp
    portaudio
    libusb1
    libpulseaudio
    soundtouch
    miniupnpc
    mbedtls
    curl
    lzo
    sfml
    gtest
    enet
    xxHash
    (if stdenv.hostPlatform.isDarwin then wxmac else wxGTK30)
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    bluez
    libevdev
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    ForceFeedback
    OpenAL
  ]);

  meta = with lib; {
    homepage = "https://dolphin-emu.org/";
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARMv8";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ MP2E ashkitten ];
    # x86_32 is an unsupported platform.
    # Enable generic build if you really want a JIT-less binary.
    platforms = with platforms; x86_64 ++ aarch64;
  };
}
