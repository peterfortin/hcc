module Main (main) where

import qualified System.Environment as Env 
import qualified System.Process as Proc
import qualified Data.Text.IO as TextIO

import Lexer ( runLex )
import Parser ( runParse )
import AssemblyGenerator ( runGenerate )





-- Argument parsing
data CommandArgs a
    = FilePathArg a
    | LexArg a
    | ParseArg a
    | CodeGenArg a
    | EmptyArg

parseArgs :: [String] -> CommandArgs FilePath
parseArgs (filePath : [])             = FilePathArg filePath
parseArgs (filePath : "-lex" : _)     = LexArg filePath
parseArgs (filePath : "-parse" : _)   = ParseArg filePath
parseArgs (filePath : "-codegen" : _) = CodeGenArg filePath
parseArgs _                           = EmptyArg





main :: IO ()
main = do 

    -- Get the command line arguments and pattern match
    args <- Env.getArgs
    case parseArgs args of 

        -- Complete the compilation process
        FilePathArg filePath -> do 

            Proc.callProcess "gcc" ["-E", "-P", filePath, "-o", "preprocessed.i"]
            preProc <- TextIO.readFile "preprocessed.i"
            TextIO.writeFile "assembly.s" $ runGenerate . runParse . runLex $ preProc 

        -- Stop after lex pass
        LexArg filePath -> do 

            Proc.callProcess "gcc" ["-E", "-P", filePath, "-o", "preprocessed.i"]
            preProc <- TextIO.readFile "preprocessed.i"
            TextIO.writeFile "a.s" $ runLex $ preProc

        -- Stop after parse pass
        ParseArg filePath -> do 

            Proc.callProcess "gcc" ["-E", "-P", filePath, "-o", "preprocessed.i"]
            preProc <- TextIO.readFile "preprocessed.i"
            TextIO.writeFile "a.s" $ runParse . runLex $ preProc 

        -- stop after code generation pass
        CodeGenArg filePath -> do 

            Proc.callProcess "gcc" ["-E", "-P", filePath, "-o", "preprocessed.i"]
            preProc <- TextIO.readFile "preprocessed.i"
            TextIO.writeFile "a.s" $ runGenerate . runParse . runLex $ preProc 

        -- No input or incorrect option flags
        EmptyArg -> putStrLn "No input file was given or incorrect options were passed."