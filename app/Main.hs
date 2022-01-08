{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Control.Foldl as F
import Control.Monad
import qualified Turtle as Tu

main :: IO ()
main = do
    putStrLn "please select window"
    selected <- Tu.fold (Tu.inshell "xdotool selectwindow" Tu.empty) F.list
    let wid = Tu.lineToText $ head $ selected
    forM_
        [0 ..]
        ( \i -> do
            Tu.shell ("xdotool windowactivate " <> wid <> " click 5 click 5 click 5") Tu.empty
            Tu.sleep 1
        )
