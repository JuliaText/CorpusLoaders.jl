# CorpusLoaders
[![Docs Latest](https://img.shields.io/badge/docs-latest-blue.svg)](http://white.ucc.asn.au/CorpusLoaders.jl/latest/)

[![Travis Status](https://travis-ci.org/oxinabox/CorpusLoaders.jl.svg?branch=master)](https://travis-ci.org/oxinabox/CorpusLoaders.jl)
[![AppVeyor Status](https://ci.appveyor.com/api/projects/status/bio46qj8ol65bs3e?svg=true)](https://ci.appveyor.com/project/oxinabox/corpusloaders-jl)

[![Coverage Status](https://coveralls.io/repos/oxinabox/CorpusLoaders.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/oxinabox/CorpusLoaders.jl?branch=master)

[![codecov.io](http://codecov.io/github/oxinabox/CorpusLoaders.jl/coverage.svg?branch=master)](http://codecov.io/github/oxinabox/CorpusLoaders.jl?branch=master)


A collection of various means for loading various different corpora used in NLP.




## Corpora
### Common Structure
For some corpus which we will say has tyoe `Corpus`,
it will have a constructior `Corpus(path)` where path is a path to the files describing it.
That path will default to a predefined data depencency, if not proviced.
The Data Dependency will be downloaded the first time you call `Corpus()`.
When the datadep resolves it will givefull bibliograpghic details on the corpus etc.
For more on that and on configure it, see [DataDeps.jl](https://github.com/oxinabox/DataDeps.jl).


Each corpus has a function `load(::Corpus)`.
This will return some iterator of data.
It is often lazy, e.g. using a `Channel`, as many corpora are too large to fit in memory comfortably.
It will often be an iterator of iterators of iterators ...
Designed to be manipulated by using [MultiResolutionIterators.jl](https://github.com/oxinabox/MultiResolutionIterators.jl).
The corpus type is an indexer for using named levels with MultiResolutionInterators.jl.
so `lvls(Corpus, :para)` works.


### WikiCorpus

Very commonly used corpus in general.
The loader (and default datadep) is for [Samuel Reese's 2006 based corpus](http://www.lsi.upc.edu/~nlp/wikicorpus/).
The only real feature we rely on the input having is the `<doc title="DocTitle"..>` tags seperating the documents.
So any corpus following close-enough to that should work.

We capture a lot of structure.
Document, section, paragaph/line, sentence, word.
Note that paragaph/line level does not differnetiate between a paragraph of prose, vs a line in a list.

Most users are not going to be wanting that level of structure,
so should use `merge_levels` (from MultiResolutionIterators.jl)  to get rid of levels they don't want.



Example:

```
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

julia> merge_levels(subcorpus, (!lvls)(WikiCorpus, :word)) |> full_consolidate #Lets just get a series of words
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
