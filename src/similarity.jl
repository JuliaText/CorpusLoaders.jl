module Similarity
export load_wordsim353, load_scws


macro declare_loaders(funcname, filename)
    fnamestr = string(funcname)
    quote
        """
		Load from file. E.g. $($fnamestr)($($filename))
		"""
        $funcname(filename) = open($funcname, filename,"r")
    end|>esc
end

@declare_loaders load_wordsim353 "wordsim353/combined.csv"

"""
Load a WordSim353 dataset.
Returns a 2-tuple.
 - wordpairs: a \(n\times2\) matrix of words (strings)
 - groundsim: a \(n\) vector of floats, between 0 and 10.0.  The human rating on similarity of the words. 10.0 means identical.
This loading method does not make the per rater similarity ratings available. It could reasonabled by extended to do so.
"""
function load_wordsim353(io::IO)
    wordsims = readdlm(io, ','; skipstart=1)
    wordpairs = convert(Matrix{String},wordsims[:,1:2])
    groundsim = convert(Vector{Float64},wordsims[:,3])
    (wordpairs, groundsim)
end



@declare_loaders load_scws "SCWS/ratings.txt"

"""
Load the Stanford's Contextual Word Similarities (SCWS) dataset.
[Download](http://www-nlp.stanford.edu/~ehhuang/SCWS.zip)
Returns a 4-tuple.
 - wordpairs: a \(n\times 2\) matrix of the target words (strings)
 - groundsim: a \(n\) vector of floats, between 0 and 10.0. This is the average human rating on similarity of the words. 10.0 means identical.
 This loading method does not make the per rater similarity ratings available. It could reasonabled by extended to do so.
 - contexts: a \(n\times 2\) maxtrix of vectors of words (strings). With target word removed from each.
 - indexes: a \(n\times 2\) matrix of integers, which have the index from which the target word was removed.
"""
function load_scws(io::IO)
    function get_context_and_index(fulltext)
        context = Vector{SubString}()
        index = -1
        skip_next = 0
        for (ii, word) in enumerate(split(fulltext, ' '))
            skip_next-=1
            if word == "<b>"
                @assert index == -1
                index = ii
                skip_next=3
            end
            skip_next>0 && continue
            push!(context, word)
        end
        context, index
    end
    entries = readdlm(io, '\t', String; quotes=false, comments=false)
    wordpairs = entries[:,[2,4]]
    groundsim = (s->parse(Float64,s)).(entries[:,8])
    vv = get_context_and_index.(entries[:,[6,7]])
    contexts = first.(vv)
    indexes = (x->x[2]).(vv)

    (wordpairs, groundsim, contexts, indexes)
end




end #module
