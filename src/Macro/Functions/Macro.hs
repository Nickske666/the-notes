module Macro.Functions.Macro (
    module Macro.Functions.Macro

  , module Macro.Functions.Inverse
  , module Functions.Application.Macro
  ) where

import           Types

import           Macro.Math

import           Macro.Sets.CarthesianProduct

import           Functions.Application.Macro
import           Macro.Functions.Inverse
import qualified Relations.Domain.Macro       as R (dom, img)

import           Macro.MetaMacro


-- Functions
fun :: Note -> Note -> Note -> Note
fun m n o = m <> negspace <> ":" <> raw "\\, " <> n <> rightarrow <> o
  where
    negspace :: Note
    negspace = commS "kern" <> raw "-2pt"

func :: Note -> Note -> Note -> Note -> Note -> Note
func m n o p q = fun m n o <> ":" <> raw "\\ " <> p <> comm0 "mapsto" <> q

func2 :: Note -> Note -> Note -> Note -> Note -> Note -> Note -> Note
func2 m n1 n2 o p1 p2 = func m (n1 ⨯ n2) o (tuple p1 p2)

-- Function
fundom_ :: Note
fundom_ = "A"

fundom :: Note -> Note
fundom = R.dom

funimg_ :: Note
funimg_ = "B"

funimg :: Note -> Note
funimg = R.img

funrel_ :: Note
funrel_ = "f"

funfunc :: Note -> Note -> Note -> Note
funfunc = triple

funfunc_ :: Note
funfunc_ = fun funrel_ fundom_ funimg_

funfun :: Note
funfun = funrel_

-- Distance function symbol
fundist :: Note
fundist = "d"

-- Function metric
funm :: Note
funm = fundist

fdist_ :: Note -> Note -> Note -> Note
fdist_ = funapp2

fdist :: Note -> Note -> Note
fdist = fdist_ fundist


-- Norms
norm_ :: Note -> Note -> Note
norm_ n b = autoBrackets dblPipe dblPipe b !: n

-- Arccos
arccos_ :: Note -> Note
arccos_ = funapp arccos


-- Binary Operations
funbinopsign :: Note
funbinopsign = comm0 "star"

funbinop :: Note -> Note -> Note
funbinop f a = fun (pars f) (a ⨯ a) a

funbinop_ :: Note
funbinop_ = funbinop funbinopsign fundom_

funbinopapp :: Note -> Note -> Note
funbinopapp = binop funbinopsign

-- C-k 2*
(★) :: Note -> Note -> Note
(★) = funbinopapp

