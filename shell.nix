{ env ? "dev" }:

let
  nixpkgs =
    import ./nixpkgs.nix {};

  pkgs =
    import nixpkgs { config = {}; };

in

with pkgs;

mkShell {
  MIX_ENV = env;
  LOCALE_ARCHIVE_2_27 = "${glibcLocales}/lib/locale/locale-archive";
  LOCALE_ARCHIVE_2_11 = "${glibcLocales}/lib/locale/locale-archive";
  LANG = "en_US.UTF-8";

  buildInputs = [
    elixir
    nixops
    gnumake
    semver-tool
    glibcLocales
    beamPackages.hex
  ];
}

