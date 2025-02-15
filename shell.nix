with import <nixpkgs> { };

pkgs.mkShell {
  nativeBuildInputs = with buildPackages; [
    llvmPackages_19.clang-tools
    llvmPackages_19.libcxxClang
    cmake
    ninja
  ];
  shellHook = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${buildPackages.llvmPackages_19.libcxxClang.libcxx}/lib";
  '';
}
