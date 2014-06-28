module Main where

import Web.Scotty
import Database.PostgreSQL.Simple (connectPostgreSQL)

import Oinc.API.Server

main = do
  conn <- connectPostgreSQL "dbname='oinc_haskell_dev' user='postgres'"
  runServer 3000 conn