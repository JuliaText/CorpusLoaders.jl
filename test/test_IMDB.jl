using CorpusLoaders
using CorpusLoaders: @NestedVector
using Test
using Base.Iterators
using MultiResolutionIterators
using DataDeps

@testset "basic use $category" for category in ["train_pos", "train_neg", "test_pos", "test_neg"]
    imdb_gen = load(IMDB(category))
    docs = collect(take(imdb_gen, 5))

    @test typeof(docs) == @NestedVector(String, 3)

    words = flatten_levels(docs, (!lvls)(IMDB, :words))|>full_consolidate
    @test typeof(words) == Vector{String}

    sentences = flatten_levels(docs, lvls(IMDB, :documents))|>full_consolidate
    @test typeof(sentences) == @NestedVector(String, 2)
    @test sum(length.(sentences)) == length(words)

    @test typeof(flatten_levels(docs, (!lvls)(IMDB, :documents))|>full_consolidate) == Vector{String}
    @test typeof(flatten_levels(docs, (!lvls)(IMDB, :sentences))|>full_consolidate) == Vector{String}

end
