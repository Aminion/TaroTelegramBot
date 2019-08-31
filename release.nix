let
  pkgs = import ./pkgs.nix { inherit config; };

  config = {
    packageOverrides = pkgs: rec {    
      haskellPackages = pkgs.haskellPackages.override { overrides = haskOverrides; };
    };
  };

  haskOverrides = new: old: rec {
    TaroTelegramBot = new.callCabal2nix "TaroTelegramBot" ./. {};
    telegram-api = new.callPackage ./derivations/telegram-api.nix {};
  };

in{
  inherit pkgs;
  packages = { inherit (pkgs.haskellPackages) TaroTelegramBot;};
}
  