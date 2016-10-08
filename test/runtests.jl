using CorpusLoaders
using Base.Test

@testset "Semcor" begin
	include("semcor.jl")
end


@testset "Tokenizers" begin
	include("./tokenizers.jl")
end

include("./similarity.jl")


@testset "tag conversion" begin
	include("tags.jl")
end

include("util.jl")

@testset "semeval2007t7" begin
	include("./semeval2007t7.jl")
end
