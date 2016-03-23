module Probability.RandomVariable where

import           Notes

import           Functions.Application.Macro
import           Functions.Basics.Macro
import           Functions.Basics.Terms
import           Functions.Inverse.Macro
import           Logic.FirstOrderLogic.Macro
import           Logic.PropositionalLogic.Macro
import           Probability.Independence.Terms
import           Probability.Intro.Macro
import           Probability.Intro.Terms
import           Probability.ProbabilityMeasure.Macro
import           Probability.ProbabilityMeasure.Terms
import           Probability.SigmaAlgebra.Macro
import           Probability.SigmaAlgebra.Terms
import           Relations.Domain.Terms

import           Probability.RandomVariable.Macro
import           Probability.RandomVariable.Terms


randomVariableS :: Note
randomVariableS = section "Random Variables" $ do
    introS
    distributionFunctionSS
    quantileFunctionSS
    copiesOfRandomVariablesSS
    typesOfRandomVariables
    momentsOfRandomVariables

psDec :: Note
psDec = s ["Let ", m prsp_, " be a ", probabilitySpace]

introS :: Note
introS = subsection "Intro" $ do
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
    ma $ rvfunc_
    ma $ fa (b ∈ boreals) $ inv x `fn` b =: setcmpr omega (x `fn` omega ∈ b)

  where
    b = "B"
    x = "X"

saMeasureDefinition :: Note
saMeasureDefinition = de $ do
    psDec
    s ["Let ", m rv_, " be a ", randomVariable]
    s [m rv_, " is called a ", m sa_, "-", measure]

borealMesureDefinition :: Note
borealMesureDefinition = de $ do
    s ["A ", m boreals, "-", measure, " in the ", measurableSpace, " ", m (mspace reals boreals), " is called ", borelMeasure]

randomVariableCondition :: Note
randomVariableCondition = thm $ do
    s ["A ", function, " ", m (fun x reals reals), " is a ", randomVariable, " in the ", measurableSpace, " ", m (mspace reals boreals), " if and only if the following holds"]
    ma $ fa (a ∈ reals) $ inv x `fn` (ocint minfty a) =: setcmpr omega (rv_ `fn` omega <= a) ∈ sa_
  where
    a = "A"
    x = "X"

borealMeasurableInducesProbabilityMeasure :: Note
borealMeasurableInducesProbabilityMeasure = thm $ do
    s ["A Borel-measurable function induces a ", probabilityMeasure, " ", m (prm_ !: rv_), on, m boreals, " in ", m prbsp, " as follows"]
    ma $ px b =: prob (x ∈ b) =: prob (inv x `fn` b)
    ma $ px b =: prob (setcmpr (omega ∈ univ_) (vrv omega ∈ b))
    toprove
  where
    b = "B"
    x = "X"
    px = fn (prm_ !: rv_)

distributionFunctionSS :: Note
distributionFunctionSS = subsection "Cumulative distribution function" $ do
    cumulativeDistributionFunctionDefinition
    distributionFunctionCondition
    distributionBetweenValues
    distributionAfterValue


