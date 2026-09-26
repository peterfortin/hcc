module AsmGenner (runGenerate) where

import qualified Data.Text as T ( Text, pack )


runGenerate :: T.Text -> T.Text
runGenerate _ = T.pack "    .global main\nmain:\n    movl    $2, %eax\n    ret\n" 