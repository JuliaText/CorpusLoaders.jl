# Twitter

Twitter sentiment dataset by Nick Sanders. Downloaded from [Sentiment140 site](http://help.sentiment140.com/for-students).
It is large dataset for the Sentiment Analysis task. Every tweets falls in either three categories positive(4), negative(0) or neutral(2).It contains 1600000 training examples and 498 testing examples.

Structure of dataset:
documents/tweets, sentences, words, characters

This whole dataset is divided into four categories which can accessed by giving corresponding keywords: <br>
`train_pos`   :   positive polarity sentiment train set examples (default) <br>
`train_neg`   :   negative polarity sentiment train set examples <br>
`test_pos`    :   positive polarity sentiment test set examples <br>
`test_neg`    :   negative polarity sentiment test set examples <br>

To get rid of unwanted levels, `flatten_levels` function from [MultiResolutionIterators.jl](https://github.com/oxinabox/MultiResolutionIterators.jl) can be used.

Example:

#Using "test_pos" keyword for getting positive polarity sentiment examples

```julia
julia> dataset_test_pos = load(Twitter("test_pos"))
Channel{Array{Array{String,1},1}}(sz_max:4,sz_curr:4)

julia> using Base.Iterators

julia> tweets = collect(take(dataset_test_pos, 2))
2-element Array{Array{Array{String,1},1},1}:
 [["@", "stellargirl", "I", "loooooooovvvvvveee", "my", "Kindle", "2", "."], ["Not", "that", "the", "DX", "is", "cool", ",", "but", "the", "2", "is", "fantastic", "in", "its", "own", "right", "."]]
 [["Reading", "my", "kindle", "2", "..", "."], ["Love", "it..", "."], ["Lee", "childs", "is", "good", "read", "."]]

 julia> flatten_levels(tweets, (!lvls)(Twitter, :words))|>full_consolidate
40-element Array{String,1}:
 "@"
 "stellargirl"
 "I"
 "loooooooovvvvvveee"
 "my"
 "Kindle"
 "2"
 "."
 "Not"
 "that"
 "the"
 "DX"
 "is"
 "cool"
 ","
 "but"
 ⋮
 "Reading"
 "my"
 "kindle"
 "2"
 ".."
 "."
 "Love"
 "it.."
 "."
 "Lee"
 "childs"
 "is"
 "good"
 "read"
 "."
```

#Using "train_pos" category to get positive polarity sentiment examples

```julia
julia> dataset_train_pos = load(Twitter()) #no need to specify category because "train_pos" is default
Channel{Array{Array{String,1},1}}(sz_max:4,sz_curr:4)

julia> using Base.Iterators

julia> tweets = collect(take(dataset_train_pos, 4))
4-element Array{Array{Array{String,1},1},1}:
[["I", "LOVE", "@", "Health", "4", "UandPets", "u", "guys", "r", "the", "best", "!", "!"]]
[["im", "meeting", "up", "with", "one", "of", "my", "besties", "tonight", "!"], ["Cant", "wait", "!", "!"], ["-", "GIRL", "TALK", "!", "!"]]
[["@", "DaRealSunisaKim", "Thanks", "for", "the", "Twitter", "add", ",", "Sunisa", "!"],
["I", "got", "to", "meet", "you", "once", "at", "a", "HIN", "show"  …  "in", "the", "DC", "area", "and", "you", "were", "a", "sweetheart", "."]]
[["Being", "sick", "can", "be", "really", "cheap", "when", "it", "hurts", "too"  …  "eat", "real", "food", "Plus", ",", "your", "friends", "make", "you", "soup"]]

julia> flatten_levels(tweets, (!lvls)(Twitter, :words))|>full_consolidate
85-element Array{String,1}: "I" "LOVE" "@" "Health"
 "4"
 "UandPets"
 "u"
 "guys"
 "r"
 "the"
 "best"
 "!"
 "!"
 "im"
 "meeting"
 "up"
 ⋮
 "it"
 "hurts"
 "too"
 "much"
 "to"
 "eat"
 "real"
 "food"
 "Plus"
 ","
 "your"
 "friends"
 "make"
 "you"
 "soup"

```
