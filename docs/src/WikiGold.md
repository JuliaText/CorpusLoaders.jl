# WikiGold

WikiGold is a manually annotated corpus for named entity recognition
made up of a small sample of Wikipedia articles.
The words have been labelled for each of the four CONLL-03 Named Enitty classes (LOC, MISC, ORG, PER).

The named entity tags are tagged
with the BIO1 or IOB format,
[refer](https://en.wikipedia.org/wiki/Inside%E2%80%93outside%E2%80%93beginning_(tagging)).

One can load the dataset using -

    dataset = load(WikiGold())

Structure of each set is - `document, sentences, words, characters`.

```julia

julia> typeof(dataset)
Document{Array{Array{Array{CorpusLoaders.NerOnlyTaggedWord,1},1},1},String}

julia>

```

To get the desired levels, `flatten_levels` function from [MultiResolutionIterators.jl](https://github.com/oxinabox/MultiResolutionIterators.jl) can be used.

Following is example to remove sentence boundary.
The document contain only a sequence of words.

```julia
julia> using MultiResolutionIterators

julia> no_sent_boundary = flatten_levels(dataset, lvls(WikiGold, :sentence)) |> full_consolidate

julia> typeof(no_sent_boundary)
Document{Array{Array{CorpusLoaders.NerOnlyTaggedWord,1},1},String}

julia> no_sent_boundary[1]
142-element Array{CorpusLoaders.NerOnlyTaggedWord,1}:
 CorpusLoaders.NerOnlyTaggedWord("I-MISC", "010")
 CorpusLoaders.NerOnlyTaggedWord("O", "is")
 CorpusLoaders.NerOnlyTaggedWord("O", "the")
 CorpusLoaders.NerOnlyTaggedWord("O", "tenth")
 CorpusLoaders.NerOnlyTaggedWord("O", "album")
 CorpusLoaders.NerOnlyTaggedWord("O", "from")
 CorpusLoaders.NerOnlyTaggedWord("I-MISC", "Japanese")
 CorpusLoaders.NerOnlyTaggedWord("O", "Punk")
 ⋮
 CorpusLoaders.NerOnlyTaggedWord("O", "and")
 CorpusLoaders.NerOnlyTaggedWord("O", "most")
 CorpusLoaders.NerOnlyTaggedWord("O", "of")
 CorpusLoaders.NerOnlyTaggedWord("O", "the")
 CorpusLoaders.NerOnlyTaggedWord("O", "tracks")
 CorpusLoaders.NerOnlyTaggedWord("O", "were")
 CorpusLoaders.NerOnlyTaggedWord("O", "re-engineered")
 CorpusLoaders.NerOnlyTaggedWord("O", ".")
```

Similarly we can flatten_levels at the document level
to get a set of sentences of tagged words.

```julia
julia> my_dataset = flatten_levels(dataset, lvls(WikiGold, :document)) |> full_consolidate

julia> typeof(my_dataset)
Document{Array{Array{CorpusLoaders.NerOnlyTaggedWord,1},1},String}

julia> length(my_dataset) # Gives us total number of sentences
1696


julia> my_dataset[1]
15-element Array{CorpusLoaders.NerOnlyTaggedWord,1}:
 CorpusLoaders.NerOnlyTaggedWord("I-MISC", "010")
 CorpusLoaders.NerOnlyTaggedWord("O", "is")
 CorpusLoaders.NerOnlyTaggedWord("O", "the")
 CorpusLoaders.NerOnlyTaggedWord("O", "tenth")
 CorpusLoaders.NerOnlyTaggedWord("O", "album")
 CorpusLoaders.NerOnlyTaggedWord("O", "from")
 CorpusLoaders.NerOnlyTaggedWord("I-MISC", "Japanese")
 CorpusLoaders.NerOnlyTaggedWord("O", "Punk")
 CorpusLoaders.NerOnlyTaggedWord("O", "Techno")
 CorpusLoaders.NerOnlyTaggedWord("O", "band")
 CorpusLoaders.NerOnlyTaggedWord("I-ORG", "The")
 CorpusLoaders.NerOnlyTaggedWord("I-ORG", "Mad")
 CorpusLoaders.NerOnlyTaggedWord("I-ORG", "Capsule")
 CorpusLoaders.NerOnlyTaggedWord("I-ORG", "Markets")
 CorpusLoaders.NerOnlyTaggedWord("O", ".")

```

Accessing the tag could simply be done on the word level using

    CorpusLoaders.named_entity(tagged_word)

```julia

julia> ner_tag = CorpusLoaders.named_entity.(my_dataset[22])
14-element Array{String,1}:
 "O"
 "O"
 "O"
 "O"
 "O"
 "O"
 "O"
 "O"
 "O"
 "O"
 "O"
 "O"
 "I-LOC"
 "O"

julia> ws = word.(my_dataset[22])
14-element Array{String,1}:
 "By"
 "December"
 "1864"
 ","
 "they"
 "were"
 "back"
 "in"
 "the"
 "siege"
 "lines"
 "of"
 "Petersburg"
 "."

julia> collect(zip(ws, ner_tag))
14-element Array{Tuple{String,String},1}:
 ("By", "O")
 ("December", "O")
 ("1864", "O")
 (",", "O")
 ("they", "O")
 ("were", "O")
 ("back", "O")
 ("in", "O")
 ("the", "O")
 ("siege", "O")
 ("lines", "O")
 ("of", "O")
 ("Petersburg", "I-LOC")
 (".", "O")

```
