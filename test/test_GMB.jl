using CorpusLoaders
using Test
using Base.Iterators
using MultiResolutionIterators
using DataDeps

@testset "Using flatten_levels" for path in [datadep"GMB 1.0.0", datadep"GMB 1.1.0", datadep"GMB 2.0.0", datadep"GMB 2.1.0", datadep"GMB 2.2.0"]
    train = load(GMB())
    docs = train[1:5]

    words = full_consolidate(flatten_levels(docs, (!lvls)(CoNLL, :word)))
    @test length(words) > length(docs)
    @test typeof(words) == Vector{CorpusLoaders.NerOnlyTaggedWord}

    plain_words = word.(words)
    @test typeof(plain_words) <: Vector{String}

    ner_tags = named_entity.(words)
    @test typeof(ner_tags) <: Vector{String}

end
