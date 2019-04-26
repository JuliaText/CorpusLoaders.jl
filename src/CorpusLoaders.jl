module CorpusLoaders
using DataDeps
using WordTokenizers
using MultiResolutionIterators
using InternedStrings
using Glob
using StringEncodings
using CSV

export Document, TaggedWord, SenseAnnotatedWord, PosTaggedWord
export title, sensekey, word
export load

export WikiCorpus, SemCor, Senseval3, IMDB, Twitter

    include("WikiCorpus_DataDeps.jl")
    include("SemCor_DataDeps.jl")
    include("SemEval2007Task7_DataDeps.jl")
    include("Senseval3_DataDeps.jl")
    include("IMDB_DataDeps.jl")
    include("Twitter_DataDeps.jl")


include("types.jl")
include("apply_subparsers.jl")
include("WikiCorpus.jl")
include("SemCor.jl")
include("SemEval2007Task7.jl")
include("Senseval3.jl")
include("IMDB.jl")
include("Twitter.jl")

end
