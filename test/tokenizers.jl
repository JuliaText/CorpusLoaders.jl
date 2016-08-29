

using Base.Test
using CorpusLoaders

@testset "Poorman's Tokenizer" begin
	@test poormans_tokenize("a b c") == ["a", "b", "c"]
	@test poormans_tokenize("a's b c") == ["as", "b", "c"]
	@test poormans_tokenize("a b- c") == ["a", "b", "c"]
end


@testset "Punctiontion Space Tokenizer" begin
	@test punctuation_space_tokenize("a b c") == ["a", "b", "c"]
	@test punctuation_space_tokenize("a's b c") == ["a's", "b", "c"]
	@test punctuation_space_tokenize("a b- c") == ["a", "b", "c"]
end




