with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "import_std_example";
  src = ./.;
  nativeBuildInputs = with buildPackages; [
    llvmPackages_19.clang-tools
    llvmPackages_19.libcxxClang
    cmake
    ninja
  ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${buildPackages.llvmPackages_19.libcxxClang.libcxx}/lib";
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp main $out/bin
  '';
}
