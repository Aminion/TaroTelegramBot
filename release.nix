let
  pkgs = import <nixpkgs> { inherit config; };

  config = {
    packageOverrides = pkgs: rec {    
      haskellPackages = pkgs.haskellPackages.override { overrides = haskOverrides; };
    };
  };

  haskOverrides = new: old: rec {
    TaroTelegramBot = new.callPackage ./. {};
    telegram-api = new.callPackage ./derivations/telegram-api.nix {};
  };

in{
  inherit pkgs;
  packages = { inherit (pkgs.haskellPackages) TaroTelegramBot;};
}
  