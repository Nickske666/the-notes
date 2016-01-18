module Statistics.Main where

import           Notes

import           Functions.Application.Macro
import           Functions.Basics.Terms
import           Logic.PropositionalLogic.Macro
import           Probability.Distributions.Terms
import           Probability.Independence.Terms
import           Probability.RandomVariable.Macro
import           Probability.RandomVariable.Terms
import           Sets.Basics.Terms

import           Statistics.Macro
import           Statistics.Terms

statisticsC :: Note
statisticsC = chapter "Statistics" $ do
    statisticalModelDefinition
    parameterSpaceDefinition
    parametricModelDefinition
    modifiedMeasuresDefinition
    pointEstimation
    maximumLikelihood

statisticalModelDefinition :: Note
statisticalModelDefinition = de $ do
    lab statisticalModelDefinitionLabel
    s ["A", statisticalModel, m smod_, "is a", set, "of", distributions, "or a", set, "of", densities]

parameterSpaceDefinition :: Note
parameterSpaceDefinition = de $ do
    lab parameterSpaceDefinitionLabel
    s ["A", parameterSpace, m parsp_, "is a", set, "of all possible values of a", finite, set, "of", parameters]

parametricModelDefinition :: Note
parametricModelDefinition = de $ do
    lab parametricModelDefinitionLabel
    lab nonparametricModelDefinitionLabel
    s ["A", parametricModel, m parmod_, "is a", set, " that can be parametrized by a", finite, "number of", parameters]
    s ["A", nonparametricModel, "is a", set, "that cannot be parametrized by a", finite, "number of", parameters]

modifiedMeasuresDefinition :: Note
modifiedMeasuresDefinition = de $ do
    s ["Let", m parmod_, "be a", parametricModel, "and let", m par_, "be a", parameter]
    let c = cdot "" ""
    s [m $ probm par_ c, "is the probability, given", m par_]
    s ["Similarly we write", m $ evm par_ c, "to mean the", expectedValue, "given", m par_]
    s ["This is not the", expectedValue, "over all the parameters", m par_]
    s ["Similarly we also write", m $ varm par_ c, "to mean the", variance, "given", m par_]
    s ["This is not the", variance, "over all the parameters", m par_]

pointEstimation :: Note
pointEstimation = do
    pointEstimateDefinition
    consistentDefinition
    samplingDistributionDefinition
    standardErrorDefinition
    biasDefinition
    note "Mean squared error" $ do
        meanSquaredErrorDefinition
        meanSquaredErrorEquivalentDefinition
    biasOfAverageOfEstimators
    varianceOfAverageOfEstimators

