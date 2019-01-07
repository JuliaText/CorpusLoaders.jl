using Base.Test
using CorpusLoaders

files = ["types",
         "wikicorpus",
         "SemCor"
         "Senseval3"
        ]


@testset "$file" for file in files
    include("test_" * file * ".jl")
end
