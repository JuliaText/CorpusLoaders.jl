using Test
using CorpusLoaders

files = ["types",
         "SemCor",
         "Senseval3",
         "wikicorpus"
        ]


@testset "$file" for file in files
    include("test_" * file * ".jl")
end
