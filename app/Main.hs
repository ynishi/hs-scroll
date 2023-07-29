{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Control.Foldl as F
import Control.Monad
import Lib
import qualified Turtle as Tu

import Opt

main :: IO ()
main = do
    print getPromptS
    opt <- getOpt
    orig <- getActiveWid
    wid <- getWid
    runScroll wid (printScreenKey opt) (workDir opt)
    activate orig
    print "complete"
