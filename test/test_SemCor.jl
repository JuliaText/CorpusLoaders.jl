using CorpusLoaders
using Test
using Base.Iterators
using MultiResolutionIterators
using DataDeps

@testset "basic use" for path in [datadep"SemCor 1.6", datadep"SemCor 1.7", datadep"SemCor 1.7.1", datadep"SemCor 2.0", datadep"SemCor 3.0", datadep"SemCor 3.0/brownv"]
    wk_gen = load(SemCor(path))
    docs = collect(take(wk_gen, 10));

    words = consolidate(flatten_levels(docs, (!lvls)(SemCor, :word)))
    @test length(words) > length(docs)
    @test length(words) > sum(length.(docs))
    @test typeof(words) == Vector{TaggedWord}

    plain_words = word.(words)
    @test typeof(plain_words) <: Vector{String}
    @test all(startswith.(title.(docs), "br"))
end

@testset "Index" begin
    corp = load(SemCor())
    index = Dict{String, Vector{Vector{String}}}()
    for sentence in flatten_levels(corp, (!lvls)(SemCor, :sent, :word))
        multisense_words = filter(x->x isa SenseAnnotatedWord,  sentence)
        context_words = word.(sentence)
        for target in multisense_words
            word_sense = sensekey(target)
            uses = get!(Vector{Vector{String}}, index, word_sense)
            push!(uses, context_words)
        end
    end
    index

    index["abandon%1:07:00::"]
    index["abandon%2:38:00::"]
    index["abandon%2:40:00::"]
    index["abandon%2:40:01::"]
end
