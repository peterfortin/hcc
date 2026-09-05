module Lexer (runLex) where

import qualified Data.Text as T ( Text )


runLex :: T.Text -> T.Text
runLex x = x 