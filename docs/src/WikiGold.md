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
Document{Array{Array{Array{CorpusLoaders.WikiGoldWord,1},1},1},String}

julia>

```

To get the desired levels, `flatten_levels` function from [MultiResolutionIterators.jl](https://github.com/oxinabox/MultiResolutionIterators.jl) can be used.

Following is example to remove sentence boundary.
The document contain only a sequence of words.

```julia
julia> using MultiResolutionIterators

julia> no_sent_boundary = flatten_levels(dataset, lvls(WikiGold, :sentence)) |> full_consolidate

julia> typeof(no_sent_boundary)
Document{Array{Array{CorpusLoaders.WikiGoldWord,1},1},String}

julia> no_sent_boundary[1]
142-element Array{CorpusLoaders.WikiGoldWord,1}:
 CorpusLoaders.WikiGoldWord("I-MISC", "010")
 CorpusLoaders.WikiGoldWord("O", "is")
 CorpusLoaders.WikiGoldWord("O", "the")
 CorpusLoaders.WikiGoldWord("O", "tenth")
 CorpusLoaders.WikiGoldWord("O", "album")
 CorpusLoaders.WikiGoldWord("O", "from")
 CorpusLoaders.WikiGoldWord("I-MISC", "Japanese")
 CorpusLoaders.WikiGoldWord("O", "Punk")
 ⋮
 CorpusLoaders.WikiGoldWord("O", "and")
 CorpusLoaders.WikiGoldWord("O", "most")
 CorpusLoaders.WikiGoldWord("O", "of")
 CorpusLoaders.WikiGoldWord("O", "the")
 CorpusLoaders.WikiGoldWord("O", "tracks")
 CorpusLoaders.WikiGoldWord("O", "were")
 CorpusLoaders.WikiGoldWord("O", "re-engineered")
 CorpusLoaders.WikiGoldWord("O", ".")
```

Similarly we can flatten_levels at the document level
to get a set of sentences of tagged words.

```julia
julia> my_dataset = flatten_levels(dataset, lvls(WikiGold, :document)) |> full_consolidate

julia> typeof(my_dataset)
Document{Array{Array{CorpusLoaders.WikiGoldWord,1},1},String}

julia> length(my_dataset) # Gives us total number of sentences
1696


julia> my_dataset[1]
15-element Array{CorpusLoaders.WikiGoldWord,1}:
 CorpusLoaders.WikiGoldWord("I-MISC", "010")     
 CorpusLoaders.WikiGoldWord("O", "is")           
 CorpusLoaders.WikiGoldWord("O", "the")          
 CorpusLoaders.WikiGoldWord("O", "tenth")        
 CorpusLoaders.WikiGoldWord("O", "album")        
 CorpusLoaders.WikiGoldWord("O", "from")         
 CorpusLoaders.WikiGoldWord("I-MISC", "Japanese")
 CorpusLoaders.WikiGoldWord("O", "Punk")         
 CorpusLoaders.WikiGoldWord("O", "Techno")       
 CorpusLoaders.WikiGoldWord("O", "band")         
 CorpusLoaders.WikiGoldWord("I-ORG", "The")      
 CorpusLoaders.WikiGoldWord("I-ORG", "Mad")      
 CorpusLoaders.WikiGoldWord("I-ORG", "Capsule")  
 CorpusLoaders.WikiGoldWord("I-ORG", "Markets")  
 CorpusLoaders.WikiGoldWord("O", ".")  
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
