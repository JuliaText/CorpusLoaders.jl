## CoNLL 2003
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
Document{Array{Array{NERTaggedWord,1},1},String}

julia> no_sent_boundary[1]
469-element Array{NERTaggedWord,1}:
 NERTaggedWord("B-ORG", "B-NP", "NNP", "EU")
 NERTaggedWord("O", "B-VP", "VBZ", "rejects")
 NERTaggedWord("B-MISC", "B-NP", "JJ", "German")
 NERTaggedWord("O", "I-NP", "NN", "call")
 NERTaggedWord("O", "B-VP", "TO", "to")
 NERTaggedWord("O", "I-VP", "VB", "boycott")
 NERTaggedWord("B-MISC", "B-NP", "JJ", "British")
 NERTaggedWord("O", "I-NP", "NN", "lamb")
 NERTaggedWord("O", "O", ".", ".")
 NERTaggedWord("B-PER", "B-NP", "NNP", "Peter")
 NERTaggedWord("I-PER", "I-NP", "NNP", "Blackburn")
 NERTaggedWord("B-LOC", "B-NP", "NNP", "BRUSSELS")
 NERTaggedWord("O", "I-NP", "CD", "1996-08-22")
 NERTaggedWord("O", "B-NP", "DT", "The")
 NERTaggedWord("B-ORG", "I-NP", "NNP", "European")
 NERTaggedWord("I-ORG", "I-NP", "NNP", "Commission")
 NERTaggedWord("O", "B-VP", "VBD", "said")
 NERTaggedWord("O", "B-PP", "IN", "on")
 NERTaggedWord("O", "B-NP", "NNP", "Thursday")
 NERTaggedWord("O", "B-NP", "PRP", "it")
 NERTaggedWord("O", "B-VP", "VBD", "disagreed")
 NERTaggedWord("O", "B-PP", "IN", "with")
 NERTaggedWord("B-MISC", "B-NP", "JJ", "German")
 NERTaggedWord("O", "I-NP", "NN", "advice")
 NERTaggedWord("O", "B-PP", "TO", "to")
 ⋮
 NERTaggedWord("O", "B-NP", "JJ", "last")
 NERTaggedWord("O", "I-NP", "NN", "year")
 NERTaggedWord("O", "O", ",", ",")
 NERTaggedWord("O", "B-NP", "RB", "nearly")
 NERTaggedWord("O", "I-NP", "NN", "half")
 NERTaggedWord("O", "B-PP", "IN", "of")
 NERTaggedWord("O", "B-NP", "JJ", "total")
 NERTaggedWord("O", "I-NP", "NNS", "imports")
 NERTaggedWord("O", "O", ".", ".")
 NERTaggedWord("O", "B-NP", "PRP", "It")
 NERTaggedWord("O", "B-VP", "VBD", "brought")
 NERTaggedWord("O", "B-PP", "IN", "in")
 NERTaggedWord("O", "B-NP", "CD", "4,275")
 NERTaggedWord("O", "I-NP", "NNS", "tonnes")
 NERTaggedWord("O", "B-PP", "IN", "of")
 NERTaggedWord("B-MISC", "B-NP", "JJ", "British")
 NERTaggedWord("O", "I-NP", "NN", "mutton")
 NERTaggedWord("O", "O", ",", ",")
 NERTaggedWord("O", "B-NP", "DT", "some")
 NERTaggedWord("O", "I-NP", "CD", "10")
 NERTaggedWord("O", "I-NP", "NN", "percent")
 NERTaggedWord("O", "B-PP", "IN", "of")
 NERTaggedWord("O", "B-NP", "JJ", "overall")
 NERTaggedWord("O", "I-NP", "NNS", "imports")
 NERTaggedWord("O", "O", ".", ".")
```

Similarly we can flatten_levels at the document level
to get a set of sentences of tagged words.

```julia
julia> dataset = flatten_levels(train, lvls(CoNLL, :sentence)) |> full_consolidate

julia> typeof(dataset)
Document{Array{Array{TaggedWord,1},1},String}

julia> length(dataset) # Total number of sentences.
14041

julia> dataset[1]
9-element Array{TaggedWord,1}:
 NERTaggedWord("B-ORG", "B-NP", "NNP", "EU")
 NERTaggedWord("O", "B-VP", "VBZ", "rejects")
 NERTaggedWord("B-MISC", "B-NP", "JJ", "German")
 NERTaggedWord("O", "I-NP", "NN", "call")
 NERTaggedWord("O", "B-VP", "TO", "to")
 NERTaggedWord("O", "I-VP", "VB", "boycott")
 NERTaggedWord("B-MISC", "B-NP", "JJ", "British")
 NERTaggedWord("O", "I-NP", "NN", "lamb")
 NERTaggedWord("O", "O", ".", ".")
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
