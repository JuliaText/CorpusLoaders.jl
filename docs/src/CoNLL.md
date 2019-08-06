# CoNLL 2003
The CoNLL-2003 shared task data files
is made from the the Reuters Corpus,
is a collection of news wire articles.

Each word has been tagger three labels to it -
a part-of-speech (POS) tag, a syntactic chunk tag and
the named entity tag.
The chunk tags and the named entity tags are tagged
with the BIO1 or IOB format,
[refer](https://en.wikipedia.org/wiki/Inside%E2%80%93outside%E2%80%93beginning_(tagging)).

One can access the various sets of data as follows-

    train = load(CoNLL(), "train") # training set
    test = load(CoNLL(), "test") # test set
    dev = load(CoNLL(), "dev") # dev set

For training dataset one can also simply use

    train = load(CoNLL())

Structure of each set is - `document, sentences, words, characters`.

To get the desired levels, `flatten_levels` function from [MultiResolutionIterators.jl](https://github.com/oxinabox/MultiResolutionIterators.jl) can be used.

Following is example to remove sentence boundary.
The document contain only a sequence of words.

```julia
julia> no_sent_boundary = flatten_levels(train, lvls(CoNLL, :sentence)) |> full_consolidate

julia> typeof(no_sent_boundary)
Document{Array{Array{CorpusLoaders.NERTaggedWord,1},1},String}

julia> no_sent_boundary[1]
469-element Array{CorpusLoaders.NERTaggedWord,1}:
 CorpusLoaders.NERTaggedWord("B-ORG", "B-NP", "NNP", "EU")
 CorpusLoaders.NERTaggedWord("O", "B-VP", "VBZ", "rejects")
 CorpusLoaders.NERTaggedWord("B-MISC", "B-NP", "JJ", "German")
 CorpusLoaders.NERTaggedWord("O", "I-NP", "NN", "call")
 CorpusLoaders.NERTaggedWord("O", "B-VP", "TO", "to")
 CorpusLoaders.NERTaggedWord("O", "I-VP", "VB", "boycott")
 CorpusLoaders.NERTaggedWord("B-MISC", "B-NP", "JJ", "British")
 CorpusLoaders.NERTaggedWord("O", "I-NP", "NN", "lamb")
 CorpusLoaders.NERTaggedWord("O", "O", ".", ".")
 CorpusLoaders.NERTaggedWord("B-PER", "B-NP", "NNP", "Peter")
 ⋮
 CorpusLoaders.NERTaggedWord("O", "I-NP", "NN", "mutton")
 CorpusLoaders.NERTaggedWord("O", "O", ",", ",")
 CorpusLoaders.NERTaggedWord("O", "B-NP", "DT", "some")
 CorpusLoaders.NERTaggedWord("O", "I-NP", "CD", "10")
 CorpusLoaders.NERTaggedWord("O", "I-NP", "NN", "percent")
 CorpusLoaders.NERTaggedWord("O", "B-PP", "IN", "of")
 CorpusLoaders.NERTaggedWord("O", "B-NP", "JJ", "overall")
 CorpusLoaders.NERTaggedWord("O", "I-NP", "NNS", "imports")
 CorpusLoaders.NERTaggedWord("O", "O", ".", ".")
```

Similarly we can flatten_levels at the document level
to get a set of sentences of tagged words.

```julia
julia> dataset = flatten_levels(train, lvls(CoNLL, :document)) |> full_consolidate

julia> typeof(dataset)
Document{Array{Array{CorpusLoaders.NERTaggedWord,1},1},String}

julia> length(dataset) # Total number of sentences.
14041

julia> dataset[1]
9-element Array{CorpusLoaders.NERTaggedWord,1}:
 CorpusLoaders.NERTaggedWord("B-ORG", "B-NP", "NNP", "EU")
 CorpusLoaders.NERTaggedWord("O", "B-VP", "VBZ", "rejects")
 CorpusLoaders.NERTaggedWord("B-MISC", "B-NP", "JJ", "German")
 CorpusLoaders.NERTaggedWord("O", "I-NP", "NN", "call")
 CorpusLoaders.NERTaggedWord("O", "B-VP", "TO", "to")
 CorpusLoaders.NERTaggedWord("O", "I-VP", "VB", "boycott")
 CorpusLoaders.NERTaggedWord("B-MISC", "B-NP", "JJ", "British")
 CorpusLoaders.NERTaggedWord("O", "I-NP", "NN", "lamb")
 CorpusLoaders.NERTaggedWord("O", "O", ".", ".")
```

Accessing the tag could simply be done on the word level using

    CorpusLoaders.named_entity(tagged_word)

```julia
julia> for tagged_word in dataset[1]
           ner_tag = CorpusLoaders.named_entity(tagged_word)
           w = word(tagged_word)
           println("$w => $ner_tag")
       end
EU => B-ORG
rejects => O
German => B-MISC
call => O
to => O
boycott => O
British => B-MISC
lamb => O
. => O
```
