module Macro.Fields.Macro where

import           Types

import           Macro.MetaMacro
import           Macro.Tuple

-- Field Set
fieset :: Note
fieset = "F"

-- Field Addition
fieadd :: Note
fieadd = comm0 "star"

(+@) :: Note -> Note -> Note
(+@) = binop fieadd

-- Field Multiplication
fiemul :: Note
fiemul = comm0 "cdot"

(*@) :: Note -> Note -> Note
(*@) = binop fiemul

-- Field
fie :: Note
fie = fie_ fieset fieadd fiemul

fie_ :: Note -- Set
     -> Note -- Addition
     -> Note -- Multiplication
     -> Note
fie_ = triple

-- BinaryField
binfie_ :: Note
binfie_ = mathbb "F" !: 2
