{
  description = "Flake shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:

    flake-utils.lib.eachDefaultSystem (
      system: with nixpkgs.legacyPackages.${system}; {
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
        };
      }
    );
}
