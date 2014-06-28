{-# LANGUAGE TemplateHaskell #-}

module Oinc.API.Schemas where


import Control.Applicative ((<$>), (<*>))
import Data.Char (toLower)
import Data.Aeson.TH

import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow

data AllUsersSchema = AllUsersSchema {
    ausId :: Int,
    ausName :: String,
    ausOincs :: Int
  } deriving (Eq)

data NewUserSchema = NewUserSchema {
    nusName :: String
  }

$(deriveJSON defaultOptions{fieldLabelModifier = drop 3 . map toLower } ''AllUsersSchema)
$(deriveJSON defaultOptions{fieldLabelModifier = drop 3 . map toLower } ''NewUserSchema)

instance FromRow AllUsersSchema where
  fromRow = AllUsersSchema <$> field <*> field <*> field
