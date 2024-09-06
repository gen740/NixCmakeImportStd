with import <nixpkgs> { };
pkgs.mkShell {
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
      src = oldAttrs.src.overrideAttrs {
        outputHash = "sha256-RgdMeB7M68Qz6Y8Lv6Jlyj/UOB8kXKOxQOdxFTHWDbI=";
      };
    }))
    ninja
  ];
}
