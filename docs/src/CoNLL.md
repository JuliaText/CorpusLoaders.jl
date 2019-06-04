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
Document{Array{Array{CoNLL2003TaggedWord,1},1},String}

julia> no_sent_boundary[1]
469-element Array{CoNLL2003TaggedWord,1}:
 CoNLL2003TaggedWord("B-ORG", "B-NP", "NNP", "EU")
 CoNLL2003TaggedWord("O", "B-VP", "VBZ", "rejects")
 CoNLL2003TaggedWord("B-MISC", "B-NP", "JJ", "German")
 CoNLL2003TaggedWord("O", "I-NP", "NN", "call")
 CoNLL2003TaggedWord("O", "B-VP", "TO", "to")
 CoNLL2003TaggedWord("O", "I-VP", "VB", "boycott")
 CoNLL2003TaggedWord("B-MISC", "B-NP", "JJ", "British")
 CoNLL2003TaggedWord("O", "I-NP", "NN", "lamb")
 CoNLL2003TaggedWord("O", "O", ".", ".")
 CoNLL2003TaggedWord("B-PER", "B-NP", "NNP", "Peter")
 CoNLL2003TaggedWord("I-PER", "I-NP", "NNP", "Blackburn")
 CoNLL2003TaggedWord("B-LOC", "B-NP", "NNP", "BRUSSELS")
 CoNLL2003TaggedWord("O", "I-NP", "CD", "1996-08-22")
 CoNLL2003TaggedWord("O", "B-NP", "DT", "The")
 CoNLL2003TaggedWord("B-ORG", "I-NP", "NNP", "European")
 CoNLL2003TaggedWord("I-ORG", "I-NP", "NNP", "Commission")
 CoNLL2003TaggedWord("O", "B-VP", "VBD", "said")
 CoNLL2003TaggedWord("O", "B-PP", "IN", "on")
 CoNLL2003TaggedWord("O", "B-NP", "NNP", "Thursday")
 CoNLL2003TaggedWord("O", "B-NP", "PRP", "it")
 CoNLL2003TaggedWord("O", "B-VP", "VBD", "disagreed")
 CoNLL2003TaggedWord("O", "B-PP", "IN", "with")
 CoNLL2003TaggedWord("B-MISC", "B-NP", "JJ", "German")
 CoNLL2003TaggedWord("O", "I-NP", "NN", "advice")
 CoNLL2003TaggedWord("O", "B-PP", "TO", "to")
 ⋮
 CoNLL2003TaggedWord("O", "B-NP", "JJ", "last")
 CoNLL2003TaggedWord("O", "I-NP", "NN", "year")
 CoNLL2003TaggedWord("O", "O", ",", ",")
 CoNLL2003TaggedWord("O", "B-NP", "RB", "nearly")
 CoNLL2003TaggedWord("O", "I-NP", "NN", "half")
 CoNLL2003TaggedWord("O", "B-PP", "IN", "of")
 CoNLL2003TaggedWord("O", "B-NP", "JJ", "total")
 CoNLL2003TaggedWord("O", "I-NP", "NNS", "imports")
 CoNLL2003TaggedWord("O", "O", ".", ".")
 CoNLL2003TaggedWord("O", "B-NP", "PRP", "It")
 CoNLL2003TaggedWord("O", "B-VP", "VBD", "brought")
 CoNLL2003TaggedWord("O", "B-PP", "IN", "in")
 CoNLL2003TaggedWord("O", "B-NP", "CD", "4,275")
 CoNLL2003TaggedWord("O", "I-NP", "NNS", "tonnes")
 CoNLL2003TaggedWord("O", "B-PP", "IN", "of")
 CoNLL2003TaggedWord("B-MISC", "B-NP", "JJ", "British")
 CoNLL2003TaggedWord("O", "I-NP", "NN", "mutton")
 CoNLL2003TaggedWord("O", "O", ",", ",")
 CoNLL2003TaggedWord("O", "B-NP", "DT", "some")
 CoNLL2003TaggedWord("O", "I-NP", "CD", "10")
 CoNLL2003TaggedWord("O", "I-NP", "NN", "percent")
 CoNLL2003TaggedWord("O", "B-PP", "IN", "of")
 CoNLL2003TaggedWord("O", "B-NP", "JJ", "overall")
 CoNLL2003TaggedWord("O", "I-NP", "NNS", "imports")
 CoNLL2003TaggedWord("O", "O", ".", ".")
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
 CoNLL2003TaggedWord("B-ORG", "B-NP", "NNP", "EU")
 CoNLL2003TaggedWord("O", "B-VP", "VBZ", "rejects")
 CoNLL2003TaggedWord("B-MISC", "B-NP", "JJ", "German")
 CoNLL2003TaggedWord("O", "I-NP", "NN", "call")
 CoNLL2003TaggedWord("O", "B-VP", "TO", "to")
 CoNLL2003TaggedWord("O", "I-VP", "VB", "boycott")
 CoNLL2003TaggedWord("B-MISC", "B-NP", "JJ", "British")
 CoNLL2003TaggedWord("O", "I-NP", "NN", "lamb")
 CoNLL2003TaggedWord("O", "O", ".", ".")
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
