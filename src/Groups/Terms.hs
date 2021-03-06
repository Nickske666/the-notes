module Groups.Terms where

import           Notes hiding (cyclic, inverse)

makeDefs
    [ "magma"
    , "semigroup"
    , "monoid"
    , "identity"
    , "neutral element"
    , "group"
    , "subgroup"
    , "trivial subgroup"
    , "inverse"
    , "cyclic"
    , "generator"
    , "order"
    ]


makeThms
    [ "subgroup same identity"
    , "generated set is group"
    , "trivial subgroups"
    , "element order divides group order"
    ]
