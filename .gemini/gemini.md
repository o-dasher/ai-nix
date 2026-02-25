# ai-nix — Gemini Agent Guidelines

## Project overview

**ai-nix** is a Nix flake that groups multiple AI-related projects into a single, reproducible, and auto-updatable packaging layer for Linux. Each tool lives under `pkgs/<tool-name>/` with its own `package.nix` derivation.

## Tech stack

- **Nix / NixOS** — all packaging is done via Nix flakes.
- **Language**: Nix expression language for derivations; shell scripts for install helpers.
- **Targets**: `x86_64-linux` and `aarch64-linux`.

## Repository layout

```
flake.nix          — Flake entry point (inputs, outputs, packages, apps)
flake.lock         — Pinned dependency versions
pkgs/              — One subdirectory per AI tool
  └── <tool>/
      ├── package.nix   — Nix derivation
      ├── install.sh    — (optional) standalone installer
      └── README.md     — (optional) per-tool docs
```

## Key conventions

1. **One package per directory** — each tool gets its own `pkgs/<name>/` folder.
2. **Wire packages in `flake.nix`** — expose them via `packages.<system>.<name>` and optionally `apps.<system>.<name>`.
3. **Pin native dependencies** — when recompiling native Node/Rust/C modules, pin upstream tarball hashes in `package.nix` so builds are reproducible.
4. **Auto-updatability** — use `nvfetcher` to track upstream versions and prefetch hashes. Run `nvfetcher` at the project root to regenerate `_sources/generated.nix`. Commit the resulting `_sources/` changes.
5. **Commit messages** — use conventional commits (`feat:`, `fix:`, `chore:`, etc.).

## Adding a new package

1. Create `pkgs/<tool>/package.nix`. Accept a `sources` argument for any fetched sources.
2. Add source entries to `nvfetcher.toml` at the project root.
3. Run `nvfetcher` to generate/update `_sources/generated.nix`.
4. Add it to `flake.nix` outputs (both `packages` and `apps` if applicable), passing `sources` via `callPackage`.
5. Optionally add a per-tool `README.md` under its package directory.
6. Update the root `README.md` package table.

## Things to watch out for

- The Codex Desktop package recompiles native Node modules (`better-sqlite3`, `node-pty`) for Linux — if upstream updates these module versions, the tarball hashes in `package.nix` must be updated.
- `electron_40` is sourced from nixpkgs; if Codex bumps its Electron version, update the derivation accordingly.
