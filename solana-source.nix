{ stdenv, fetchFromGitHub }:
let
  version = "2.1.21";
  sha256 = "sha256-cFpyeIyZuexjmjx5QryxPYHjRWVmORjvC3KKheoNPJw=";
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

