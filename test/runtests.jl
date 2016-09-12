using CorpusLoaders
using Base.Test

@testset "Semcor" begin
	include("semcor.jl")
end


@testset "Tokenizers" begin
	include("./tokenizers.jl")
end

include("./similarity.jl")
