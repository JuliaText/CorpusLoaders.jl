using CorpusLoaders
using Test

files = ["types",
         "wikicorpus",
         "SemCor",
         "Senseval3",
         "IMDB",
         "Twitter"
        ]


@testset "$file" for file in files
    include("test_" * file * ".jl")
end
