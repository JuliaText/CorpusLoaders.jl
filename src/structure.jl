# Tools for joining MultiResolutionIterators with Corpora
#=
Corpora must impliment

levels(::Corpus)::Vector{Pair{Symbol, Int}}
The returned vector maps Named levels to their numbers
Multiple names can be given to the name nmbered level (Many to One)
=#


exclude_levels(corpus) = unique(last.(levels(corpus)))


function exclude_levels(corpus, nums::VarArg{<:Integer})
    all_levels = exclude_levels(corpus)
    set_diff(all_levels, nums)
    # all the levels, except the ones we are excluding
end

function exclude_levels(corpus, names::VarArg{Symbol})
    exclude_levels(corpus, include_levels(corpus, names))
end

include_levels(corpus) = Int[]

include_levels(corpus, nums::VarArg{<:Integer}) = nums

function include_levels(corpus, names::VarArg{Symbol})
    inds = findin(names, first.(levels(corpus)))
    level_nums = last.(levels(corpus)[inds])
    include_levels(corpus, level_nums...)
end
