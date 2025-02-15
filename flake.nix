{
  description = "Flake shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system: with nixpkgs.legacyPackages.${system}; {
        devShells.default = mkShell {
          packages = [
            llvmPackages_19.clang-tools
            llvmPackages_19.libcxxClang
            cmake
            ninja
          ];
          shellHook = ''
            export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${llvmPackages_19.libcxxClang.libcxx}/lib";
          '';
        };
        packages.default = stdenv.mkDerivation {
          name = "import_std_example";
          src = ./.;
          nativeBuildInputs = [
            llvmPackages_19.clang-tools
            llvmPackages_19.libcxxClang
            cmake
            ninja
          ];
          preConfigure = ''
            export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${llvmPackages_19.libcxxClang.libcxx}/lib";
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp main $out/bin
          '';
        };
      }
    );
}
