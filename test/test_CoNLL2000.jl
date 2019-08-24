using CorpusLoaders
using Test
using Base.Iterators
using MultiResolutionIterators

@testset "Basic use" begin
    train = load(CoNLL2000(), "train")
    test = load(CoNLL2000(), "test")

    @test length(train) > 0
    @test length(test) > 0
end

@testset "Using flatten_levels" begin
    train = load(CoNLL2000())
    num_sents = 10
    dataset = train[1:10]
    words = full_consolidate(flatten_levels(dataset, (!lvls)(CoNLL2000, :word)))
    @test length(words) > num_sents
    @test length(words) == sum(length.(dataset))
    @test typeof(words) == Vector{CorpusLoaders.POSTaggedWord}

    plain_words = word.(words)
    @test typeof(plain_words) <: Vector{String}
    pos_tags = part_of_speech.(words)
    @test typeof(pos_tags) <: Vector{String}
end
