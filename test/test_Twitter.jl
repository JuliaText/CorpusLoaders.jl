using CorpusLoaders
using CorpusLoaders: @NestedVector
using Test
using Base.Iterators
using MultiResolutionIterators
using DataDeps

@testset "basic use $category" for category in ["train_pos", "train_neg", "test_pos", "test_neg"]
    twitter_gen = load(Twitter(category))
    docs = collect(take(twitter_gen, 10))

    @test typeof(docs) == @NestedVector(String, 3)

    words = flatten_levels(docs, (!lvls)(Twitter, :words))|>full_consolidate
    @test typeof(words) == Vector{String}

    sentences = flatten_levels(docs, (lvls)(Twitter, :documents))|>full_consolidate
    @test length([sent for sent in sentences if length(sent) != 0]) == length(sentences)
    @test sum(length.(sentences)) == length(words)

    @test typeof(full_consolidate(flatten_levels(docs, (!lvls)(Twitter, :documents)))) == Vector{String}
    @test typeof(flatten_levels(docs, (!lvls)(Twitter, :sentences))|>full_consolidate) == Vector{String}

end
