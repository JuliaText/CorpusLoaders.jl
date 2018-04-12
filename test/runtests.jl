using Base.Test
using CorpusLoaders

files = ["types",
         "wikicorpus"
        ]


@testset "$file" for file in files
    include("test_" * file * ".jl")
end
