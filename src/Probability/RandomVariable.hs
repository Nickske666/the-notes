module Probability.RandomVariable where

import           Notes

import           Functions.Application.Macro
import           Functions.Basics
import           Functions.Basics.Macro
import           Functions.Inverse.Macro
import           Logic.FirstOrderLogic.Macro
import           Logic.PropositionalLogic.Macro
import           Probability.Independence.Terms
import           Probability.Intro.Macro
import           Probability.ProbabilityMeasure.Macro
import           Probability.ProbabilityMeasure.Terms
import           Probability.SigmaAlgebra.Macro
import           Probability.SigmaAlgebra.Terms
import           Relations.Domain

import           Probability.RandomVariable.Macro
import           Probability.RandomVariable.Terms


randomVariableS :: Note
randomVariableS = note "random-variable" $ do
    section "Random Variables"
    introS
    distributionFunctions
    quantileFunctionSS
    typesOfRandomVariables

psDec :: Note
psDec = s ["Let ", m prsp, " be a ", probabilitySpace]

introS :: Note
introS = note "intro" $ do
    borealsDefinition
    randomVariableDefinition
    saMeasureDefinition
    borealMesureDefinition
    randomVariableCondition
    borealMeasurableInducesProbabilityMeasure


borealsDefinition :: Note
borealsDefinition = de $ do
    s [m boreals, " is the ", m sigma, "-algebra generated by ", m (setcmpr (ocint (minfty) a) (minfty < a < pinfty))]
  where a = "a"

randomVariableDefinition :: Note
randomVariableDefinition = de $ do
    psDec

    s ["A real ", function, " as follows is called a ", randomVariable', or, stochasticVariable']
    -- FIXME use realFunction instead of function once that's defined.
    ma $ prrvfunc
    ma $ fa (b ∈ boreals) $ inv x `fn` b =: setcmpr omega (x `fn` omega ∈ b)

  where
    b = "B"
    x = "X"

saMeasureDefinition :: Note
saMeasureDefinition = de $ do
    psDec
    s ["Let ", m prrv, " be a ", randomVariable]
    s [m prrv, " is called a ", m sa_, "-", measure]

borealMesureDefinition :: Note
borealMesureDefinition = de $ do
    s ["A ", m boreals, "-", measure, " in the ", measurableSpace, " ", m (mspace reals boreals), " is called ", borelMeasure]

randomVariableCondition :: Note
randomVariableCondition = thm $ do
    s ["A ", function, " ", m (fun x reals reals), " is a ", randomVariable, " in the ", measurableSpace, " ", m (mspace reals boreals), " if and only if the following holds"]
    ma $ fa (a ∈ reals) $ inv x `fn` (ocint minfty a) =: setcmpr omega (prrv `fn` omega <= a) ∈ sa_
  where
    a = "A"
    x = "X"

borealMeasurableInducesProbabilityMeasure :: Note
borealMeasurableInducesProbabilityMeasure = thm $ do
    s ["A Borel-measurable function induces a ", probabilityMeasure, " ", m (prpm !: prrv), on, m boreals, " in ", m prbsp, " as follows"]
    ma $ px b =: prob (x ∈ b) =: prob (inv x `fn` b)
    ma $ px b =: prob (setcmpr (omega ∈ univ_) (prvrv omega ∈ b))
    toprove
  where
    b = "B"
    x = "X"
    px = fn (prpm !: prrv)

distributionFunctions :: Note
distributionFunctions = note "distribution-functions" $ do
    subsection "Cumulative distribution function"
    cumulativeDistributionFunctionDefinition
    distributionFunctionCondition
    distributionBetweenValues
    distributionAfterValue

    independenceOfRandomVariables


