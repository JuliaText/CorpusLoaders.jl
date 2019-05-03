using CorpusLoaders
using CorpusLoaders: @NestedVector
using DataDeps
using Test
using Base.Iterators
using MultiResolutionIterators

@testset "Stanford Sentiment Treebank" begin
    sst_gen = load(StanfordSentimentTreebank())
    docs = collect(take(sst_gen, 5));

    @test typeof(docs) == @NestedVector(Any, 2)
    @testset "output test" for doc in docs
        @test typeof(doc[1]) == @NestedVector(String, 2)
        @test typeof(doc[2]) <: Number
    end

    docs = permutedims(reshape(hcat(docs...), (length(docs[1]), length(docs))))
    words = flatten_levels(docs[:, 1], (!lvls)(StanfordSentimentTreebank, :words))|>full_consolidate
    senti_labels = docs[:, 2]
    @test typeof(words) == Vector{String}
    @test typeof(senti_labels) == Vector{Any}

    sentences = flatten_levels(docs[:, 1], (lvls)(StanfordSentimentTreebank, :documents))|>full_consolidate
    @test sum(length.(sentences)) == length(words)
    @test typeof(flatten_levels(docs[:, 1], (!lvls)(StanfordSentimentTreebank, :documents))|>full_consolidate) == Vector{String}
    @test typeof(flatten_levels(docs[:, 1], (!lvls)(StanfordSentimentTreebank, :sentences))|>full_consolidate) == Vector{String}
end
