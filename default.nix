{ mkDerivation, base, http-client, http-client-tls, stdenv
, telegram-api
}:
mkDerivation {
  pname = "TaroTelegramBot";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base http-client http-client-tls telegram-api
  ];
  executableHaskellDepends = [
    base http-client http-client-tls telegram-api
  ];
  doHaddock = false;
  license = stdenv.lib.licenses.mit;
}
