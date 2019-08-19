PACKAGE=${1:-TaroTelegramBot}
ghcid -c "cabal new-repl --ghc-options='-Werror -Wall' $PACKAGE "