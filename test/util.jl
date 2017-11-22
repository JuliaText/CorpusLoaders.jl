using Base.Test
import CorpusLoaders: window_excluding_center

@testset "Window excluding center" begin
	@test window_excluding_center(5, split("1 2 3 4 5 6 7 8"), 2) == ["4", "6"]
	@test window_excluding_center(5, split("1 2 3 4 5 6 7 8"), 4) == ["3" , "4", "6", "7"]
	@test window_excluding_center(2, split("1 2 3 4 5"), 4) == ["1","3","4"]
	@test window_excluding_center(4, split("1 2 3 4 5"), 4) == ["2","3","5"]
	@test window_excluding_center(5, split("1 2 3 4 5 6 7 8"), typemax(Int)) == split("1 2 3 4 6 7 8")
end

