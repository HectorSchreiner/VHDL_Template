{
  description = "VHDL development with GHDL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
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
            gtkwave 
            yosys   # optional
          ];

          shellHook = ''
            echo "GHDL version: $(ghdl --version)"
          '';
        };
      });
}
