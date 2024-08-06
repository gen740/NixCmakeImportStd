{
  description = "Flake shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShellNoCC {
          packages = [
            pkgs.llvmPackages_19.clang-tools
            (pkgs.llvmPackages_19.libcxxClang.overrideAttrs (oldAttrs: {
              postFixup =
                oldAttrs.postFixup
                + ''
                  ln -sf  ${oldAttrs.passthru.libcxx}/lib/libc++.modules.json $out/resource-root/libc++.modules.json
                  ln -sf  ${oldAttrs.passthru.libcxx}/share $out
                '';
            }))
            (pkgs.cmake.overrideAttrs (oldAttrs: {
              version = "3.30.2";
              src = oldAttrs.src.overrideAttrs { outputHash = null; };
            }))
            pkgs.ninja
          ];
        };
      }
    );
}
