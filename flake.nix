{
  description = "ai-nix — A collection of AI tools packaged for Linux via Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, llm-agents, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ nixfmt ];
          };

          packages =
            let
              sources = pkgs.callPackage ./_sources/generated.nix { };
              codex = llm-agents.packages.${system}.codex;
            in
            {
              codex-desktop = pkgs.callPackage ./pkgs/codex-app/package.nix {
                inherit codex sources;
              };
            };
        };
    };
}