cumulativeDistributionFunctionDefinition :: Note
cumulativeDistributionFunctionDefinition = de $ do
    lab cumulativeDistributionFunctionDefinitionLabel
    lab cDFDefinitionLabel
    lab distributionFunctionDefinitionLabel
    lab probabilityDistributionDefinitionLabel
    psDec
    s ["Let ", m rvfunc_, " be a ", randomVariable]
    s ["The ", cumulativeDistributionFunction', " (", cDF', "), ", distributionFunction', or, probabilityDistribution," as follows"]
    ma $ func df_ reals reals a $ prd (ocint minfty a) =: prob (setcmpr o (vrv o)) =: prob (rv_ <= a)
    s ["Sometimes the defineTerm ", distribution', " is also used as-is"]
  where
    a = "a"
    o = omega

distributionFunctionCondition :: Note
distributionFunctionCondition = thm $ do
    s ["Let ", m rv_, " be a random variable in ", m prbsp]
    s ["A function ", m (fun df_ reals reals), " is a ", cumulativeDistributionFunction, " if and only if it has the following three properties"]
    enumerate $ do
        item $ do
            s [m df_, " is monotonically increasing"]
            ma $ fa (cs [a, b] ∈ reals) $ (a <= b) ⇒ (prd a <= prd b)
        item $ do
            ma $ lim a minfty (prd a) =: 0
            ma $ lim a pinfty (prd a) =: 1
        item $ do
            s [m df_, " is right-continuous"]
            ma $ fa (a ∈ reals) $ rlim h 0 (prd $ a + h) =: prd a
            refneeded "right-continuous" -- Also use the proper index
    noproof

  where
    a = "a"
    b = "b"
    h = "h"

bdfDec :: Note
bdfDec = s ["Let ", m df_, " be a distribution function in ", m prbsp]

distributionBetweenValues :: Note
distributionBetweenValues = thm $ do
    bdfDec
    ma $ fa (cs [a, b] ∈ reals) $ prob (a < rv_ <= b) =: prd b - prd a

    toprove
  where
    a = "a"
    b = "b"

distributionAfterValue :: Note
distributionAfterValue = thm $ do
    bdfDec
    ma $ fa (a ∈ reals) $ prob (rv_ > a) =: 1 - prd a

    toprove
  where a = "a"

quantileFunctionSS :: Note
quantileFunctionSS = subsection "The quantile function" $ do
    quantileFunctionDefinition
    quartileDefinition
    medianDefinition

quantileFunctionDefinition :: Note
quantileFunctionDefinition = de $ do
    s ["The ", quantileFunction', for, m prbsp, " is the inverse of the ", distributionFunction, " ", m df_]
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

copiesOfRandomVariablesSS :: Note
copiesOfRandomVariablesSS = subsection "Copies of random variables" $ do
    independentCopyDefinition
    cloneDefinition
    copyVsCloneExample

independentCopyDefinition :: Note
independentCopyDefinition = de $ do
    lab independentCopyDefinitionLabel
    let x = "X"
    s ["Let", m x, "be a", randomVariable]
    let q = "q"
    s ["We denote by", m $ icop x q, the, randomVariable, "consisting of", m q, independentCopies', "of", m x]
    let x1 = x !: 1
        x2 = x !: 2
        xq = x !: q
    ma $ icop x q =: tuplelist x1 x2 xq
    s ["More precicely,", m $ list x1 x2 xq, "are", independent, "and have the same", probabilityDistribution, "as", m x]


cloneDefinition :: Note
cloneDefinition = de $ do
    lab cloneDefinitionLabel
    let x = "X"
    s ["Let", m x, "be a", randomVariable]
    let q = "q"
    s ["We denote by", m $ clon x q, the, randomVariable, "consisting of", m q, clones', "of", m x]
    let x1 = x !: 1
        x2 = x !: 2
        xq = x !: q
    ma $ clon x q =: tuplelist x1 x2 xq
    s ["More precicely,", m $ list x1 x2 xq, "are identical"]


copyVsCloneExample :: Note
copyVsCloneExample = ex $ do
    let x = "X"
    s ["Let", m x, "be a binary", randomVariable, "with a uniform", distribution]
    let q = "q"
    s [m $ icop x q, "is the", randomVariable, "with uniform", distribution, "over", m $ setofs [0, 1] ^ q, "and", m $ clon x q, "is the", randomVariable, "which takes on the two values", m $ tuplelist 0 0 0, and, m $ tuplelist 1 1 1, "with", probability, m $ 1 /: 2]


typesOfRandomVariables :: Note
typesOfRandomVariables = subsection "Types of random variables" $ do
    discreteRandomVariables
    continuousRandomVariables

discreteRandomVariables :: Note
discreteRandomVariables = subsubsection "Discrete random variables" $ do
    discreteRandomVariableDefinition
    discreteDistributionDefinition
    discreteCumulativeDistribution
    discreteRandomVariableExamples

discreteRandomVariableDefinition :: Note
discreteRandomVariableDefinition = de $ do
    s ["A ", randomVariable, " ", m rv_, " in a ", probabilitySpace, " ", m prsp_, " is called ", discrete', " if the ", image, " under ", m rv_, " is non-zero in just a countable number of points"] --FIXME index countable
    ma $ pi =: prob (setcmpr (omega ∈ univ_) (vrv omega =: xi)) =: prob (rv_ =: xi)

  where
    i = "i"
    xi = "x" !: i
    pi = "p" !: i

discreteDistributionDefinition :: Note
discreteDistributionDefinition = de $ do
    s ["A ", discreteDistribution', " ", m (sequ pi i), " of a ", discrete, " ", randomVariable, " ", m rv_, " in a ", probabilitySpace, " ", m prsp_, " is a ", sequence, " with the following properties"]
    enumerate $ do
        item $ m $ fa (i ∈ naturals) (pi >= 0)
        item $ m $ sumcmp i pi =: 1

  where
    i = "i"
    pi = "p" !: i

discreteCumulativeDistribution :: Note
discreteCumulativeDistribution = thm $ do
    s [the, distributionFunction, " ", m df_, " of a ", discrete, " ", randomVariable, " ", m rv_, " in a ", probabilitySpace, " ", m prsp_, " has a simpler formula"]
    ma $ prd a =: prob (rv_ <= a) =: sumcmp (xi <= a) pi

    toprove
  where
    a = "a"
    i = "i"
    xi = "x" !: i
    pi = "p" !: i

discreteRandomVariableExamples :: Note
discreteRandomVariableExamples = do
    ex $ do
        let h = "Heads"
            t = "Tails"
            p = "p"
            u = setofs [h, t]
        s ["Let", m u, "be the universe of the", stochasticExperiment, "of throwing up a flipping an unfair coin"]
        s ["Let", m $ powset u, "be a", sigmaAlgebra]
        s ["Let the following", function, m prm_, "be a", probabilityMeasure]
        ma $ fun prm_ (powset u) (ccint 0 1)
        ma $ cases $ do
            u & mapsto <> 1
            lnbk
            h & mapsto <> p
            lnbk
            t & mapsto <> (1 - p)
            lnbk
            emptyset & mapsto <> 0
        let x = "X"
        s ["If we were to bet that the coin would come up heads with a fifty units payoff, then that payoff could be modeled as a", discrete, randomVariable, m x, "in the", probabilitySpace, m prsp_, "as follows"]
        ma $ cases $ do
            fn x h =: 50
            lnbk
            fn x t =: 0

continuousRandomVariables :: Note
continuousRandomVariables = subsubsection "Continuous random variables" $ do
    continuousRandomVariableDefinition
    probabilityDensitySSS
    intervalOpenCloseDistribution


continuousRandomVariableDefinition :: Note
continuousRandomVariableDefinition = de $ do
    s ["A ", randomVariable, " ", m rv_, " in a ", probabilitySpace, " ", m prsp_, " is called ", continuous', " if the image of every point under ", m rv_, " is zero.."]
    ma $ fa (x ∈ univ_) (prob (setof x) =: 0)
    s ["... and the distribution function ", m df_, " is a continuous function"]
    refneeded "continuous function"

  where x = "x"

prdsDec :: Note
prdsDec = s ["Let ", m df_, " be a ", distributionFunction, " of a ", continuous, " ", randomVariable, " ", m rv_, " in a ", probabilitySpace, " ", m prsp_, " that is ", continuous, " with a ", continuous, derivative]

probabilityDensitySSS :: Note
probabilityDensitySSS = note "density" $ do
    probabilityDensitiyFunctionDefinition
    probabilityDensityDistribution
    probabilityDensityDistributionBetween


probabilityDensitiyFunctionDefinition :: Note
probabilityDensitiyFunctionDefinition = de $ do
    lab probabilityDensityFunctionDefinitionLabel
    lab probabilityDensityDefinitionLabel
    lab densityDefinitionLabel
    prdsDec
    s ["The ", probabilityDensityFunction', or, probabilityDensity', " ", m dsf_, " is the following ", function]
    ma $ func dsf_ reals reals x $ prds x =: deriv (prd x) x
  where x = "x"

probabilityDensityDistribution :: Note
probabilityDensityDistribution = thm $ do
    prdsDec
    s ["Let ", m dsf_, " be the ", probabilityDensityFunction, " of ", m rv_]
    ma $ prd a =: prob (x <= a) =: int minfty a (prds x) x

    toprove
  where
    a = "a"
    x = "x"


probabilityDensityDistributionBetween :: Note
probabilityDensityDistributionBetween = thm $ do
    prdsDec
    s ["Let ", m dsf_, " be the ", probabilityDensityFunction, " of ", m rv_]
    ma $ prd x - prd a =: prob (a < rv_ <= b) =: int a b (prds x) x

    toprove
  where
    a = "a"
    b = "b"
    x = "x"

intervalOpenCloseDistribution :: Note
intervalOpenCloseDistribution = thm $ do
    s ["Let ", m rv_, " be a ", continuous, " ", randomVariable, " in a ", probabilitySpace, " ", m prsp_, " and let ", m df_, " be the ", distributionFunction, " of ", m rv_]
    ma $ prd (ooint a b)
      =: prd (ocint a b)
      =: prd (coint a b)
      =: prd (ccint a b)

    toprove
  where
    a = "a"
    b = "b"


momentsOfRandomVariables :: Note
momentsOfRandomVariables = subsection "Moments of random variables" $ do
    subsubsection "Expected value and variance" $ do
        note "Expected Value" $ do
            expectedValueDefinition
            expectationOfConstant
            linearityOfExpectation
        note "Covariance" $ do
            covarianceDefinition
        note "Variance" $ do
            varianceDefinition
            varianceInTermsOfExpectation
        note "Standard deviation" $ do
            standardDeviationDefinition
        note "Correlation" $ do
            correlationDefinition

    subsubsection "Sum and product of random variables" $ do
        independenceOfRandomVariables
        sumOfRandomVariablesDefinition
        sumOfRandomVariablesIsRandomVariableTheorem
        expectedValueOfSumTheorem
        varianceOfSumTheorem
        productOfRandomVariablesDefinition
        productOfRandomVariablesIsRandomVariableTheorem
        expectedValueOfProductTheorem

    subsubsection "Inequalities involving random variables" $ todo "TODO"
    subsubsection "Higher moments" $ todo "TODO"

expectedValueDefinition :: Note
expectedValueDefinition = de $ do
    lab expectedValueDefinitionLabel
    s ["Let ", m df_, " be a ", distributionFunction, " of a ", continuous, " ", randomVariable, m rv_, " in a ", probabilitySpace, m prsp_, " that is ", continuous, " with a ", continuous, derivative]
    s [the, expectedValue', " of ", m rv_, " is defined as follows"]
    ma $ ev rv_ === int_ univ_ rv_ prm_ -- TODO two cases
    s ["For a ", discrete, randomVariable, m rv_, " this comes down to the following"]
    ma $ do
        let (i, p, x) = ("i", "p", "x")
        ev rv_ =: sumcmp i (x !: i * p !: i)
    s ["For a ", continuous, randomVariable, m rv_, " this comes down to the following"]
    ma $ do
        let x = "x"
        ev rv_ =: int minfty pinfty (x * prds x) x

expectationOfConstant :: Note
expectationOfConstant = thm $ do
    lab expectationOfConstantTheoremLabel
    let b = "b"
    s ["Let" , m rv_, "be a", randomVariable, and, m b, "a", constant]
    ma $ ev b =: b
    toprove

linearityOfExpectation :: Note
linearityOfExpectation = thm $ do
    lab linearityOfExpectationTheoremLabel
    let (a, b) = ("a", "b")
    s ["Let", m rv_, "be a", randomVariable, and, m a, and, m b, constants]
    ma $ ev (a * rv_ + b) =: a * ev rv_ + b
    toprove

covarianceDefinition :: Note
covarianceDefinition = de $ do
    lab covarianceDefinitionLabel
    let x = "X"
        y = "Y"
    s ["Let", m x, and, m y, "be two", randomVariables, "in a", probabilitySpace, m prsp_]
    s ["The", covariance', "of", m x, and, m y, "is defined as follows"]
    ma $ cov x y === ev (pars (x - ev x) * pars (y - ev y))

varianceDefinition :: Note
varianceDefinition = de $ do
    lab varianceDefinitionLabel
    s ["Let ", m rv_, " be a ", randomVariable]
    s [the, variance', " of ", m rv_, " is defined as follows"]
    ma $ var rv_ === cov rv_ rv_ =: (ev $ (pars $ rv_ - ev rv_) ^ 2)

varianceInTermsOfExpectation :: Note
varianceInTermsOfExpectation = thm $ do
    lab varianceInTermsOfExpectationTheoremLabel
    s ["Let ", m rv_, " be a ", randomVariable]
    ma $ var rv_ =: ev (rv_ ^ 2) - (ev rv_) ^ 2
    proof $ do
        aligneqs
            (var rv_)
            [
              ev $ (pars $ rv_ - ev rv_) ^ 2
            , ev $ rv_ ^ 2 + (ev rv_) ^ 2 - 2 * rv_ * ev rv_
            , ev (rv_ ^ 2) + ev ((ev rv_) ^ 2) + ev (- 2 * rv_ * ev rv_)
            , ev (rv_ ^ 2) + (ev rv_) ^ 2 - 2 * ev rv_ * ev rv_
            , ev (rv_ ^ 2) - (ev rv_) ^ 2
            ]
    refs [
        linearityOfExpectationTheoremLabel
      , expectationOfConstantTheoremLabel
      ]
    toprove

standardDeviationDefinition :: Note
standardDeviationDefinition = de $ do
    lab standardDeviationDefinitionLabel
    s ["Let ", m rv_, " be a ", randomVariable]
    s [the, standardDeviation', " of ", m rv_, " is defined as the square root of the ", variance, " of ", m rv_]
    ma $ sqrt $ var rv_

correlationDefinition :: Note
correlationDefinition = de $ do
    lab correlationDefinitionLabel
    let x = "X"
        y = "Y"
    s ["Let", m x, and, m y, "be two", randomVariables, "in a", probabilitySpace, m prsp_]
    s [the, correlation', "of", m x, and, m y, "is defined as follows"]
    ma $ cor x y === (cov x y /: sqrt (var x * var y))

independenceOfRandomVariables :: Note
independenceOfRandomVariables = de $ do
    s ["Let ", m x, and, m y, " be random variables in ", m prbsp]
    s [m x, and, m y, " are called ", independent', " if and only if every two events ", m (x <= a), and, m (y <= b), " are ", independent_, " events"]
  where
    a = "a"
    b = "b"
    x = "X"
    y = "Y"


sumOfRandomVariablesDefinition :: Note
sumOfRandomVariablesDefinition = de $ do
    let x = "X"
        y = "Y"
    s ["Let ", m x, and, m y, "be", randomVariables]
    s [the, "sum", m $ x + y, "of", m x, and, m y, " is defined as follows"]
    ma $ fn (pars $ x + y) omega =: fn x omega + fn y omega

sumOfRandomVariablesIsRandomVariableTheorem :: Note
sumOfRandomVariablesIsRandomVariableTheorem = thm $ do
    s [the, sum, "of two", randomVariables, "is a", randomVariable]
    toprove

expectedValueOfSumTheorem :: Note
expectedValueOfSumTheorem = thm $ do
    let x = "X"
        y = "Y"
    s ["Let ", m x, and, m y, "be", randomVariables, "in a", probabilitySpace, m prsp_]
    ma $ ev (x + y) =: ev x + ev y
    toprove

varianceOfSumTheorem :: Note
varianceOfSumTheorem = thm $ do
    let x = "X"
        y = "Y"
    s ["Let ", m x, and, m y, "be", randomVariables, "in a", probabilitySpace, m prsp_]
    ma $ var (x + y) =: var x + var y
    toprove


productOfRandomVariablesDefinition :: Note
productOfRandomVariablesDefinition = de $ do
    let x = "X"
        y = "Y"
    s ["Let ", m x, and, m y, "be", randomVariables]
    s [the, "product", m $ x * y, "of", m x, and, m y, " is defined as follows"]
    ma $ fn (pars $ x * y) omega =: fn x omega * fn y omega


productOfRandomVariablesIsRandomVariableTheorem :: Note
productOfRandomVariablesIsRandomVariableTheorem = thm $ do
    s [the, product, "of two", randomVariables, "is a", randomVariable]
    toprove


expectedValueOfProductTheorem :: Note
expectedValueOfProductTheorem = thm $ do
    let x = "X"
        y = "Y"
    s ["Let ", m x, and, m y, "be", independent, randomVariables, "in a", probabilitySpace, m prsp_]
    ma $ ev (x * y) =: ev x * ev y