pointEstimateDefinition :: Note
pointEstimateDefinition = de $ do
    lab pointEstimateDefinitionLabel
    lab pointEstimatorDefinitionLabel
    let x = ("X" !:)
        n = "n"
    s ["Let", m $ lst (x 1) (x n), "be", m n, independent, and, identicallyDistributed, randomVariables, "from some distribution", m df_]
    s ["A", pointEstimator', or, pointEstimate, m pest_, "of a parameter", m par_, "is some", function, "of", m $ lst (x 1) (x n)]
    ma $ pest_ === fn "g" (lst (x 1) (x n))
    s ["The real parameter", m par_, "is unknow but fixed"]
    s ["The estimate", m pest_, "depends on", m $ lst (x 1) (x n), "and is therefore a", randomVariable]

consistentDefinition :: Note
consistentDefinition = de $ do
    lab consistentDefinitionLabel
    s ["A", pointEstimate, m pest_, "of a", parameter, m par_, "is called", consistent', "if it converges to", m par_, "in probability"]
    todo "Define convergence in probability"

samplingDistributionDefinition :: Note
samplingDistributionDefinition = de $ do
    s [the, distribution,  "of a", pointEstimate, m pest_, "is called the", samplingDistribution]

standardErrorDefinition :: Note
standardErrorDefinition = de $ do
    s [the, standardDeviation, "of a", pointEstimate, m pest_, "is called the", standardError]
    ma $ se pest_ === sqrt (var pest_)

biasDefinition :: Note
biasDefinition = de $ do
    lab biasDefinitionLabel
    lab unbiasedDefinitionLabel
    s ["Let", m pest_, "be a", pointEstimator]
    s ["We define the", bias', m $ bs par_ pest_, "of", m pest_, "as follows"]
    ma $ bs par_ pest_ === evm par_ pest_ - par_
    s ["A", pointEstimator, "is called", unbiased', "if its", bias, "is zero", ", that is, if its", expectedValue, "is", m par_]

meanSquaredErrorDefinition :: Note
meanSquaredErrorDefinition = de $ do
    lab meanSquaredErrorDefinitionLabel
    s ["Let", m pest_, "be a", pointEstimate]
    s [the, meanSquaredError, "is defined as follows"]
    ma $ mse pest_ === evm par_ ((pars $ pest_ - par_) ^ 2)
    todo "define this weird kind of expected value"

meanSquaredErrorEquivalentDefinition :: Note
meanSquaredErrorEquivalentDefinition = thm $ do
    s ["Let", m pest_, "be a", pointEstimate]
    ma $ mse pest_ =: varm par_ pest_ + (bs par_ pest_) ^ 2
    toprove
    aligneqs (mse pest_)
        [
          evm par_ ((pars $ pest_ - par_) ^ 2)
        , evm par_ ((pars $ pest_ - evm par_ pest_ + evm par_ pest_ - par_) ^ 2)
        , evm par_ ((pars $ (pars $ pest_ - evm par_ pest_) + (pars $ evm par_ pest_ - par_)) ^ 2)
        , evm par_ ((pars $ pest_ - evm par_ pest_) ^ 2 + 2 * (pars $ pest_ - evm par_ pest_) * (pars $ evm par_ pest_ - par_) + (pars $ evm par_ pest_ - par_) ^ 2)
        , evm par_ ((pars $ pest_ - evm par_ pest_) ^ 2)
        + 2 * evm par_ ((pars $ pest_ - evm par_ pest_) * (pars $ evm par_ pest_ - par_))
        + evm par_ ((pars $ evm par_ pest_ - par_) ^ 2)
        , evm par_ ((pars $ pest_ - evm par_ pest_) ^ 2)
        + 2 *  (pars $ evm par_ pest_ - par_) * evm par_ (pars $ pest_ - evm par_ pest_)
        + (pars $ evm par_ pest_ - par_) ^ 2
        , evm par_ ((pars $ pest_ - evm par_ pest_) ^ 2)
        + 2 *  (pars $ evm par_ pest_ - par_) * (pars $ cancel (evm par_ pest_) - cancel (evm par_ pest_))
        + (pars $ evm par_ pest_ - par_) ^ 2
        , evm par_ ((pars $ pest_ - evm par_ pest_) ^ 2)
        + (pars $ evm par_ pest_ - par_) ^ 2
        , varm par_ pest_ + (bs par_ pest_) ^ 2
        ]


biasOfAverageOfEstimators :: Note
biasOfAverageOfEstimators = thm $ do
    let t n = pest_ !: n
        u = "a"
        p = par_
        b = "B"
    s ["Let", m $ setlist (t 1) (t 2) (t b), "be a", set, "of", m b, pointEstimates, "of a", parameter, m p]
    s ["Constructing a new", pointEstimate, m u, "by averaging the", pointEstimates, m $ setlist (t 1) (t 2) (t b), "results in a", pointEstimate, "with the average", bias]
    let i = "i"
    ma $ u =: (1 /: b) * sumcmpr (i =: 1) b (t i)
    ma $ bs p u =: (1 /: b) * sumcmpr (i =: 1) b (bs p (t i))
    proof $ do
        aligneqs (bs p u)
            [
              evm p u - p
            , evm p ((1 /: b) * sumcmpr (i =: 1) b (t i)) - p
            , (1 /: b) * sumcmpr (i =: 1) b (evm p (t i)) - (1 /: b) * (sumcmpr (i =: 1) b p)
            , (1 /: b) * sumcmpr (i =: 1) b (pars $ (evm p (t i)) - p)
            , (1 /: b) * sumcmpr (i =: 1) b (bs p (t i))
            ]

varianceOfAverageOfEstimators :: Note
varianceOfAverageOfEstimators = thm $ do
    let t n = pest_ !: n
        u = "a"
        p = par_
        b = "B"
    s ["Let", m $ setlist (t 1) (t 2) (t b), "be a", set, "of", m b, pointEstimates, "of a", parameter, m p]
    s ["Constructing a new", pointEstimate, m u, "by averaging the", pointEstimates, m $ setlist (t 1) (t 2) (t b), "results in a", pointEstimate, "with a", variance, "as follows"]
    let (i, j) = ("i", "j")
    ma $ u =: (1 /: b) * sumcmpr (i =: 1) b (t i)
    ma $ varm p u =: (1 /: (b ^ 2)) * (pars $ sumcmpr (i =: 1) b (varm p (t i)) + (sumcmpr (i =: 1) b $ sumcmpr (j =: 1 ∧ i ≠ j) b $ covm p (t i) (t j)))
    s ["Assuming that", covariances, "are small and", variances, "similar, this means that averaging", pointEstimates, "reduces decreases the", variance]
    proof $ do
        aligneqs (varm p u)
            [
              -- varm p $ (1 /: b) * sumcmpr (i =: 1) b (t i)
              evm p ((pars $ u - evm p u) ^ 2)
            , evm p ((pars $ ((1 /: b) * sumcmpr (i =: 1) b (t i)) - evm p ((1 /: b) * sumcmpr (i =: 1) b (t i))) ^ 2)
            , evm p (pars $ ((1 /: b) * sumcmpr (i =: 1) b ((t i) - evm p (t i))) ^ 2)
            , (1 /: (b ^ 2)) * (pars $ sumcmpr (i =: 1) b (varm p (t i)) + (sumcmpr (i =: 1) b $ sumcmpr (j =: 1 ∧ i ≠ j) b $ covm p (t i) (t j)))
            ]
        why_ "does this last step work"


maximumLikelihood :: Note
maximumLikelihood = do
    likelihoodFunctionDefinition
    likelihoodNotes
    maximumLikelihoodEstimate

likelihoodFunctionDefinition :: Note
likelihoodFunctionDefinition = de $ do
    lab likelihoodFunctionDefinitionLabel
    s ["Let", m parsp_, "be the", parameterSpace, "of a", parametricModel, m parmod_]
    let x = ("X" !:)
        n = "n"
    s ["Let", m $ lst (x 1) (x n), "be", m n, independent, and, identicallyDistributed, randomVariables, "from some distribution", m df_]
    s [the, likelihoodFunction', m llhSign, "is defined as follows"]
    let t = theta
        i = "1"
    ma $ llh t === prodcmpr (i =: 1) n (prds $ x i)
    s [the, logLikelihoodFunction', "is defined as the logarithm of the", likelihoodFunction]
    ma $ lllh t === log (llh t)


likelihoodNotes :: Note
likelihoodNotes = do
    nte $ do
        s ["The value of the", likelihoodFunction, "for a given", parameter, "represents the probability that the given data occurs assuming that the parameter was the true", parameter, "of the distribution of the data"]
        s ["It is ", textbf "not", "the probability that the", parameter, "is the true", parameter, "of the distribution of the data"]
    nte $ do
        s [the, likelihoodFunction, "is not a", density, function]
        s ["In general it does not integrate to", m 1]

maximumLikelihoodEstimate :: Note
maximumLikelihoodEstimate = do
    de $ do
        s [the, maxmimumLikelihoodEstimate', m mle, "is the", parameter, m par_, "that maximizes", m $ llh par_]
        ma $ pest_ =: max par_ (llh par_)
    nte $ do
        s ["This value is also the value that maximizes", m $ lllh par_]
        s ["In practice, that's more often what we'll do to calculate the", mle]
        todo "prove that this is the case for every transformation"
