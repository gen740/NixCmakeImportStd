with import <nixpkgs> {
  overlays = [
    (final: prev: {
      llvmPackages_19 = prev.llvmPackages_19 // {
        clang-tools = prev.llvmPackages_19.clang-tools.override { enableLibcxx = true; };
      };
    })
  ];
};

pkgs.mkShell {
  nativeBuildInputs = with buildPackages; [
    llvmPackages_19.clang-tools
    llvmPackages_19.libcxxClang
    cmake
    ninja
  ];
  shellHook = ''
    export CC=${llvmPackages_19.libcxxClang}/bin/clang
    export CXX="${llvmPackages_19.libcxxClang}/bin/clang++ -stdlib=libc++"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${llvmPackages_19.libcxxClang.libcxx}/lib";
  '';
}
