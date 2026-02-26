{
  description = "ai-nix — A collection of AI tools packaged for Linux via Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        {
          pkgs,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ nixfmt ];
          };

          packages =
            let
              sources = pkgs.callPackage ./_sources/generated.nix { };
            in
            rec {
              codex = pkgs.callPackage ./pkgs/codex-cli/package.nix {
                inherit sources;
                codex = pkgs.codex;
              };
              codex-desktop = pkgs.callPackage ./pkgs/codex-app/package.nix {
                inherit sources codex;
              };
            };
        };
    };
}
