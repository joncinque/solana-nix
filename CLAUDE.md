# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Nix Flakes-based development environment for Solana blockchain development. It packages the Agave client (formerly Solana Labs) and Anchor framework for reproducible builds across multiple systems.

## Common Commands

```bash
# Enter development shell with all tools (solana-cli, anchor-cli, solana-rust, yarn, nodejs)
nix develop

# Show available packages and shells
nix flake show

# Build specific packages
nix build .#solana-cli
nix build .#anchor-cli
nix build .#solana-platform-tools

# Update flake inputs
nix flake update

# Check flake validity
nix flake check
```

## Architecture

### Package Dependency Graph

```
flake.nix (entry point, uses flake-parts)
├── solana-source.nix      → Fetches Agave source from anza-xyz/agave
├── solana-platform-tools.nix → Pre-built SBF/BPF compiler toolchain (LLVM + Rust)
├── solana-cli.nix         → Builds 20+ CLI binaries from Agave source
│   └── depends on: solana-source, solana-platform-tools
├── solana-rust.nix        → Wrapper exposing platform-tools Rust
│   └── depends on: solana-platform-tools
└── anchor-cli.nix         → Builds Anchor CLI from coral-xyz/anchor
    └── depends on: solana-platform-tools
```

### Multi-System Support

The flake targets: x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin, x86_64-windows

Platform-specific handling:
- Linux: Uses `autoPatchelfHook` for binary compatibility
- Darwin: Requires apple_sdk_11_0 frameworks (IOKit, Security, AppKit, System)
- Platform tools are downloaded as pre-built binaries per system

### Version Pinning

Current versions:
- Agave (Solana): 2.1.21 (in `solana-source.nix`)
- Platform Tools: v1.45 (in `solana-platform-tools.nix`)
- Anchor CLI: 0.31.1 (in `anchor-cli.nix`)
- Rust for Solana CLI: 1.84.1
- Rust for Anchor CLI: 1.86.0

### Key Implementation Details

**Tests are disabled** (`doCheck = false`) on both solana-cli and anchor-cli because tests require network/RPC access which violates the Nix sandbox.

**anchor-cli.patch** modifies Anchor to:
- Add `--skip-tools-install` and `--no-rustup-override` flags to cargo-build-sbf calls
- Remove automatic toolchain installation (respects Nix-provided Rust)

**cargo-build-sbf wrapping**: The binary is wrapped with `SBF_SDK_PATH` pointing to platform-tools and PATH prefixed with the platform-tools Rust binaries.

## Updating Versions

To update Solana/Agave version:
1. Update `version` and `sha256` in `solana-source.nix`
2. Update `cargoHash` in `solana-cli.nix` (build will fail with correct hash)
3. May need to update platform-tools version in `solana-platform-tools.nix`
4. Update Rust version in `solana-cli.nix` if Agave requires it

To update Anchor version:
1. Update `version` and `hash` in `anchor-cli.nix`
2. Update `anchor-cli.patch` if build breaks
3. Update Rust version if Anchor requires it
