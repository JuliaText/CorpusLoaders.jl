module CorpusLoaders

typealias AbstractStringVector AbstractVector
#typealias AbstractStringVector{S<:AbstractString} AbstractVector{S}

include("util.jl")

include("tokenizers.jl")
include("tags.jl")
include("semcor.jl")
include("semeval2007t7.jl")
include("./similarity.jl")

end # module
