with import <nixpkgs> { };

mkShell.override { stdenv = llvmPackages.libcxxStdenv; } {
  packages = [
    (llvmPackages.clang-tools.override { enableLibcxx = true; })
    llvmPackages.libcxxClang
    cmake
    ninja
  ];
  # Fails to build with -D_FORTIFY_SOURCE.
  hardeningDisable = [ "fortify" ];
  shellHook = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${llvmPackages.libcxxClang.libcxx}/lib";
  '';
}
