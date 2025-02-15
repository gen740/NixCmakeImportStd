with import <nixpkgs> { };
llvmPackages.libcxxStdenv.mkDerivation {
  name = "import_std_example";
  src = ./.;
  nativeBuildInputs = [
    (llvmPackages.clang-tools.override { enableLibcxx = true; })
    llvmPackages.libcxxClang
    cmake
    ninja
  ];
  # Fails to build with -D_FORTIFY_SOURCE.
  hardeningDisable = [ "fortify" ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${llvmPackages.libcxxClang.libcxx}/lib";
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp main $out/bin
  '';
}
