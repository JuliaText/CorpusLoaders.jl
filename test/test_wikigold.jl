using CorpusLoaders
using Test
using Base.Iterators
using MultiResolutionIterators

@testset "Basic use" begin
    dataset = load(WikiGold())

    @test length(dataset) > 0
    @test minimum(length.(dataset)) > 0
end

@testset "Using flatten_levels" begin
    dataset = load(WikiGold())
    docs = dataset[1:5]

    words = full_consolidate(flatten_levels(docs, (!lvls)(WikiGold, :word)))
    @test length(words) > length(docs)
    @test length(words) > sum(length.(docs))
    @test typeof(words) == Vector{CorpusLoaders.WikiGoldWord}

    plain_words = word.(words)
    @test typeof(plain_words) <: Vector{String}

    ner_tags = CorpusLoaders.named_entity.(words)
    @test typeof(plain_words) <: Vector{String}
end
