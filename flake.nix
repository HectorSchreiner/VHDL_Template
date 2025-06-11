{
  description = "Flake for VHDL development with GHDL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # or replace with your preferred version
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShells.default = pkgs.mkShell {
          name = "vhdl-dev-shell";
          buildInputs = with pkgs; [
            ghdl
            gtkwave # for waveform viewing
            yosys   # optional, for synthesis
          ];

          shellHook = ''
            echo "Welcome to the VHDL development environment!"
            echo "GHDL version: $(ghdl --version)"
          '';
        };
      });
}
