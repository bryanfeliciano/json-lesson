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

rawJSON :: BC.ByteString
rawJSON = "{\"author\":\"Emil Ciroan\",\"title\":\"A Short History of Decay\",\"year=1949}"

bookFromJSON :: Maybe Book
bookFromJSON = decode rawJSON

wrongJSON :: BC.ByteString
wrongJSON = "{\"writer\":\"Emil Cioran\",\"title\":\"A Short History of Decay\",\"year\"=1949}"

bookFromWrongJSON :: Maybe Book
bookFromWrongJSON = decode wrongJSON

sampleError :: BC.ByteString
sampleError = "{\"message\":\"oops!\",\"error\": 123}"

-- This works but you might want to write something that lines up better with json data
-- data ErrorMessage = ErrorMessage
--                     { message :: T.Text
--                     , error :: Int
--                     } deriving Show

data ErrorMessage = ErrorMessage
                    { message :: T.Text
                    , errorCode :: Int
                    } deriving Show

-- Unfortunately, if you try to automatically derive ToJSON and FromJSON, your programs will
-- expect an errorCode field instead of error. If you were in control of this JSON, you could
-- rename the field, but you’re not. You need another solution to this problem.
-- To make your ErrorMessage type an instance of FromJSON, you need to define one function:
-- parseJSON. You can do this in the following way.

instance FromJSON ErrorMessage where
   parseJSON (Object v) =
   ErrorMessage <$> v .: "message"
                <*> v .: "error"

exampleMessage :: Maybe T.Text
exampleMessage = Just "Opps"

exampleError :: Maybe Int
exampleError = Just 123

main :: IO ()
main = print "hi"
