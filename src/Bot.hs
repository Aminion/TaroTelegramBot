module Bot where
import Web.Telegram.API.Bot
import Control.Monad
import Control.Monad.IO.Class
import Data.Text (Text, pack)
import Data.Maybe
import System.Random
import Control.Monad.Reader
import Data.IORef
import Data.List.Split
import Env
import Requests

tarotRequests :: UpdatesResponse -> [ChatId]            
tarotRequests = mapMaybe (pure . ChatId . fromIntegral . user_id <=< from <=< message) . result
    
data TarotChoice = Upright Int | Reversed Int   

deckRandomM :: RandomGen g => g -> Int -> [TarotChoice]
deckRandomM gen deckLenght = choice <$> (splittedRandoms $ randomRs (0, pred deckLenght) gen)
            where choice [cardFlip, indexInDeck] = (if even cardFlip then Upright else Reversed) indexInDeck
                  splittedRandoms = chunksOf 2

type Divination = (SendStickerRequest Text , SendMessageRequest)

divination :: (TarotCardInfoModel -> String) -> ChatId -> TarotCardInfoModel -> Divination
divination textSelector chatId cardDescription =
    ( taroStickerAnswer chatId (stickerId cardDescription)
    , taroMessageAnswer chatId msgText
    )
    where
        msgText = pack $ desc ++ "\n<a href='" ++ fullDescLink ++ "'>Full description</a>"
        desc = textSelector cardDescription
        fullDescLink = fullDescription cardDescription

divinations :: RandomGen g => g -> UpdatesResponse -> [TarotCardInfoModel] -> [Divination]
divinations gen updateResponse deck = let
    deckRandom = deckRandomM gen (length deck) 
    taroReq = tarotRequests updateResponse
    res req ran = 
        case ran of Upright  idx -> divination upright  req $ deck !! idx
                    Reversed idx -> divination reversed req $ deck !! idx
    in zipWith res taroReq deckRandom

getUpdateOffset :: [Update] -> Maybe Int   
getUpdateOffset updates = 
    case updates of
    [] -> Nothing
    xs -> Just $ succ $ maximum $ map update_id xs



sendDivination :: Divination -> TelegramClient ()
sendDivination (stickerRequest, messageRequest) = void $ sendStickerM stickerRequest >> sendMessageM messageRequest 

mainLoop :: ReaderT Env IO ()
mainLoop = do
    env <- ask
    _ <- liftIO $ runTelegramClient (token env) (manager env) $ forever $ do
            currentUpdateOffset <- liftIO $ readIORef $ updateOffset env
            updateResponse <- getUpdatesM $ updateRequest currentUpdateOffset
            let newUpdateOffset = getUpdateOffset $ result $ updateResponse
            liftIO $ writeIORef (updateOffset env) newUpdateOffset
            generator <- liftIO newStdGen
            let divinationsResult = divinations (generator) updateResponse (deckDescription env)
            sequence_ $ sendDivination <$> divinationsResult 
    pure ()                                       

initBot :: IO ()
initBot = do
    putStrLn "start"
    env <- getEnv
    r <- runReaderT mainLoop env
    putStrLn $ show r