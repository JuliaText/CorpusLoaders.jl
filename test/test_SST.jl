using CorpusLoaders
using CorpusLoaders: @NestedVector
using DataDeps
using Test
using Base.Iterators
using MultiResolutionIterators

@testset "SST sentiment" begin
    sst_gen = load(SST())
    docs = collect(take(sst_gen, 5));

    @test typeof(docs) == Array{Array{Any,1},1}
    @testset "output test" for doc in docs
        @test typeof(doc[1]) == @NestedVector(String, 2)
        @test typeof(doc[2]) <: Number
    end

    docs = permutedims(reshape(hcat(docs...), (length(docs[1]), length(docs))))
    words = flatten_levels(docs[:, 1], (!lvls)(SST, :words))|>full_consolidate
    senti_labels = docs[:, 2]
    @test typeof(words) == Vector{String}
    @test typeof(senti_labels) == Vector{Any}

    sentences = flatten_levels(docs[:, 1], (lvls)(SST, :documents))|>full_consolidate
    @test sum(length.(sentences)) == length(words)
    @test typeof(flatten_levels(docs[:, 1], (!lvls)(SST, :documents))|>full_consolidate) == Vector{String}
    @test typeof(flatten_levels(docs[:, 1], (!lvls)(SST, :sentences))|>full_consolidate) == Vector{String}
end
