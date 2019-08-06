# CorpusLoaders.jl

A collection of various means for loading various different corpora used in NLP.

## Installation

    pkg> add https://github.com/JuliaText/CorpusLoaders.jl

## Common Structure

For some corpus which we will say has type `Corpus`,
it will have a constructior `Corpus(path)``
where `path` argument is a path to the files describing it.
That path will default to a predefined data dependency, if not provided.
The data dependency will be downloaded the first time you call `Corpus()`.
When the datadep resolves it will give full bibliograpghic details on the corpus etc.
For more on that like configuration details, see [DataDeps.jl](https://github.com/oxinabox/DataDeps.jl).

Each corpus has a function `load(::Corpus)`.
This will return some iterator of data.
It is often lazy, e.g. using a `Channel`,
as many corpora are too large to fit in memory comfortably.
It will often be an iterator of iterators of iterators ...
Designed to be manipulated by using [MultiResolutionIterators.jl](https://github.com/oxinabox/MultiResolutionIterators.jl).
The corpus type is an indexer for using named levels with MultiResolutionInterators.jl,
so `lvls(Corpus, :para)` works
