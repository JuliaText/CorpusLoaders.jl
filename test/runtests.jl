using Test
using CorpusLoaders

ENV["DATADEPS_ALWAYS_ACCEPT"] = "true";

files = ["types",
         "SemCor",
         "Senseval3",
         "wikicorpus"
        ]


@testset "$file" for file in files
    include("test_" * file * ".jl")
end
