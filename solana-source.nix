{ stdenv, fetchFromGitHub }:
let
  version = "4.1.2";
  sha256 = "sha256-mc8AthTKjDNZ/PfATLhOEBsvrNkcifhEPsJwq5PRqas=";
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
