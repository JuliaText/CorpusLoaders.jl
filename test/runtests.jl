using CorpusLoaders
using Test

ENV["DATADEPS_ALWAYS_ACCEPT"] = "true";

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
