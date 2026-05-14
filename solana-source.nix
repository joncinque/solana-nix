{ stdenv, fetchFromGitHub }:
let
  version = "3.1.8";
  sha256 = "sha256-4jXgFRSzWKBLZYYr3VZ6LTxlqzD7QUtNHZZpLO85do4=";
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
