using CorpusLoaders
using Base.Test
using DataDeps


@testset "basic use" begin
    wk_gen = load_wikicorpus()
    words = collect(Base.Iterators.take(wk_gen, 10_000));

    @test all(isa.(words, AbstractString))
    @test "a" ∈ words
    @test "the" ∈ words

end

