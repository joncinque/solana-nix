{ stdenv, darwin, fetchFromGitHub, lib, pkg-config, protobuf
, makeRustPlatform, makeWrapper, solana-platform-tools, rust-bin, udev }:
let
  # nixpkgs 24.11 defaults to Rust v1.82.0
  # Anchor does not declare a rust-toolchain, so we do it here -- the code
  # mentions Rust 1.85.0 at https://github.com/coral-xyz/anchor/blob/c509618412e004415c7b090e469a9e4d5177f642/docs/content/docs/installation.mdx?plain=1#L31
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.stable."1.86.0".default;
    rustc = rust-bin.stable."1.86.0".default;
  };
in rustPlatform.buildRustPackage rec {
  pname = "anchor-cli";
  version = "0.31.1";

  doCheck = false;

  nativeBuildInputs = [ protobuf pkg-config makeWrapper ];
  buildInputs = [ ] ++ lib.optionals stdenv.isLinux [ udev ]
    ++ lib.optional stdenv.isDarwin
    [ darwin.apple_sdk.frameworks.CoreFoundation ];

  src = fetchFromGitHub {
    owner = "coral-xyz";
    repo = "anchor";
    rev = "v${version}";
    hash = "sha256-c+UybdZCFL40TNvxn0PHR1ch7VPhhJFDSIScetRpS3o=";
  };

  cargoLock = {
    lockFile = "${src.outPath}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  patches = [ ./anchor-cli.patch ];

  buildAndTestSubdir = "cli";

  # Ensure anchor has access to Solana's cargo and rust binaries
  postInstall = ''
    rust=${solana-platform-tools}/bin/platform-tools-sdk/sbf/dependencies/platform-tools/rust/bin
    wrapProgram $out/bin/anchor \
      --prefix PATH : "$rust"
  '';

  meta = { description = "Anchor cli"; };
}
