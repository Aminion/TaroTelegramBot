let
  pkgs = import <nixpkgs> { };

  config = {
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override { overrides = haskOverrides; };
    };
  };

  haskOverrides = new: old: rec {
    telegram-api = new.callPackage ./derivations/telegram-api.nix {};
  };
in
  pkgs.haskellPackages.callPackage ./default.nix { }