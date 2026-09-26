module Main (main) where

import qualified System.Environment as Env 
import qualified System.Process as Proc
import qualified System.Directory as Dir
import qualified Data.Text as Text
import qualified Data.Text.IO as TextIO

import Control.Monad.Except

import Lexer --( runLex )
import Parser ( runParse )
import AsmGenner ( runGenerate)





main :: IO ()
main = do 


    putStrLn $ "hello"



{-
    -- Get the command line arguments and pattern match
    args <- Env.getArgs
    case parseArgs args of 


        -- Complete the compilation process
        FilePathArg filePath -> do 

            Proc.callProcess "gcc" ["-E", "-P", filePath, "-o", "preprocessed.i"]
            preProc <- TextIO.readFile "preprocessed.i"
            Dir.removeFile "preprocessed.i" 
            TextIO.writeFile "assembly.s" $ runGenerate . runParse . runLex $ preProc 
            Proc.callProcess "gcc" ["assembly.s", "-o", "out"]




        -- Stop after lex pass
        LexArg filePath -> do 

            Proc.callProcess "gcc" ["-E", "-P", filePath, "-o", "preprocessed.i"]
            preProc <- TextIO.readFile "preprocessed.i"
            Dir.removeFile "preprocessed.i" 
            _ <- return . runLex $ preProc
            putStrLn $ "I lexed!"




        -- Stop after parse pass
        ParseArg filePath -> do 

            Proc.callProcess "gcc" ["-E", "-P", filePath, "-o", "preprocessed.i"]
            preProc <- TextIO.readFile "preprocessed.i"
            Dir.removeFile "preprocessed.i" 
            _ <- return . runParse . runLex $ preProc
            putStrLn $ "I parsed!"




        -- stop after code generation pass
        CodeGenArg filePath -> do 

            Proc.callProcess "gcc" ["-E", "-P", filePath, "-o", "preprocessed.i"]
            preProc <- TextIO.readFile "preprocessed.i"
            Dir.removeFile "preprocessed.i" 
            _ <- return . runGenerate . runParse . runLex $ preProc
            putStrLn $ "I generated!" 




        -- No input or incorrect option flags
        EmptyArg -> putStrLn "No input file was found or incorrect options were passed."-}







-- Stage at which the compilation should stop
data Stage 
    = Lex 
    | Parse
    | CodeGen
    | Full
    deriving Eq

-- Argument structure
data Args a
    = Args Stage a
    | NoArgs


-- Parse command line argument for file name and optional flag
parseArgs :: [String] -> Args FilePath
parseArgs (filePath : "-lex" : _)     = Args Lex filePath
parseArgs (filePath : "-parse" : _)   = Args Parse filePath
parseArgs (filePath : "-codegen" : _) = Args CodeGen filePath
parseArgs (filePath : [])             = Args Full filePath
parseArgs _                           = NoArgs




-- Call gcc to preprocess the C file
preprocess :: FilePath -> IO Text.Text
preprocess filePath = do 
    Proc.callProcess "gcc" ["-E", "-P", filePath, "-o", "preprocessed.i"]
    contents <- TextIO.readFile "preprocessed.i"
    Dir.removeFile "preprocessed.i"
    pure contents