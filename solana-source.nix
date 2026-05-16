{ stdenv, fetchFromGitHub }:
let
  version = "4.0.0";
  sha256 = "sha256-abjf4asGB6SEMRi6lqHOPFMqde/jitlNT9jh2kiwEgQ=";
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
