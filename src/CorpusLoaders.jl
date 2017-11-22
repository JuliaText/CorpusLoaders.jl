module CorpusLoaders

using LightXML
using DataDeps


const AbstractStringVector = AbstractVector{<:AbstractString}

include("util.jl")

include("tokenizers.jl")
include("tags.jl")
include("semcor.jl")
include("semeval2007t7.jl")
include("./similarity.jl")

end # module
