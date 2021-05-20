module CorpusLoaders
using DataDeps
using WordTokenizers
using MultiResolutionIterators
using InternedStrings
using Glob
using StringEncodings
using CSV

export Document, TaggedWord, SenseAnnotatedWord, PosTaggedWord
export title, sensekey, word, named_entity, part_of_speech
export load

export WikiCorpus, SemCor, Senseval3, CoNLL, IMDB, Twitter, StanfordSentimentTreebank, WikiGold, CoNLL2000


include("types.jl")
include("apply_subparsers.jl")
include("WikiCorpus.jl")
include("SemCor.jl")
include("SemEval2007Task7.jl")
include("Senseval3.jl")
include("CoNLL.jl")
include("IMDB.jl")
include("Twitter.jl")
include("StanfordSentimentTreebank.jl")
include("WikiGold.jl")
include("CoNLL2000.jl")

function __init__()
    init_datadeps(WikiCorpus)
    init_datadeps(SemCor)
    init_datadeps(Senseval3)
    init_datadeps(CoNLL)
    init_datadeps(IMDB)
    init_datadeps(Twitter)
    init_datadeps(StanfordSentimentTreebank)
    init_datadeps(WikiGold)
    init_datadeps(CoNLL2000)
    init_datadeps_SemEval2007Task7()
end

end
