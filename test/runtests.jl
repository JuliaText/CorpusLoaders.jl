using Test
using CorpusLoaders

files = ["types",
         "SemCor",
         "Senseval3",
         "CoNLL",
         "IMDB",
         "Twitter",
         "StanfordSentimentTreebank",
         "wikicorpus",
         "wikigold"
        ]


@testset "$file" for file in files
    include("test_" * file * ".jl")
end
