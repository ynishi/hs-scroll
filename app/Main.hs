{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Control.Foldl as F
import Control.Monad
import Lib
import qualified Turtle as Tu

main :: IO ()
main = do
    print getPromptS
    orig <- getActiveWid
    wid <- getWid
    runScroll wid
    activate orig
    print "complete"
