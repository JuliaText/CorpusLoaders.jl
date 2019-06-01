using Test
using CorpusLoaders
using CorpusLoaders: @NestedVector
using MultiResolutionIterators

@testset "NestedVector" begin
    @test @NestedVector(Int,1)==Vector{Int}
    @test @NestedVector(Char,2)==Vector{Vector{Char}}
    @test @NestedVector(String, 3)==Vector{Vector{Vector{String}}}
end

@testset "Document" begin
    @test collect(Document(["a", "b", "c"])) == ["a", "b", "c"]
    @test collect(Document("foos",["a", "b", "c"])) == ["a", "b", "c"]

    @testset "consolidate" begin
        cdoc = consolidate(Document("foos",["a", "b", "c"]))
        @test cdoc.title == "foos"
        @test cdoc[1] == "a"
        @test cdoc[2] == "b"
        @test cdoc[3] == "c"
        @test_throws BoundsError cdoc[4]
    end


    @testset "full_consolidate" begin
        cdocs = full_consolidate([Document("foos",["a", "b", "c"]), Document("bars",["A", "B"])])
        cdoc = cdocs[1]
        @test cdoc.title == "foos"
        @test cdoc[1] == "a"
        @test cdoc[2] == "b"
        @test cdoc[3] == "c"
        @test_throws BoundsError cdoc[4]
    end

end
