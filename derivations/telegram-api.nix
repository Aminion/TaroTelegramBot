{ mkDerivation, aeson, ansi-wl-pprint, base, bytestring, containers
, fetchgit, filepath, hjpath, hspec, http-api-data, http-client
, http-client-tls, http-media, http-types, mime-types, mtl
, optparse-applicative, random, servant, servant-client
, servant-client-core, stdenv, string-conversions, text
, transformers, utf8-string
}:
mkDerivation {
  pname = "telegram-api";
  version = "0.7.1.0";
  src = fetchgit {
    url = "https://github.com/Aminion/haskell-telegram-api";
    sha256 = "0nhdrfpmyl801pi8ck3p3kivlkcpjxjjr3frfr2rafai1z12q7a0";
    rev = "111b22a87f4669a4c31d8f67dddf28393b86b7be";
    fetchSubmodules = true;
  };
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson base bytestring containers http-api-data http-client
    http-media http-types mime-types mtl servant servant-client
    servant-client-core string-conversions text transformers
  ];
  testHaskellDepends = [
    aeson ansi-wl-pprint base filepath hjpath hspec http-client
    http-client-tls http-types optparse-applicative random servant
    servant-client servant-client-core text transformers utf8-string
  ];
  homepage = "http://github.com/klappvisor/haskell-telegram-api#readme";
  description = "Telegram Bot API bindings";
  license = stdenv.lib.licenses.bsd3;
}
