using CorpusLoaders
using CorpusLoaders: @NestedVector
using DataDeps
using Test
using Base.Iterators
using MultiResolutionIterators

@testset "Stanford Sentiment Treebank" begin
    sst_dataset = load(StanfordSentimentTreebank())

    @test typeof(sst_dataset) == Array{Any, 2}
    @test unique(typeof.(sst_dataset[:, 1]))[1] == @NestedVector(String, 2)

    docs = sst_dataset[1:5, :]
    words = flatten_levels(docs[:, 1], (!lvls)(StanfordSentimentTreebank, :words))|>full_consolidate
    senti_labels = docs[:, 2]
    @test typeof(words) == Vector{String}
    @test unique(typeof.(senti_labels))[1] == Float64

    sentences = flatten_levels(docs[:, 1], (lvls)(StanfordSentimentTreebank, :documents))|>full_consolidate
    @test sum(length.(sentences)) == length(words)
    @test typeof(flatten_levels(docs[:, 1], (!lvls)(StanfordSentimentTreebank, :documents))|>full_consolidate) == Vector{String}
    @test typeof(flatten_levels(docs[:, 1], (!lvls)(StanfordSentimentTreebank, :sentences))|>full_consolidate) == Vector{String}
end
