###SST
This contains sentiment part of famous dataset Stanford Sentiment Treebank V1.0 for [Recursive Deep Models for Semantic Compositionality Over a Sentiment Treebank](https://nlp.stanford.edu/~socherr/EMNLP2013_RNTN.pdf) paper by Richard Socher, Alex Perelygin, Jean Wu, Jason Chuang, Christopher Manning, Andrew Ng and Christopher Potts.
The dataset gives the phases with their sentiment labels between 0 to 1. This dataset can be used as binary or fine-grained sentiment classification problems.

Structure of dataset:
documents/tweets, sentences, words, characters

To get desired levels, `flatten_levels` function from [MultiResolutionIterators.jl](https://github.com/oxinabox/MultiResolutionIterators.jl) can be used.

##Usage:

```
julia> dataset = load(SST())
Channel{Array{Any,1}}(sz_max:4,sz_curr:4)

julia> using Base.Iterators

julia> data = collect(take(dataset, 5))
5-element Array{Array{Any,1},1}:
 [Array{String,1}[["'"]], 0.5]
 [Array{String,1}[["'", "("]], 0.44444] [Array{String,1}[["'", "(", "the", "cockettes"]], 0.5]
 [Array{String,1}[["'", "(", "the", "cockettes", ")"]], 0.42708]
 [Array{String,1}[["'", "(", "the", "cockettes", ")", "provides", "a", "window", "into", "a", "subculture", "hell-bent", "on", "expressing", "itself", "in", "every", "way", "imaginable"]], 0.375]

```

#To convert the `data` from `Array` of `Array` to a 2-D `Array`:

```
julia> data = permutedims(reshape(hcat(data...), (length(data[1]), length(data))))
5×2 Array{Any,2}:
 Array{String,1}[["'"]]
                                                                                         …  0.5
 Array{String,1}[["'", "("]]
                                                                                            0.44444
 Array{String,1}[["'", "(", "the", "cockettes"]]
                                                                                            0.5
 Array{String,1}[["'", "(", "the", "cockettes", ")"]]
                                                                                            0.42708
Array{String,1}[["'", "(", "the", "cockettes", ")", "provides", "a", "window", "into", "a", "subculture", "hell-bent", "on", "expressing", "itself", "in", "every", "way", "imaginable"]]                                                        0.375
```
[hcat](https://docs.julialang.org/en/v1.0/base/arrays/#Base.hcat), [vcat](https://docs.julialang.org/en/v1.0/base/arrays/#Base.vcat), [permutedims](https://docs.julialang.org/en/v1.0/base/arrays/#Base.permutedims) and [reshape](https://docs.julialang.org/en/v1.0/base/arrays/#Base.reshape) can be used in different ways to get desired `Array` shape.

#Using `flatten_levels`;

Getting phrases from `data`:

```
julia> phrases = data[:, 1]       #Here "data" is a 2-D Array
5-element Array{Any,1}:
 Array{String,1}[["'"]]

 Array{String,1}[["'", "("]]

 Array{String,1}[["'", "(", "the", "cockettes"]]

 Array{String,1}[["'", "(", "the", "cockettes", ")"]]

 Array{String,1}[["'", "(", "the", "cockettes", ")", "provides", "a", "window", "into", "a", "subculture", "hell-bent", "on", "expressing", "itself", "in", "every", "way", "imaginable"]]

```

To get sentiments values:

```
julia> values = data[:, 2]          #Here "data" is a 2-D Array
5-element Array{Any,1}:
 0.5
 0.44444
 0.5
 0.42708
 0.375
```

To get an `Array` of all sentences from all the `phrases` (since phrases can contain more than one sentence):

```
julia> sentences = flatten_levels(phrases, (lvls)(SST, :documents))|>full_consolidate
5-element Array{Array{String,1},1}:
 ["'"]

 ["'", "("]

 ["'", "(", "the", "cockettes"]

 ["'", "(", "the", "cockettes", ")"]

 ["'", "(", "the", "cockettes", ")", "provides", "a", "window", "into", "a", "subculture", "hell-bent", "on", "expressing", "itself", "in", "every", "way", "imaginable"]
```

To get `Array` of all the from `phrases`:

```
julia> words = flatten_levels(phrases, (!lvls)(SST, :words))|>full_consolidate
31-element Array{String,1}:
 "'"
 "'"
 "("
 "'"
 "("
 "the"
 "cockettes"
 "'"
 "("
 "the"
 "cockettes"
 ")"
 "'"
 "("
 "the"
 "cockettes"
 ")"
 "provides"
 "a"
 "window"
 "into"
 "a"
 "subculture"
 "hell-bent"
 "on"
 "expressing"
 "itself"
 "in"
 "every"
 "way"
 "imaginable"
```

Similarily, desired manipulation can be done the levels using `flatten_levels`.
