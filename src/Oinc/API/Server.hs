module Oinc.API.Server where

import Web.Scotty (ActionM)
import Web.Scotty (scotty, json, get, post)
import Data.Aeson (ToJSON)

import Oinc.Types
import qualified Oinc.API.Routes as R

runServer port conn = scotty port $ do
  get   "/users" $ R.getUsers conn
  post  "/users" $ R.addUser conn