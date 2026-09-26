module Lexer (runLex) where

import Data.Void ( Void )
import Data.Char
import Data.Text ( Text )
import qualified Data.Text as T
import Text.Megaparsec
import Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L
import Control.Monad ( void )





-- Parser type for lexing 
type Lexer = Parsec Void Text


-- Parser error type from Megaparsec
type LexError = ParseErrorBundle Text Void


-- ADT for lexical tokens
data LexToken
    = TIdentifier Text
    | TConstant Integer
    | TIntKey
    | TVoidKey
    | TReturnKey
    | TOpenParen
    | TCloseParen
    | TOpenBrace
    | TCloseBrace
    | TSemiColon
    deriving (Show, Eq)





{- Main Combinators -}

runLex :: Text -> Either LexError [Text]
runLex x = Right $ pure x  


lex :: Lexer LexToken
lex = pure TCloseParen



{- Small Helper Combinators -}

-- Space consumer
sc :: Lexer () 
sc = L.space space1 lineCmnt blockCmnt
  where 
    lineCmnt  = L.skipLineComment "//"
    blockCmnt = L.skipBlockComment "/*" "*/"


-- Wrapper around lexeme helper and space consumer 
lexeme :: Lexer a -> Lexer a
lexeme = L.lexeme sc 


-- Wrapper around symbol helper and space consumer
symbol :: Text -> Lexer Text
symbol = L.symbol sc 