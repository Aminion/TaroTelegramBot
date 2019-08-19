
module Bot where
import           Network.HTTP.Client      (newManager)
import           Network.HTTP.Client.TLS  (tlsManagerSettings)
import           Web.Telegram.API.Bot
import           Control.Concurrent
import           Control.Monad

token = "730943178:AAHB2p0mRiTsH4F-J8LcIGEooLIEsMogqH8"


waitDelay = 1_000_000


checkForUpdates :: IO ()
checkForUpdates = return ()

mainLoop :: IO ()
mainLoop = forever do
    checkForUpdates
    threadDelay waitDelay