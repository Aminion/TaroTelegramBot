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
    sha256 = "01m36dwdhsd4js4s42i9l1y9rlnvk4yj72y24rnjmjxf39qq981m";
    rev = "b6c044ed32492f063dfc1925f0e2dfb34fde0ebf";
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
