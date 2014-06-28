module Oinc.API.Routes where

import Web.Scotty
import Database.PostgreSQL.Simple
import Control.Monad.IO.Class (liftIO)
import Control.Monad ((>=>))
import Data.Map (Map, fromList)
import Data.Int (Int64)
import Data.Aeson (decode)

import Network.HTTP.Types.Status (status500)

import Oinc.Types
import Oinc.API.Schemas

oincsForNewUser :: Int
oincsForNewUser = 100

successMessage :: Map String String
successMessage = fromList [("state", "success")]

errorMessage :: Map String String
errorMessage = fromList [("state", "error")]

-- Query for selecting all users
selectAllUsers :: Connection -> IO [AllUsersSchema]
selectAllUsers conn = query_ conn "select * from users"

-- Query for inserting a new user
insertNewUser :: Connection -> NewUserSchema -> IO Int64
insertNewUser conn user = execute conn "insert into users (name, oincs) values (?, ?)" (name, oincsForNewUser)
  where name = nusName user


getUsers :: Connection -> ActionM ()
getUsers = liftIO . selectAllUsers >=> json

addUser :: Connection -> ActionM ()
addUser conn = do
  -- Automatic decode into Maybe NewUserSchema
  maybeUser <- fmap decode body

  case maybeUser of
    Nothing -> status status500 >> json errorMessage
    Just user -> do
      liftIO $ insertNewUser conn user
      json successMessage
