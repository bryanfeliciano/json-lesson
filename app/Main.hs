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

data NOAAResult = NOAAResult
                  { uid :: T.Text
                  , mindate :: T.Text
                  , maxdate :: T.Text
                  , name :: T.Text
                  , datacoverage :: Int
                  , resultId :: T.Text
                  } deriving Show

instance FromJSON NOAAResult where
    parseJSON (Object v) =
       NOAAResult <$> v .: "uid"
                  <*> v .: "mindate"
                  <*> v .: "maxdate"
                  <*> v .: "name"
                  <*> v .: "datacoverage"
                  <*> v .: "id"

data Resultset = Resultset
                  { offset :: Int
                  , count :: Int
                  , limit :: Int
                   } deriving (Show,Generic)
                  
instance FromJSON Resultset


data ErrorMessage = ErrorMessage
                  { message :: T.Text
                  , errorCode :: Int
                  } deriving Show


data Metadata = Metadata
                  {
                  resultset :: Resultset
                  } deriving (Show,Generic)

instance FromJSON Metadata

data NOAAResponse = NOAAResponse
                    { metadata :: Metadata
                    , results :: [NOAAResult]
                    } deriving (Show,Generic)

instance FromJSON NOAAResponse


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

sampleErrorMessage :: Maybe ErrorMessage
sampleErrorMessage = decode sampleError

instance ToJSON ErrorMessage where
  toJSON (ErrorMessage message errorCode) =
   object [ "message" .= message
          , "error" .= errorCode
          ]

anErrorMessage :: ErrorMessage
anErrorMessage = ErrorMessage "Everything is Okay" 0

main :: IO ()
main = print "hi"
