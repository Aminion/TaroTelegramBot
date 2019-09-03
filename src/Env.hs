module Env where

import Data.Maybe
import Data.IORef
import GHC.Generics (Generic)
import Data.Text (Text, pack)
import Data.Aeson
import qualified Data.ByteString.Lazy as B
import Network.HTTP.Client      (Manager, newManager)
import Network.HTTP.Client.TLS  (tlsManagerSettings)
import Web.Telegram.API.Bot


data TarotCardInfoModel = TarotCardInfoModel { stickerId       :: Text
                                             , upright         :: String
                                             , reversed        :: String
                                             , fullDescription :: String 
                                             } deriving (Show, Generic)

instance FromJSON TarotCardInfoModel

data Env = Env { updateOffset    :: IORef (Maybe Int)
               , token           :: Token
               , manager         :: Manager
               , deckDescription :: [TarotCardInfoModel]
               }

readTokenString :: IO String 
readTokenString = readFile "token.cfg"

stickersPackName :: Text
stickersPackName = pack "TarotDeck66664545454"

getToken :: IO Token
getToken = Token . pack <$> readFile "token.cfg"

getEnv :: IO Env
getEnv =  Env <$> newIORef Nothing
              <*> getToken
              <*> (newManager tlsManagerSettings)
              <*> ((fromJust <$> decode <$> B.readFile "desc.json") :: IO [TarotCardInfoModel])