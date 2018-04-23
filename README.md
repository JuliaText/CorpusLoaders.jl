# CorpusLoaders
[![Docs Latest](https://img.shields.io/badge/docs-latest-blue.svg)](http://white.ucc.asn.au/CorpusLoaders.jl/latest/)

[![Travis Status](https://travis-ci.org/oxinabox/CorpusLoaders.jl.svg?branch=master)](https://travis-ci.org/oxinabox/CorpusLoaders.jl)
[![AppVeyor Status](https://ci.appveyor.com/api/projects/status/bio46qj8ol65bs3e?svg=true)](https://ci.appveyor.com/project/oxinabox/corpusloaders-jl)

[![Coverage Status](https://coveralls.io/repos/oxinabox/CorpusLoaders.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/oxinabox/CorpusLoaders.jl?branch=master)

[![codecov.io](http://codecov.io/github/oxinabox/CorpusLoaders.jl/coverage.svg?branch=master)](http://codecov.io/github/oxinabox/CorpusLoaders.jl?branch=master)


A collection of various means for loading various different corpora used in NLP.





## Common Structure
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

## Corpora
 - [WikiCorpus](docs/src/WikiCorpus.md)
 - [SemCor](docs/src/SemCor.md)
