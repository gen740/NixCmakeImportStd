with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "import_std_example";
  src = ./.;
  nativeBuildInputs = with buildPackages; [
    llvmPackages_19.clang-tools
    (llvmPackages_19.libcxxClang.overrideAttrs (oldAttrs: {
      postFixup =
        oldAttrs.postFixup
        + ''
          ln -sf  ${oldAttrs.passthru.libcxx}/lib/libc++.modules.json $out/resource-root/libc++.modules.json
          ln -sf  ${oldAttrs.passthru.libcxx}/share $out
        '';
    }))
    (cmake.overrideAttrs (oldAttrs: {
      version = "3.30.2";
      src = oldAttrs.src.overrideAttrs { outputHash = null; };
    }))
    ninja
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp main $out/bin
  '';
}
