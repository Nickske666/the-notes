module Macro.Numbers.Macro where

import           Functions.Application.Macro
import           Macro.MetaMacro
import           Macro.Sets.Macro

import           Types

natural :: Note -> Note
natural n = n ∈ naturals

integer :: Note -> Note
integer n = n ∈ integers

intmod :: Note -> Note
intmod n = integers !: ("mod " <> n)

int0mod :: Note -> Note
int0mod n = integers !: (0 <> " mod " <> n)

realsp :: Note
realsp = reals ^: "+"

realsn :: Note
realsn = reals ^: "n"

-- Complex conjugate
conj :: Note -> Note
conj = overline

-- Operations un numbers
addition :: Note
addition = "+"

multiplication :: Note
multiplication = comm0 "cdot"


-- | Euler's totient function
etot :: Note -> Note
etot = fn phi

