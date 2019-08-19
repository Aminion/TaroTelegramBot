let
  pkgs = import <nixpkgs> { inherit config; };

  config = {
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override { overrides = haskOverrides; };
    };
  };

  haskOverrides = new: old: rec {
    telegram-api = new.callPackage ./derivations/telegram-api.nix {};
  };

in{
  inherit pkgs;
  packages = { inherit (pkgs.haskellPackages); };
}
  