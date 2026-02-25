{
  description = "ai-nix — A collection of AI tools packaged for Linux via Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      perSystem = {
        pkgs,
        ...
      }: let
        sources = pkgs.callPackage ./_sources/generated.nix {};
      in {
        packages.codex-desktop = pkgs.callPackage ./pkgs/codex/package.nix {inherit sources;};
      };
    };
}
