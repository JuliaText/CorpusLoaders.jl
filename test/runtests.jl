using CorpusLoaders
using Base.Test

testsets = ["semcor.jl",
            "tokenizers.jl",
            "similarity.jl",
            "tags.jl",
            "util.jl",
            "semeval2007t7.jl",
            "wikicorpus.jl"
           ]

for fn in testsets
    @testset "$fn" begin
	    include(fn)
    end
end




