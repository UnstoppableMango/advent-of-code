{
  description = "Advent of Code Solutions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:UnstoppableMango/nix-systems";
    flake-parts.url = "github:hercules-ci/flake-parts";

    opam-nix = {
      url = "github:tweag/opam-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.systems.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = import inputs.systems;
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              aoc-cli
              cargo
              dotnetCorePackages.sdk_10_0
              dune_3
              ghc
              ghcid
              git
              gnumake
              go
              nixfmt-rfc-style
              nil
              nodejs_24
              opam
              rustc
              shellcheck
            ];
          };

          treefmt = {
            programs.nixfmt.enable = true;
            programs.ocamlformat.enable = true;
          };
        };
    };
}
