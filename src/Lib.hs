{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}

module Lib where

import qualified Control.Foldl as F
import Control.Monad
import Control.Monad.Cont
import qualified Data.List as L
import qualified Data.Text as T
import qualified Turtle as Tu

getPromptS :: Tu.Text
getPromptS = "please select window"

getActiveWid ::
    forall (m :: * -> *).
    Tu.MonadIO m =>
    m Tu.Text
getActiveWid = getWidInner "getActivewindow"

getWid ::
    forall (m :: * -> *).
    Tu.MonadIO m =>
    m Tu.Text
getWid = getWidInner "selectwindow"

getWidInner cmd = do
    selected <- Tu.fold (Tu.inshell ("xdotool " <> cmd) Tu.empty) F.list
    let wid = Tu.lineToText $ head selected
    return wid

runScroll wid printScreenKey workDir = do
    initWorkDir
    focus wid ["key", "Home"]
    Tu.sleep 1
    prefile <- prscn "pre"
    withBreak $ \break ->
        forM_
            [0 ..]
            ( \i -> do
                focus wid . T.words . T.unwords . replicate 5 $ "click 5"
                Tu.sleep 1
                currentfile <- prscn "current"
                isExist <- checkFile currentfile
                unless isExist $ break ()
                e <-
                    Tu.proc
                        "compare"
                        ["-metric", "AE", "-fuzz", "10%", prefile, currentfile, "-compose"]
                        Tu.empty
                Tu.proc "mv" [currentfile, prefile] Tu.empty
                when (e == Tu.ExitSuccess) $ break ()
            )
  where
    withBreak = flip runContT pure . callCC
    initWorkDir = do
        Tu.proc "rm" ["-rf", workDir] Tu.empty
        Tu.proc "mkdir" ["-p", workDir] Tu.empty
    prscn prefix = do
        let [dumpfile, outfile, retfile] =
                map
                    (\suffix -> workDir <> "/" <> prefix <> suffix)
                    [".png", "-out.png", "-out-2.png"]
        focus wid ["key", printScreenKey]
        Tu.sleep 1
        Tu.shell
            ("xclip -selection clipboard -t image/png -o > " <> dumpfile)
            Tu.empty
        Tu.proc "convert" ["-crop", "80%x50%", dumpfile, outfile] Tu.empty
        return retfile
    checkFile file = do
        exitCode <- Tu.proc "ls" [file] Tu.empty
        let isExist = exitCode == Tu.ExitSuccess
        unless isExist $ liftIO $ print $ "Not exist screenshot file: " <> file
        return isExist

activate :: MonadIO m => Tu.Text -> m Tu.ExitCode
activate wid = xdo ["windowactivate", wid]

focus wid cmds = do
    let pre =
            if wid == ""
                then []
                else ["windowfocus", "--sync"]
    let cmd' = pre ++ [wid] ++ cmds
    xdo cmd'

xdo args = do
    liftIO . print . show $ "xdotools" : args
    Tu.proc "xdotool" args Tu.empty
