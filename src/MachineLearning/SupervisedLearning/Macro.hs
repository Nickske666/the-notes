module MachineLearning.SupervisedLearning.Macro where

import           Types

import           Macro.MetaMacro
import           Macro.Tuple

import           Functions.Application.Macro

-- * Measurements

-- | Measurement input space
mmis_ :: Note
mmis_ = "X"

-- | Measurement output space
mmos_ :: Note
mmos_ = "Y"

-- * Measurement Spaces

-- | Measurement Space
mms :: Note -> Note -> Note
mms = tuple

-- | Concrete measurement space
mms_ :: Note
mms_ = mms mmis_ mmos_

-- * Hypotheses

-- | Concrete hypothesis
hyp_ :: Note
hyp_ = "h"

-- | Prediction
pred :: Note -> Note
pred = fn hyp_

-- * Loss functions

-- | Concrete loss function
lf_ :: Note
lf_ = "l"

loss :: Note -> Note -> Note
loss = fn2 lf_

-- * Datasets

-- | Full dataset
ds_ :: Note
ds_ = mathcal "Z"

-- | Training data
trds_ :: Note
trds_ = ds_ !: "train"

-- | Validation data
vds_ :: Note
vds_ = ds_ !: "validation"

-- | Test data
tds_ :: Note
tds_ = ds_ !: "test"

-- * Hypothesis
