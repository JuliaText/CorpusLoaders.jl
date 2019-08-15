# WikiCorpus

Very commonly used corpus in general.
The loader (and default datadep) is for [Samuel Reese's 2006 based corpus](http://www.lsi.upc.edu/~nlp/wikicorpus/).
The only real feature we rely on the input having is the `<doc title="DocTitle"..>` tags separating the documents.
So any corpus following close-enough to that should work.

We capture a lot of structure.
Document, section, paragraph/line, sentence, word.
Note that paragraph/line level does not differentiate between a paragraph of prose, vs a line in a list.

Most users are not going to be wanting that level of structure,
so should use `flatten_levels` (from MultiResolutionIterators.jl)  to get rid of levels they don't want.



Example:

```julia
julia> using CorpusLoaders;
julia> using MultiResolutionIterators;
julia> using Base.Iterators;

julia> corpus_gen = load(WikiCorpus())
Channel{CorpusLoaders.Document{Array{Array{Array{Array{InternedStrings.InternedString,1},1},1},1},InternedStrings.InternedString}}(sz_max:4,sz_curr:4)

julia> subcorpus = collect(take(corpus_gen, 5));

julia> title.(subcorpus)
5-element Array{InternedStrings.InternedString,1}:
 "Henry Hallam"
 "Sungai Besi LRT station"
 "1808 in poetry"
 "3 Flies Up"
 "Sterling College (Vermont)"

julia> MultiResolutionIterators.levelname_map(WikiCorpus)
8-element Array{Pair{Symbol,Int64},1}:
 :doc=>1
 :section=>2
 :para=>3
 :line=>3
 :sent=>4
 :word=>5
 :token=>5
 :char=>6

julia> flatten_levels(subcorpus, (!lvls)(WikiCorpus, :word)) |> full_consolidate #Lets just get a series of words
27655-element Array{InternedStrings.InternedString,1}:
 "Henry"
 "Hallam"
 "("
 "July"
 "9"
 ","
 "1777"
 "-"
 "January"
 "21"
 ","
 "1859"
 ")"
 "was"
 "an"
 "English"
 "historian"
 ⋮
 "``"
 "I"
 "'m"
 "So"
 "Bad"
 "''"
 "3:49"
 ";"

```
