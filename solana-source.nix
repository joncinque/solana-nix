{ stdenv, fetchFromGitHub }:
let
  version = "3.0.14";
  sha256 = "sha256-JRHf7NEjdeYBb8D9wPlEPZe06TpFbS7q7oNymy5BobE=";
in
{
  inherit version;
  src = fetchFromGitHub {
    owner = "anza-xyz";
    repo = "agave";
    rev = "v${version}";
    fetchSubmodules = true;
    inherit sha256;
  };
}
