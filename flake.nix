{
  description = "Use cmake, ninja, and clang to import std";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      forSystems =
        attrs: systems:
        builtins.foldl' (
          result: system:
          nixpkgs.lib.attrsets.recursiveUpdate result (
            builtins.mapAttrs (_: v: { ${system} = v; }) (attrs system)
          )
        ) { } systems;
    in
    forSystems (
      system:
      with import nixpkgs {
        system = system;
      }; rec {
        devShells.default = mkShell.override { stdenv = llvmPackages.libcxxStdenv; } {
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
        };
        packages.default = llvmPackages.libcxxStdenv.mkDerivation {
          name = "import_std_example";
          src = ./.;
          nativeBuildInputs = devShells.default.packages;
          hardeningDisable = [ "fortify" ];
          preConfigure = ''
            export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${llvmPackages.libcxxClang.libcxx}/lib";
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp main $out/bin
          '';
        };
      }
    ) nixpkgs.lib.platforms.all;
}
