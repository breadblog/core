{
  env ? "dev",
  includeElixir ? true,
  includeDeploy ? true
}:

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

  buildInputs = builtins.concatLists [
    [
      gnumake
      semver-tool
      glibcLocales
    ]
    (if includeElixir then [
      elixir
      beamPackages.hex
    ] else [])
    (if includeDeploy then [
      nixops
    ] else [])
  ];
}

