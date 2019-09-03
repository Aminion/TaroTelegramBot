module Requests where

import Data.Text (Text, pack)
import Web.Telegram.API.Bot

updateRequest :: Maybe Int -> GetUpdatesRequest
updateRequest lastProcessed = GetUpdatesRequest { updates_offset          = lastProcessed 
                                                , updates_limit           = Nothing
                                                , updates_timeout         = Just 6
                                                , updates_allowed_updates = Just [pack "message"] 
                                                }

taroStickerAnswer :: ChatId -> Text -> SendStickerRequest Text
taroStickerAnswer chatId sticker_Id = SendStickerRequest { sticker_chat_id              = chatId
                                                         , sticker_sticker              = sticker_Id
                                                         , sticker_disable_notification = Nothing
                                                         , sticker_reply_to_message_id  = Nothing
                                                         , sticker_reply_markup         = Nothing
                                                         }

taroMessageAnswer :: ChatId -> Text -> SendMessageRequest
taroMessageAnswer chatId msg = SendMessageRequest { message_chat_id = chatId
                                                  , message_text        = msg
                                                  , message_parse_mode = Just HTML
                                                  , message_disable_web_page_preview = Just True
                                                  , message_disable_notification = Nothing
                                                  , message_reply_to_message_id = Nothing
                                                  , message_reply_markup = Nothing
                                                  }