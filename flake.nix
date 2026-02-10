{
  description = "U-boot build environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            # Build tool (GNU Make)
            gnumake
            # RISC-V Cross Compiler (Linux version)
            pkgsCross.riscv64.buildPackages.gcc
            # Device Tree Compiler
            dtc
            # Python 3 for Kconfiglib and other scripts
            python3

            coreutils
            flex
            bison
            openssl
          ];

          shellHook = ''
            # Set the cross-compiler prefix for the Makefile
            export CROSS_COMPILE=riscv64-unknown-linux-gnu-

            echo "OpenSBI (Hikami Feature) build environment loaded."
            echo "Compiler: $(riscv64-none-elf-gcc --version | head -n 1)"
          '';
        };
      }
    );
}
