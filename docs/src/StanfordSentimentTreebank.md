# StanfordSentimentTreebank

This contains sentiment part of famous dataset Stanford Sentiment Treebank V1.0 for [Recursive Deep Models for Semantic Compositionality Over a Sentiment Treebank](https://nlp.stanford.edu/~socherr/EMNLP2013_RNTN.pdf) paper by Richard Socher, Alex Perelygin, Jean Wu, Jason Chuang, Christopher Manning, Andrew Ng and Christopher Potts.
The dataset gives the phases with their sentiment labels between 0 to 1. This dataset can be used as binary or fine-grained sentiment classification problems.

Structure of dataset:
documents/tweets, sentences, words, characters

To get desired levels, `flatten_levels` function from [MultiResolutionIterators.jl](https://github.com/oxinabox/MultiResolutionIterators.jl) can be used.

## Usage

The output dataset is a 2-dimensional `Array` with first column as `Vector`s of sentences as tokens and second column as their respective sentiment scores.

```julia
julia> dataset = load(StanfordSentimentTreebank())
239232×2 Array{Any,2}:
 Array{String,1}[["!"]]
             …  0.5
 Array{String,1}[["!"], ["'"]]
                0.52778
 Array{String,1}[["!"], ["'", "'"]]
                0.5
 Array{String,1}[["!"], ["Alas"]]
                0.44444
 Array{String,1}[["!"], ["Brilliant"]]
                0.86111
 Array{String,1}[["!"], ["Brilliant", "!"]]
             …  0.93056
 Array{String,1}[["!"], ["Brilliant", "!"], ["'"]]
                1.0
 Array{String,1}[["!"], ["C", "'", "mon"]]
                0.47222
 Array{String,1}[["!"], ["Gollum", "'", "s", "`", "performance", "'", "is", "incredible"]]
                0.76389
 Array{String,1}[["!"], ["Oh", ",", "look", "at", "that", "clever", "angle", "!"], ["Wow", ",", "a", "jump", "cut", "!"]]
                0.27778
 Array{String,1}[["!"], ["Romething"]]
             …  0.5
 Array{String,1}[["!"], ["Run"]]
                0.43056
 Array{String,1}[["!"], ["The", "Movie"]]
                0.5
 Array{String,1}[["!"], ["The", "camera", "twirls", "!"], ["Oh", ",", "look", "at", "that", "clever", "angle", "!"], ["Wow", ",", "a", "jump", "cut", "!"]]
                0.22222
 Array{String,1}[["!"], ["True", "Hollywood", "Story"]]
                0.55556
 Array{String,1}[["!"], ["Wow"]]
             …  0.77778
 ⋮ …

```

### To get phrases from `data`:

```julia
julia> phrases = dataset[1:5, 1]       #Here `data1`is a 2-D Array
5-element Array{Any,1}:
 Array{String,1}[["!"]]
 Array{String,1}[["!"], ["'"]]
 Array{String,1}[["!"], ["'", "'"]]
 Array{String,1}[["!"], ["Alas"]]
 Array{String,1}[["!"], ["Brilliant"]]
```

### To get sentiments values:

```julia
julia> values = data[1:5, 2]          #Here "data" is a 2-D Array
5-element Array{Any,1}:
 0.5
 0.52778
 0.5
 0.44444
 0.86111
```

### Using `flatten_levels`

To get an `Array` of all sentences from all the `phrases` (since each phrase can contain more than one sentence):

```julia
julia> sentences = flatten_levels(phrases, (lvls)(StanfordSentimentTreebank, :documents))|>full_consolidate
9-element Array{Array{String,1},1}:
 ["!"]
 ["!"]
 ["'"]
 ["!"]
 ["'", "'"]
 ["!"]
 ["Alas"]
 ["!"]
 ["Brilliant"]
```

To get `Array` of all the from `phrases`:

```julia
julia> words = flatten_levels(phrases, (!lvls)(StanfordSentimentTreebank, :words))|>full_consolidate
10-element Array{String,1}:
 "!"
 "!"
 "'"
 "!"
 "'"
 "'"
 "!"
 "Alas"
 "!"
 "Brilliant"
```

Similarily, desired manipulation can be done the levels using `flatten_levels`.
