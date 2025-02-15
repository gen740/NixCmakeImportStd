with import <nixpkgs> {
  overlays = [
    (final: prev: {
      llvmPackages_19 = prev.llvmPackages_19 // {
        libcxxStdenv = prev.llvmPackages_19.libcxxStdenv.override {
          stdenv = prev.llvmPackages_19.stdenv.override {
            libc = prev.llvmPackages_19.libc; # LLVM libc を指定
          };
        };
      };
      libcxxClang = prev.llvmPackages_19.libcxxClang.override {
        stdenv = final.llvmPackages_19.libcxxStdenv;
      };
    })
    (final: prev: {
      llvmPackages_19 = prev.llvmPackages_19 // {
        clang-tools = prev.llvmPackages_19.clang-tools.override { enableLibcxx = true; };
      };
    })
  ];
};

stdenv.mkDerivation {
  name = "import_std_example";
  src = ./.;
  nativeBuildInputs = [
    llvmPackages_19.clang-tools
    llvmPackages_19.libcxxClang
    cmake
    ninja
  ];
  preConfigure = ''
    # Fails to build with -D_FORTIFY_SOURCE.
    NIX_HARDENING_ENABLE=''${NIX_HARDENING_ENABLE/fortify/}
    NIX_HARDENING_ENABLE=''${NIX_HARDENING_ENABLE/fortify3/}

    export CC=${llvmPackages_19.libcxxClang}/bin/clang
    export CXX=${llvmPackages_19.libcxxClang}/bin/clang++
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${llvmPackages_19.libcxxClang.libcxx}/lib";
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp main $out/bin
  '';
}
