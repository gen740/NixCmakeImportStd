{
  description = "Flake shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system: with nixpkgs.legacyPackages.${system}; {
        devShells = mkShell {
          packages = [
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
        };
        packages.default = stdenv.mkDerivation {
          name = "import_std_example";
          src = ./.;
          nativeBuildInputs = [
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
          installPhase = ''
            mkdir -p $out/bin
            cp main $out/bin
          '';
        };
      }
    );
}
