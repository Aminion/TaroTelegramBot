import (builtins.fetchGit {
  # Descriptive name to make the store path easier to identify
  name = "NixOS";
  url = https://github.com/nixos/nixpkgs/;
  rev = "8d1510abfb592339e13ce8f6db6f29c1f8b72924";
})