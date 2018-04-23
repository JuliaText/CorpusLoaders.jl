using CorpusLoaders
using Base.Test
using Base.Iterators
using MultiResolutionIterators
using InternedStrings

@testset "basic use" begin
    wk_gen = load(SemCor())
    docs = collect(take(wk_gen, 10));

    words = consolidate(flatten_levels(docs, (!lvls)(SemCor, :word)))
    @test length(words) > length(docs)
    @test length(words) > sum(length.(docs))
    @test typeof(words) == Vector{CorpusLoaders.TaggedWord}

    plain_words = word.(words)
    @test typeof(plain_words) <: Vector{InternedString}
    @test all(startswith.(title.(docs), "br"))
end
