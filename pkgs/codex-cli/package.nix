{
  codex,
  lib,
  libcap,
  rustPlatform,
  stdenv,
  sources,
}:
let
  codexSource = sources.codex-cli;
  lockFileSource = sources.codex-cli-lockfile.src;
in
codex.overrideAttrs (old: {
  version = codexSource.version;
  src = codexSource.src;
  sourceRoot = "codex-rust-v${codexSource.version}/codex-rs";

  cargoDeps = rustPlatform.importCargoLock {
    allowBuiltinFetchGit = true;
    lockFile = builtins.fetchurl {
      url = lockFileSource.url;
      sha256 = lockFileSource.outputHash;
    };
  };

  buildInputs = (old.buildInputs or []) ++ lib.optionals stdenv.isLinux [ libcap ];

  postFixup = (old.postFixup or "") + ''
    wrapProgram $out/bin/codex --set DISABLE_AUTOUPDATER 1
  '';
})
