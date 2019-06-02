using CorpusLoaders
using Test
using Base.Iterators
using MultiResolutionIterators

@testset "Basic use" begin
    wk_gen = load(Senseval3())
    docs = collect(take(wk_gen,10));

    words = consolidate(flatten_levels(docs, (!lvls)(Senseval3, :word)))
    @test length(words) > length(docs)
    @test length(words) > sum(length.(docs))
    @test typeof(words) == Vector{CorpusLoaders.TaggedWord}

    plain_words = word.(words)
    @test typeof(plain_words) <: Vector{String}
end

@testset "Index" begin
    corp = load(Senseval3())
    index = Dict{String, Vector{Vector{String}}}()
    for sentence in flatten_levels(corp, (!lvls)(Senseval3, :sent, :word))
        multisense_words = filter(x->x isa SenseAnnotatedWord,  sentence)
        context_words = word.(sentence)
        for target in multisense_words
            word_sense = sensekey(target)
            uses = get!(Vector{Vector{String}}, index, word_sense)
            push!(uses, context_words)
        end
    end

    index

    index["answer%1:04:00::"]
    index["answer%1:10:00::"]
    index["answer%2:32:00::"]
end
