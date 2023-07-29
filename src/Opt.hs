{-# LANGUAGE OverloadedStrings #-}

module Opt where

import Data.Text as T
import Options.Applicative

data Opt = Opt
    { printScreenKey :: T.Text
    , workDir :: T.Text
    }
    deriving (Read, Show)

optParser =
    Opt
        <$> option
            auto
            ( long "print-screen-key"
                <> short 'p'
                <> metavar "PRINT_SCREEN_KEY(Key+Key+...)"
                <> value "Alt+Print"
                <> help "print screen window without interaction key"
            )
        <*> option
            auto
            ( long "work-dir"
                <> short 'w'
                <> metavar "WORK_DIR(/tmp/scroll)"
                <> value "/tmp/scroll"
                <> help "work dir"
            )

withInfo p = info (p <**> helper) . progDesc

optParserInfo = optParser `withInfo` "incremental scroll tool"

getOpt = execParser optParserInfo
