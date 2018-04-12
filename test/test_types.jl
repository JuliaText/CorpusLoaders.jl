using Base.Test
using CorpusLoaders
using CorpusLoaders: @NestedVector

@testset "NestedVector" begin
    @test @NestedVector(Int,1)==Vector{Int}
    @test @NestedVector(Char,2)==Vector{Vector{Char}}
    @test @NestedVector(String, 3)==Vector{Vector{Vector{String}}}
end

@testset "Document" begin
    @test collect(Document(["a", "b", "c"])) == ["a", "b", "c"]
    @test collect(Document("foos",["a", "b", "c"])) == ["a", "b", "c"]
end
