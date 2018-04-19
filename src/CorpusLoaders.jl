module CorpusLoaders
using DataDeps
using WordTokenizers
using MultiResolutionIterators
using InternedStrings
using Glob
using StringEncodings

export Document, title
export load

export WikiCorpus

function __init__()

    include("WikiCorpus_DataDeps.jl")
end

include("types.jl")
include("WikiCorpus.jl")



end
