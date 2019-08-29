module Bot where
import Network.HTTP.Client      (newManager)
import Network.HTTP.Client.TLS  (tlsManagerSettings)
import Web.Telegram.API.Bot
import Control.Monad
import Control.Monad.IO.Class
import Data.Text (Text, pack)
import Data.Maybe
import System.Random
--import Control.Concurrent.Async.Lifted.Safe
--import Control.Monad.Reader
--import Control.Concurrent.STM
--import Servant.Client.Core.Internal.Request(ServantError)
import Data.IORef

readTokenString :: IO String 
readTokenString = readFile "token.cfg"

stickersPackName :: Text
stickersPackName = pack "TarotDeck66664545454"

getToken :: IO Token
getToken = Token . pack <$> readFile "token.cfg"

updateRequest :: Maybe Int -> GetUpdatesRequest
updateRequest lastProcessed = GetUpdatesRequest { updates_offset          = lastProcessed 
                                                , updates_limit           = Nothing
                                                , updates_timeout         = Just 6
                                                , updates_allowed_updates = Just [ pack "message"] 
                                                }

taroStickerAnswer :: ChatId -> Text -> SendStickerRequest Text
taroStickerAnswer chatId stickerId = SendStickerRequest { sticker_chat_id              = chatId
                                                        , sticker_sticker              = stickerId
                                                        , sticker_disable_notification = Nothing
                                                        , sticker_reply_to_message_id  = Nothing
                                                        , sticker_reply_markup         = Nothing
                                                        }

taroRequests :: UpdatesResponse -> [ChatId]            
taroRequests = mapMaybe (pure . ChatId . fromIntegral . user_id <=< from <=< message) . result

stickerPackIds :: Response StickerSet -> [Text]            
stickerPackIds = map sticker_file_id . stcr_set_stickers . result
    

getStickersPackRandomM :: RandomGen g => g -> Int -> [Int]
getStickersPackRandomM gen packLenght = randomRs (0, packLenght) gen

taroAnswers :: RandomGen g => g -> UpdatesResponse -> Response StickerSet -> [SendStickerRequest Text]
taroAnswers gen updateResponse stickerPackResponse = let
    packIds = stickerPackIds stickerPackResponse
    rnd = getStickersPackRandomM gen (length packIds) 
    taroR = taroRequests updateResponse
    res req ran = taroStickerAnswer req $ packIds !! ran
    in zipWith res taroR rnd

getLastProcessed :: [Update] -> Maybe Int   
getLastProcessed updates  = if null updates then Nothing  else succ <$> (Just $ maximum $ map update_id updates)



mainLoop :: IO ()
mainLoop = do
    putStrLn "start"
    token <- getToken
    manager <- newManager tlsManagerSettings
    lastProcessedRef <- newIORef Nothing
    _ <- runTelegramClient token manager $ forever $ do        
        gen <- liftIO newStdGen
        stickerPackResponse <- getStickerSetM stickersPackName
        lastProcessed <- liftIO $ readIORef lastProcessedRef
        updateResponse <- getUpdatesM $ updateRequest lastProcessed
        liftIO $ writeIORef lastProcessedRef $ getLastProcessed $ result $ updateResponse
        sequence $ sendStickerM <$> taroAnswers gen updateResponse stickerPackResponse    
    putStrLn ""