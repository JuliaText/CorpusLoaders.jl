using Base.Test
using CorpusLoaders


@testset "wordsim353" begin
	egs = """Word 1,Word 2,Human (mean)
tiger,cat,7.35
tiger,tiger,10.00
book,paper,7.46
"""

	wps, sims = load_wordsim353(IOBuffer(egs))
	@test wps == [
			"tiger" "cat"
			"tiger" "tiger"
			"book"  "paper"
			]
	@test sims == [7.35,10.00, 7.46]

end

@testset "SCWS" begin
	eg ="""1	Brazil	n	nut	n	income in the <b> Brazil </b> the philosophy	neck the <b> nut </b> a thin tension	1.1	0.0	3.0	0.0	0.0	0.0	0.0	2.0	6.0	0.0	0.0
2	Brazil	n	triple	n	being elected <b> Brazil </b> Germany	A Pythagorean <b> triple </b> consists integers	0.6	2.0	0.0	0.0	0.0	0.0	4.0	0.0	0.0	0.0	0.0
"""
	wps, sims, contexts, indexes = load_scws(IOBuffer(eg))
	@test wps == [
				"Brazil" "nut"
				"Brazil" "triple"
				]
	@test sims == [1.1, 0.6]
	@test contexts[1,1] == ["income", "in", "the", "the", "philosophy"]
	@test contexts[1,2] == ["neck", "the", "a", "thin", "tension"]
	@test contexts[2,1] == ["being", "elected", "Germany"]
	@test contexts[2,2] == ["A", "Pythagorean", "consists", "integers"]	
	@test indexes == [4 3; 3 3]
end

