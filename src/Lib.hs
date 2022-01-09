{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}

module Lib where

import qualified Control.Foldl as F
import Control.Monad
import qualified Turtle as Tu

getPromptS :: Tu.Text
getPromptS = "please select window"

getWid :: forall (m :: * -> *). Tu.MonadIO m => m Tu.Text
getWid = do
    selected <- Tu.fold (Tu.inshell "xdotool selectwindow" Tu.empty) F.list
    let wid = Tu.lineToText $ head selected
    return wid

runScroll wid i =
    forM_
        [0 .. i]
        ( \i -> do
            Tu.shell ("xdotool windowactivate " <> wid <> " click 5 click 5 click 5") Tu.empty
            Tu.sleep 1
        )
