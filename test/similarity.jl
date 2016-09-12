using CorpusLoaders.Similarity

@testset "wordsim353" begin
	egs = """Word 1,Word 2,Human (mean)
tiger,cat,7.35
tiger,tiger,10.00
book,paper,7.46
"""

	wps, sims = load_wordsim353(IOBuffer(egs))
	@test wps == ["tiger" "cat"
				  "tiger" "tiger"
				  "book"  "paper"]
	@test sims == [7.35,10.00, 7.46]

end
