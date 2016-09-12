module Similarity
export load_wordsim353


macro declare_loaders(funcname, filename)
    fnamestr = string(funcname)
    quote
        "Load from file. E.g. $($fnamestr)($($filename))"
        $funcname(filename) = open($funcname, filename,"r")
    end|>esc
end

@declare_loaders load_wordsim353 "wordsim353/combined.csv"

"""
Load a WordSim353 dataset.
Returns a 2-tuple.
 - wordpairs: a \(n\times2\) matrix of words (strings)
 - ground sim: a \(n\) vector of floats, between 0 and 10.0.  The human rating on similarity of the words. 10.0 means identical.
"""
function load_wordsim353(io::IO)
    wordsims = readdlm(io, ','; skipstart=1)
    wordpairs = convert(Matrix{String},wordsims[:,1:2])
    groundsim = convert(Vector{Float64},wordsims[:,3])
    (wordpairs, groundsim)
end



end #module
