# Example Repository for CMake `import std` Using Nix

This repository provides an example of using CMake's `import std` feature within a Nix environment. The setup has been tested on both macOS and NixOS.

## Known Issues
Using `import std` with CMake is still a work in progress and comes with numerous unresolved issues. The following known issues may significantly impact the setup, making it challenging to use reliably:

- [LLVM Issue #120215](https://github.com/llvm/llvm-project/issues/120215)
- [LLVM Issue 121709](https://github.com/llvm/llvm-project/issues/121709)
- [CMake Issue #25965](https://gitlab.kitware.com/cmake/cmake/-/issues/25965)
- [Nixpkgs Issue #370217](https://github.com/NixOS/nixpkgs/issues/370217)

## Build Instructions
### 1. Building the Project
Run the following command to build the project:

```sh
nix-build  # For non-flake users
nix build  # For flake users
```

### 2. Development Shell
To enter a development shell with the required dependencies, use:

```sh
nix-shell   # For non-flake users
nix develop # For flake users
```

This will provide an environment where you can manually build and test the project.
