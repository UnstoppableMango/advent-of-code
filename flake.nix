{
  description = "Advent of Code Solutions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.treefmt-nix.flakeModule ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              cargo
              dotnetCorePackages.sdk_10_0
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
            ];
          };

          treefmt = {
            programs.nixfmt.enable = true;
          };
        };
    };
}
