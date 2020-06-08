{ pkgs ? import ../nixpkgs.nix {} }:

with pkgs;

stdenv.mkDerivation rec {
  pname = "blog-core";

  version = builtins.readFile ./VERSION;

  src = fetchFromGitHub {
    url = "https://github.com/BreadBlog/core/archive/core-${version}.tar.gz";
    sha256 = builtins.readFile ./SHA;
  };

  LOCALE_ARCHIVE_2_27 = "${glibcLocales}/lib/locale/locale-archive";
  LOCALE_ARCHIVE_2_11 = "${glibcLocales}/lib/locale/locale-archive";
  LANG = "en_US.UTF-8";

  buildInputs = [
    glibcLocales
    elixir
    beamPackages.hex
  ];

  configurePhase = ''
  '';

  buildPhase = ''
  '';

  installPhase = ''
    ls
    mkdir -p $out/temp
    mv ./* $out
  '';
}
