using CorpusLoaders
using Test
using Base.Iterators
using MultiResolutionIterators
using InternedStrings

@testset "basic use" begin
    wk_gen = load(WikiCorpus())
    docs = collect(take(wk_gen, 5));


    @test typeof(docs) ==
        Vector{CorpusLoaders.Document{@NestedVector(String, 4), String}}
#    @test all(isa.(words, AbstractString))
#    @test "a" ∈ words
#    @test "the" ∈ words
    words = collect(flatten_levels(docs, (!lvls)(WikiCorpus, :word)))
    @test typeof(words) == Vector{String}
    @test length(words) >= length(docs)

    vocab = Set(words)
    @test "the" ∈ vocab
    @test "a" ∈ vocab

    #Make sure we're not catching anything we shouldn't
    @test "ENDOFARTICLE" ∉ vocab
    @test "ENDOFARTICLE." ∉ vocab
    # @test "<doc" ∉ map(x->x[1:min(end,4)], vocab)


    docs_of_words = full_consolidate(flatten_levels(docs, (!lvls)(WikiCorpus, :doc, :word)))
    @test typeof(docs_of_words) == Vector{CorpusLoaders.Document{Vector{String}, String}}
    @test length(docs_of_words) == length(docs)
    @test sum(length.(docs_of_words)) == length(words)
end
