module CorpusLoaders

using LightXML
using DataDeps
using Glob
using BinDeps
using InternedStrings
using StringEncodings

const AbstractStringVector = AbstractVector{<:AbstractString}

function __init__()
    print(DataDeps)
    include("./datadeps.jl")
end


include("util.jl")

include("tokenizers.jl")
include("tags.jl")
include("semcor.jl")
include("semeval2007t7.jl")
include("similarity.jl")
include("wikicorpus.jl")

end # module
