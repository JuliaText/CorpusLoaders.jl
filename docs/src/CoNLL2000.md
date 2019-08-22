# CoNLL 2000
The CoNLL-2000 shared task was on chunking.
Each word has been tagged for part-of-speech (POS) tag
and its syntactic chunk tag.
The chunk tags are tagged with the BIO1 or IOB format,
[refer](https://en.wikipedia.org/wiki/Inside%E2%80%93outside%E2%80%93beginning_(tagging)).

The CoNLL2000 dataset has `train` and `test` sets of data as follows -

    train = load(CoNLL2000(), "train") # training set
    test = load(CoNLL2000(), "test") # test set

For training dataset one can also simply use

    train = load(CoNLL2000())

Structure of each set is - `sentences, words, characters`.

To get the desired levels, `flatten_levels` function from [MultiResolutionIterators.jl](https://github.com/oxinabox/MultiResolutionIterators.jl) can be used.

Following is example to remove sentence boundary.
The dataset reduces to an array of words.

```julia

julia> no_sentence_boundary = flatten_levels(train, lvls(CoNLL2000, :sentence)) |> full_consolidate
Document{Array{CorpusLoaders.POSTaggedWord,1},String}("train.txt", CorpusLoaders.POSTaggedWord[POSTaggedWord("NN", "B-NP", "Confidence"), POSTaggedWord("IN", "B-PP", "in"), POSTaggedWord("DT", "B-NP", "the"), POSTaggedWord("NN", "I-NP", "pound"), POSTaggedWord("VBZ", "B-VP", "is"), POSTaggedWord("RB", "I-VP", "widely"), POSTaggedWord("VBN", "I-VP", "expected"), POSTaggedWord("TO", "I-VP", "to"), POSTaggedWord("VB", "I-VP", "take"), POSTaggedWord("DT", "B-NP", "another")  …  POSTaggedWord("NNS", "I-NP", "victims"), POSTaggedWord(",", "O", ","), POSTaggedWord("CC", "O", "and"), POSTaggedWord("VBG", "B-VP", "sending"), POSTaggedWord("PRP", "B-NP", "them"), POSTaggedWord("TO", "B-PP", "to"), POSTaggedWord("NNP", "B-NP", "San"), POSTaggedWord("NNP", "I-NP", "Francisco"), POSTaggedWord("RB", "B-ADVP", "instead"), POSTaggedWord(".", "O", ".")])

julia> typeof(no_sentence_boundary)
Document{Array{CorpusLoaders.POSTaggedWord,1},String}

julia> collect(no_sentence_boundary)
211727-element Array{Any,1}:
 CorpusLoaders.POSTaggedWord("NN", "B-NP", "Confidence")
 CorpusLoaders.POSTaggedWord("IN", "B-PP", "in")
 CorpusLoaders.POSTaggedWord("DT", "B-NP", "the")
 CorpusLoaders.POSTaggedWord("NN", "I-NP", "pound")
 CorpusLoaders.POSTaggedWord("VBZ", "B-VP", "is")
 CorpusLoaders.POSTaggedWord("RB", "I-VP", "widely")
 CorpusLoaders.POSTaggedWord("VBN", "I-VP", "expected")
 CorpusLoaders.POSTaggedWord("TO", "I-VP", "to")
 CorpusLoaders.POSTaggedWord("VB", "I-VP", "take")
 CorpusLoaders.POSTaggedWord("DT", "B-NP", "another")
 ⋮
 CorpusLoaders.POSTaggedWord(",", "O", ",")
 CorpusLoaders.POSTaggedWord("CC", "O", "and")
 CorpusLoaders.POSTaggedWord("VBG", "B-VP", "sending")
 CorpusLoaders.POSTaggedWord("PRP", "B-NP", "them")
 CorpusLoaders.POSTaggedWord("TO", "B-PP", "to")
 CorpusLoaders.POSTaggedWord("NNP", "B-NP", "San")
 CorpusLoaders.POSTaggedWord("NNP", "I-NP", "Francisco")
 CorpusLoaders.POSTaggedWord("RB", "B-ADVP", "instead")
 CorpusLoaders.POSTaggedWord(".", "O", ".")

```

Accessing the tag could simply be done on the word level using

    part_of_speech(tagged_word)

```julia

julia> for tagged_word in train[16]
           pos_tag = part_of_speech(tagged_word)
           w = word(tagged_word)
           println("$w => $pos_tag")
       end
Meanwhile => RB
, => ,
overall => JJ
evidence => NN
on => IN
the => DT
economy => NN
remains => VBZ
fairly => RB
clouded => VBN
. => .

```
