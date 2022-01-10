{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

import qualified Control.Foldl as F
import Control.Monad
import Data.GI.Base
import qualified Data.Text as T
import qualified GI.Gtk as Gtk
import Lib
import qualified Turtle as Tu

main :: IO ()
main = do
    Gtk.init Nothing

    win <- new Gtk.Window [#title := "Hi there"]

    on win #destroy Gtk.mainQuit

    button <- new Gtk.Button [#label := "Click me"]
    eb <- new Gtk.EntryBuffer [#text := ""]

    x <-
        on
            button
            #clicked
            $ do
                t <- eb `get` #text
                wid' <-
                    if t == ""
                        then do
                            set button [#sensitive := False, #label := getPromptS]
                            wid <- getWid
                            set eb [#text := wid]
                            return wid
                        else return t

                runScroll wid' 30

                set button [#sensitive := True, #label := "Click me"]
    #add win button

    #showAll win

    Gtk.main
