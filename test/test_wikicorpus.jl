using CorpusLoaders
using Base.Test


@testset "basic use" begin
    wk_gen = load(WikiCorpus())
    docs = collect(Base.Iterators.take(wk_gen, 100));

#    @test all(isa.(words, AbstractString))
#    @test "a" ∈ words
#    @test "the" ∈ words

end
