module CorpusLoaders
using DataDeps
using WordTokenizers
using MultiResolutionIterators
using InternedStrings
using Glob
using StringEncodings

export Document, TaggedWord, SenseAnnotatedWord, PosTaggedWord
export title, sensekey, word
export load

export WikiCorpus, SemCor, Senseval3

file_path = dirname(@__FILE__)

function __init__()
    include(joinpath(file_path, "WikiCorpus_DataDeps.jl"))
    include(joinpath(file_path, "SemCor_DataDeps.jl"))
    include(joinpath(file_path, "SemEval2007Task7_DataDeps.jl"))
    include(joinpath(file_path, "Senseval3_DataDeps.jl"))
end

include("types.jl")
include("apply_subparsers.jl")
include("WikiCorpus.jl")
include("SemCor.jl")
include("SemEval2007Task7.jl")
include("Senseval3.jl")

end