cumulativeDistributionFunctionDefinition :: Note
cumulativeDistributionFunctionDefinition = de $ do
    psDec
    s ["Let ", m prrvfunc, " be a ", randomVariable]
    s ["The ", cumulativeDistributionFunction', " (", term "CDF", ") or ", distributionFunction', " as follows"]
    ma $ func prdf reals reals a $ prd (ocint minfty a) =: prob (setcmpr o (prvrv o)) =: prob (prrv <= a)
    s ["Sometimes the term ", distribution', " is also used as-is"]
  where
    a = "a"
    o = omega

distributionFunctionCondition :: Note
distributionFunctionCondition = thm $ do
    s ["Let ", m prrv, " be a random variable in ", m prbsp]
    s ["A function ", m (fun prdf reals reals), " is a ", cumulativeDistributionFunction, " if and only if it has the following three properties"]
    enumerate $ do
        item $ do
            s [m prdf, " is monotonically increasing"]
            ma $ fa (cs [a, b] ∈ reals) $ (a <= b) ⇒ (prd a <= prd b)
        item $ do
            ma $ lim a minfty (prd a) =: 0
            ma $ lim a pinfty (prd a) =: 1
        item $ do
            s [m prdf, " is right-continuous"]
            ma $ fa (a ∈ reals) $ rlim h 0 (prd $ a + h) =: prd a
            refneeded "right-continuous" -- Also use the proper index
    noproof

  where
    a = "a"
    b = "b"
    h = "h"

bdfDec :: Note
bdfDec = s ["Let ", m prdf, " be a distribution function in ", m prbsp]

distributionBetweenValues :: Note
distributionBetweenValues = thm $ do
    bdfDec
    ma $ fa (cs [a, b] ∈ reals) $ prob (a < prrv <= b) =: prd b - prd a

    toprove
  where
    a = "a"
    b = "b"

distributionAfterValue :: Note
distributionAfterValue = thm $ do
    bdfDec
    ma $ fa (a ∈ reals) $ prob (prrv > a) =: 1 - prd a

    toprove
  where a = "a"


independenceOfRandomVariables :: Note
independenceOfRandomVariables = de $ do
    s ["Let ", m x, and, m y, " be random variables in ", m prbsp]
    s [m x, and, m y, " are called ", independent', " if and only if every two events ", m (x <= a), and, m (y <= b), " are ", independent_, " events"]
  where
    a = "a"
    b = "b"
    x = "X"
    y = "Y"


quantileFunctionSS :: Note
quantileFunctionSS = note "quantile" $ do
    subsection "The quantile function"
    quantileFunctionDefinition
    quartileDefinition
    medianDefinition

quantileFunctionDefinition :: Note
quantileFunctionDefinition = de $ do
    s ["The ", quantileFunction', for, m prbsp, " is the inverse of the ", distributionFunction, " ", m prdf]
    s ["The value ", m (prq p), " is the smallest value ", m (a ∈ reals), " for which ", m (prd a >= p), " holds"] -- FIXME index smallest
  where
    a = "a"
    p = "p"

quartileDefinition :: Note
quartileDefinition = de $ do
    s ["The ", m "0.25", ", ", m "0.5", and, m "0.75", " ", quantile, " are respectively called the first, second and third ", quartile]

medianDefinition :: Note
medianDefinition = de $ do
    s ["The second ", quartile, " is called the ", median]


typesOfRandomVariables :: Note
typesOfRandomVariables = note "types" $ do
    subsection "Types of random variables"
    discreteRandomVariables
    continuousRandomVariables

discreteRandomVariables :: Note
discreteRandomVariables = note "discrete" $ do
    subsubsection "Discrete random variables"
    discreteRandomVariableDefinition
    discreteDistributionDefinition
    discreteCumulativeDistribution

discreteRandomVariableDefinition :: Note
discreteRandomVariableDefinition = de $ do
    s ["A ", randomVariable, " ", m prrv, " in a ", probabilitySpace, " ", m prsp, " is called ", discrete', " if the ", image, " under ", m prrv, " is non-zero in just a countable number of points"] --FIXME index countable
    ma $ pi =: prob (setcmpr (omega ∈ univ_) (prvrv omega =: xi)) =: prob (prrv =: xi)

  where
    i = "i"
    xi = "x" !: i
    pi = "p" !: i

discreteDistributionDefinition :: Note
discreteDistributionDefinition = de $ do
    s ["A ", discreteDistribution', " ", m (sequ pi i), " of a ", discrete, " ", randomVariable, " ", m prrv, " in a ", probabilitySpace, " ", m prsp, " is a ", sequence, " with the following properties"]
    enumerate $ do
        item $ m $ fa (i ∈ naturals) (pi >= 0)
        item $ m $ sumcmp i pi =: 1

  where
    i = "i"
    pi = "p" !: i

discreteCumulativeDistribution :: Note
discreteCumulativeDistribution = thm $ do
    s [the, distributionFunction, " ", m prdf, " of a ", discrete, " ", randomVariable, " ", m prrv, " in a ", probabilitySpace, " ", m prsp, " has a simpler formula"]
    ma $ prd a =: prob (prrv <= a) =: sumcmp (xi <= a) pi

    toprove
  where
    a = "a"
    i = "i"
    xi = "x" !: i
    pi = "p" !: i

continuousRandomVariables :: Note
continuousRandomVariables = note "continuous" $ do
    subsubsection "Continuous random variables"
    continuousRandomVariableDefinition
    probabilityDensitySSS
    intervalOpenCloseDistribution


continuousRandomVariableDefinition :: Note
continuousRandomVariableDefinition = de $ do
    s ["A ", randomVariable, " ", m prrv, " in a ", probabilitySpace, " ", m prsp, " is called ", continuous', " if the image of every point under ", m prrv, " is zero.."]
    ma $ fa (x ∈ univ_) (prob (setof x) =: 0)
    s ["... and the distribution function ", m prdf, " is a continuous function"]
    refneeded "continuous function"

  where x = "x"

prdsDec :: Note
prdsDec = s ["Let ", m prdf, " be a ", distributionFunction, " of a ", continuous, " ", randomVariable, " ", m prrv, " in a ", probabilitySpace, " ", m prsp, " that is ", continuous, " with a ", continuous, " derivative"] -- FIXME index derivative

probabilityDensitySSS :: Note
probabilityDensitySSS = note "density" $ do
    probabilityDensitiyFunctionDefinition
    probabilityDensityDistribution
    probabilityDensityDistributionBetween


probabilityDensitiyFunctionDefinition :: Note
probabilityDensitiyFunctionDefinition = de $ do
    prdsDec
    s ["The ", probabilityDensityFunction', or, probabilityDensity', " ", m prdsf, " is the following ", function]
    ma $ func prdsf reals reals x $ prds x =: deriv (prd x) x
  where x = "x"

probabilityDensityDistribution :: Note
probabilityDensityDistribution = thm $ do
    prdsDec
    s ["Let ", m prdsf, " be the ", probabilityDensityFunction, " of ", m prrv]
    ma $ prd a =: prob (x <= a) =: int minfty a (prds x) x

    toprove
  where
    a = "a"
    x = "x"


probabilityDensityDistributionBetween :: Note
probabilityDensityDistributionBetween = thm $ do
    prdsDec
    s ["Let ", m prdsf, " be the ", probabilityDensityFunction, " of ", m prrv]
    ma $ prd x - prd a =: prob (a < prrv <= b) =: int a b (prds x) x

    toprove
  where
    a = "a"
    b = "b"
    x = "x"

intervalOpenCloseDistribution :: Note
intervalOpenCloseDistribution = thm $ do
    s ["Let ", m prrv, " be a ", continuous, " ", randomVariable, " in a ", probabilitySpace, " ", m prsp, " and let ", m prdf, " be the ", distributionFunction, " of ", m prrv]
    ma $ prd (ooint a b)
      =: prd (ocint a b)
      =: prd (coint a b)
      =: prd (ccint a b)

    toprove
  where
    a = "a"
    b = "b"

















