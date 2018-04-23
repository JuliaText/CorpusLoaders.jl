module CorpusLoaders
using DataDeps
using WordTokenizers
using MultiResolutionIterators
using InternedStrings
using Glob
using StringEncodings

export Document, title, sensekey, word
export load

export WikiCorpus, SemCor

function __init__()

    include("WikiCorpus_DataDeps.jl")
    include("SemCor_DataDeps.jl")
end

include("types.jl")
include("WikiCorpus.jl")
include("SemCor.jl")


end
