# AGENTS.md

Guidelines for AI coding agents working in this repository.

## Repository Layout

- `hosts/<name>/` — per-machine entrypoints. `beryllium` is the graphical
  desktop machine; `helium-nixos-wsl` is the Windows WSL guest and must
  never receive desktop or GUI modules.
- `modules/nixos/` — system-level (NixOS) modules.
- `modules/home/` — user-level (home-manager) modules.
- `users/yifeng/` — user identity. It imports `modules/home/common`, so
  both hosts share the same terminal and development environment.
- `pkgs/<name>/` — repo-local packages for software missing from nixpkgs.

## Module Organization

- `common` trees (`modules/home/common/`, `modules/nixos/common.nix`)
  apply to every host. `desktop` trees (`modules/home/desktop/`,
  `modules/nixos/desktop/`) apply only to machines with a graphical
  session.
- One feature per file. Language toolchains live in
  `modules/home/common/dev/<toolchain>.nix` together with their package
  mirror settings; keep a toolchain and its mirror config in one place.
- Apps without module-level configuration stack into
  `modules/home/common/cli/stack.nix` (CLI) or
  `modules/home/desktop/gui-apps.nix` (GUI). When an app gains real
  settings, graduate it into its own file next to the stack file and add
  it to the folder's `default.nix`.
- Folder `default.nix` files only aggregate imports. Host and user files
  import folders, never individual module files.
- Small system services that need no tuning stack into
  `modules/nixos/desktop/default.nix`; split one out into its own file
  when it grows real configuration.
- When adding a new feature, place it by purpose first (common vs
  desktop, system vs home), then choose file vs stack per the rules
  above.

## NixOS Specifics

- The nix store is read-only: never rely on chown, setcap or setuid on
  store files at runtime. Materialize privileged copies into a writable
  directory through an activation script instead (see
  `modules/nixos/desktop/clash-party.nix`).
- Unfree packages are allowed globally (`nixpkgs.config.allowUnfree`);
  there is no need for per-package unfree predicates.
- home-manager runs with `useGlobalPkgs`; do not set `nixpkgs.*` options
  inside home-manager modules (deprecated by upstream and warned).
- Electron apps packaged from debs need `LD_LIBRARY_PATH` for
  dlopen-loaded libraries (EGL and friends) in their wrapper, and their
  bundled `chrome-sandbox` file removed so Chromium falls back to the
  namespace sandbox.
- When extending a `callPackage` function, never name new function
  arguments after nixpkgs attributes (e.g. `src`) — resolution collides
  with legacy aliases and throws confusing rename errors.
- Network access to foreign hosts is expected to work transparently
  through the machine's TUN proxy (Clash Party). Do not hardcode proxy
  environment variables into the configuration.

## Workflow

- Confirm NixOS, nixpkgs and home-manager details against current
  documentation before acting on them. Use the `nixos` MCP server
  (mcp-nixos) for package, option and version lookups instead of relying
  on training data; fall back to official documentation when the server
  is unavailable. Its index may lag the pinned channel, so also verify
  attribute names against the pinned nixpkgs source with `nix eval`.
- New files must be `git add`-ed before the flake can see them.
- Verify changes with `nix eval` (options, package lists) before asking
  for a rebuild; applying a switch requires the user's sudo password.
- Verify refactors by comparing evaluated results before and after
  (package lists, key option values) rather than eyeballing.
- Commit messages must be concise and written in English. Split
  unrelated changes into separate topical commits.
- Comments must be written in English and explain what the code is or
  does, never describe the history of a change (no "changed X to Y", no
  "moved from ..."). Keep comments concise; prefer clean,
  self-explanatory code over commentary.
