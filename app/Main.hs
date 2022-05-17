{-# LANGUAGE OverloadedStrings #-}
module Main where


import Data.Aeson
import Data.Text as T
import Data.ByteString.Lazy as B 
import Data.ByteString.Lazy.Char8 as BC
import GHC.Generics

import Lib

-- testing encode to json -- 

data Book = Book
            {
                tittle :: T.Text,
                author :: T.Text,
                year :: Int
            } deriving (Show,Generic)

instance FromJSON Book
instance ToJSON Book


myBook :: Book 
myBook = Book
         {
             author = "Will Kurt",
             tittle = "Learn Haskell",
             year = 2017
         }

myBookJSON :: BC.ByteString
myBookJSON = encode myBook         

main :: IO ()
main = print "hi"
