# AGENTS.md

Guidelines for AI coding agents working in this repository.

## Comments

- Comments must be written in English.
- Comments must explain what the code is or does, never describe the history
  of a change (no "changed X to Y", no "moved from ...").
- Keep comments concise; prefer clean, self-explanatory code over commentary.

## Commit Messages

- Commit messages must be concise and written in English.

## Verifying NixOS Information

- Confirm NixOS, nixpkgs and home-manager details against current
  documentation before acting on them.
- Use the `nixos` MCP server (mcp-nixos) for up-to-date package, option,
  and version lookups instead of relying on training data; fall back to
  official documentation when the server is unavailable.
