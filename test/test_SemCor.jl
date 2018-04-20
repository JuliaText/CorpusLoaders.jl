using CorpusLoaders
using Base.Test
using Base.Iterators
using MultiResolutionIterators
using InternedStrings

@testset "basic use" begin
    wk_gen = load(SemCor())
    docs = collect(take(wk_gen, 10));
end
