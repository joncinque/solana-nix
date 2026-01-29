{ stdenv, fetchFromGitHub }:
let
  version = "2.3.13";
  sha256 = "sha256-RSucqvbshaaby4fALhAQJtZztwsRdA+X7yRnoBxQvsg=";
in {
  inherit version;
  src = fetchFromGitHub {
    owner = "anza-xyz";
    repo = "agave";
    rev = "v${version}";
    fetchSubmodules = true;
    inherit sha256;
  };
}
