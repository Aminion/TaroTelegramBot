{ mkDerivation, base, http-client, http-client-tls, lifted-async
, mtl, random, servant-client-core, stdenv, stm, telegram-api, text
}:
mkDerivation {
  pname = "TaroTelegramBot";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base http-client http-client-tls lifted-async mtl random
    servant-client-core stm telegram-api text
  ];
  executableHaskellDepends = [
    base http-client http-client-tls lifted-async mtl random
    servant-client-core stm telegram-api text
  ];
  license = stdenv.lib.licenses.mit;
}
