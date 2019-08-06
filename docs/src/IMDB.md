# IMDB

IMDB movie reviews dataset a standard collection for Binary Sentiment Analysis task. It is used for benchmarking Sentiment Analysis algorithms. It provides a set of 25,000 highly polar movie reviews for training, and 25,000 for testing. There is additional unlabeled data for use as well. Raw text and already processed bag of words formats are provided

Structure of the reviews contain different levels:<br>
documents, sentences, words/tokens, characters

Whole data is divided into 5 parts which can be accessed by providing following keywords: <br>
`train_pos`     : positive polarity sentiment train set examples (default) <br>
`train_neg`     : negative polarity sentiment train set examples <br>
`test_pos`      : positive polarity sentiment test set examples <br>
`test_neg`      : negative polarity sentiment test set examples <br>
`train_unsup`   : unlabeled examples

To get rid of unwanted levels, `flatten_levels` function from [MultiResolutionIterators.jl](https://github.com/oxinabox/MultiResolutionIterators.jl) can be used.


Example:

#Using "test_neg" keywords for negative test set examples

```julia
 julia> dataset_test_neg = load(IMDB("test_neg"))
Channel{Array{Array{String,1},1}}(sz_max:4,sz_curr:4)

julia> docs = collect(take(dataset_test_neg, 2))
2-element Array{Array{Array{String,1},1},1}:
 [["Once", "again", "Mr.", "Costner", "has", "dragged", "out", "a", "movie", "for", "far", "longer", "than", "necessary", "."], ["Aside", "from", "the", "terrific", "sea", "rescue", "sequences", ",", "of", "which"  …  "just", "did", "not", "care", "about", "any", "of", "the", "characters", "."], ["Most", "of", "us", "have", "ghosts", "in", "the", "closet", ",", "and"  …  "later", ",", "by", "which", "time", "I", "did", "not", "care", "."], ["The", "character", "we", "should", "really", "care", "about", "is", "a", "very", "cocky", ",", "overconfident", "Ashton", "Kutcher", "."], ["The", "problem", "is", "he", "comes", "off", "as", "kid", "who", "thinks"  …  "him", "and", "shows", "no", "signs", "of", "a", "cluttered", "closet", "."], ["His", "only", "obstacle", "appears", "to", "be", "winning", "over", "Costner", "."], ["Finally", "when", "we", "are", "well", "past", "the", "half", "way", "point"  …  ",", "Costner", "tells", "us", "all", "about", "Kutcher", "'s", "ghosts", "."], ["We", "are", "told", "why", "Kutcher", "is", "driven", "to", "be", "the", "best", "with", "no", "prior", "inkling", "or", "foreshadowing", "."], ["No", "magic", "here", ",", "it", "was", "all", "I", "could", "do", "to", "keep", "from", "turning", "it", "off", "an", "hour", "in", "."]]
 [["This", "is", "an", "example", "of", "why", "the", "majority", "of", "action", "films", "are", "the", "same", "."], ["Generic", "and", "boring", ",", "there", "'s", "really", "nothing", "worth", "watching", "here", "."], ["A", "complete", "waste", "of", "the", "then", "barely-tapped", "talents", "of", "Ice-T"  …  "they", "are", "capable", "of", "acting", ",", "and", "acting", "well", "."], ["Do", "n't", "bother", "with", "this", "one", ",", "go", "see", "New"  …  "Friday", "for", "Ice", "Cube", "and", "see", "the", "real", "deal", "."], ["Ice-T", "'s", "horribly", "cliched", "dialogue", "alone", "makes", "this", "film", "grate"  …  "the", "heck", "Bill", "Paxton",
"was", "doing", "in", "this", "film", "?"], ["And", "why", "the", "heck", "does", "he", "always", "play", "the", "exact", "same", "character", "?"], ["From", "Aliens", "onward", ",", "every", "film", "I", "'ve", "seen", "with"  …  "><br", "/", ">Overall", ",", "this", "is", "second-rate", "action", "trash", "."], ["There", "are", "countless", "better", "films", "to", "see", ",", "and", "if"  …  "copy", "but", "has", "better", "acting", "and", "a", "better", "script", "."], ["The", "only", "thing", "that", "made", "this", "at", "all", "worth", "watching"  …  "for", "the", "horrible", "film", "itself", "-", "but", "not", "quite", "."], ["4", "/", "10", "."]]
```

#Using "train_pos" keyword for positive train set examples

```julia
julia> dataset_train_pos = load(IMDB())   #no need to specify category because "train_pos" is default
Channel{Array{Array{String,1},1}}(sz_max:4,sz_curr:4)

julia> using Base.Iterators

julia> docs = collect(take(dataset_train_pos, 2))
2-element Array{Array{Array{String,1},1},1}:
 [["Bromwell", "High", "is", "a", "cartoon", "comedy", "."], ["It", "ran", "at", "the", "same", "time", "as", "some", "other", "programs", "about", "school", "life", ",", "such", "as", "``", "Teachers", "''", "."], ["My", "35", "years", "in", "the", "teaching", "profession", "lead", "me", "to"  …  "much", "closer", "to", "reality", "than", "is", "``", "Teachers", "''", "."], ["The", "scramble", "to", "survive", "financially", ",", "the", "insightful", "students", "who"  …  "me", "of", "the", "schools", "I", "knew", "and", "their", "students", "."], ["When", "I", "saw", "the", "episode", "in", "which", "a", "student", "repeatedly"  …  "immediately", "recalled", "...",
"...", "...", "at", "...", "...", "...", "."], ["High", "."], ["A", "classic", "line", ":", "INSPECTOR", ":", "I", "'m", "here", "to", "sack", "one", "of", "your", "teachers", "."], ["STUDENT", ":", "Welcome", "to", "Bromwell", "High", "."], ["I", "expect", "that", "many", "adults", "of", "my", "age", "think", "that", "Bromwell", "High", "is", "far", "fetched", "."], ["What", "a", "pity", "that", "it", "is", "n't", "!"]]

 [["Homelessness", "(", "or", "Houselessness", "as", "George", "Carlin", "stated", ")", "has"  …  "school", ",", "work", ",", "or", "vote", "for", "the", "matter", "."], ["Most", "people", "think", "of", "the", "homeless", "as", "just", "a", "lost"  …  "to", "see", "what", "it", "'s", "like", "to", "be", "homeless", "?"], ["That", "is", "Goddard", "Bolt", "'s", "lesson.<br", "/", "><br", "/", ">Mel"  …  "wants", "with", "a", "future", "project", "of", "making", "more", "buildings", "."], ["The", "bet", "'s", "on", "where", "Bolt", "is", "thrown", "on", "the"  …  "move", "where", "he", "ca", "n't", "step", "off", "the", "sidewalk", "."], ["He", "'s", "given", "the", "nickname", "Pepto", "by", "a", "vagrant", "after"  …  "Wilson", ")", "who", "are", "already", "used", "to", "the", "streets", "."], ["They", "'re", "survivors", "."], ["Bolt", "is", "n't", "."], ["He", "'s", "not", "used", "to", "reaching", "mutual", "agreements", "like", "he"  …  "do", "n't", "know", "what", "to", "do", "with", "their", "money", "."], ["Maybe", "they", "should", "give", "it", "to", "the", "homeless", "instead", "of"  …  "maybe", "this", "film", "will", "inspire", "you", "to", "help", "others", "."]]

julia> flatten_levels(docs, lvls(IMDB, :documents))|>full_consolidate
19-element Array{Array{String,1},1}:
 ["Bromwell", "High", "is", "a", "cartoon", "comedy", "."]
 ["It", "ran", "at", "the", "same", "time", "as", "some", "other", "programs", "about", "school", "life", ",", "such", "as", "``", "Teachers", "''", "."]
 ["My", "35", "years", "in", "the", "teaching", "profession", "lead", "me", "to"  …  "much", "closer", "to", "reality", "than", "is", "``", "Teachers", "''", "."]
 ["The", "scramble", "to", "survive", "financially", ",", "the", "insightful", "students", "who"  …  "me", "of", "the", "schools", "I", "knew", "and", "their", "students", "."]
 ["When", "I", "saw", "the", "episode", "in", "which", "a", "student", "repeatedly"  …  "immediately", "recalled", "...", "...", "...", "at", "...", "...", "...", "."]
 ["High", "."]
 ["A", "classic", "line", ":", "INSPECTOR", ":", "I", "'m", "here", "to", "sack", "one", "of", "your", "teachers", "."]
 ["STUDENT", ":", "Welcome", "to", "Bromwell", "High", "."]
 ["I", "expect", "that", "many", "adults", "of", "my", "age", "think", "that", "Bromwell", "High", "is", "far", "fetched", "."]
 ["What", "a", "pity", "that", "it", "is", "n't", "!"]
 ["Homelessness", "(", "or", "Houselessness", "as", "George", "Carlin", "stated", ")", "has"  …  "school", ",", "work", ",", "or", "vote", "for", "the", "matter", "."]
 ["Most", "people", "think", "of", "the", "homeless", "as", "just", "a", "lost"  …  "to", "see", "what", "it", "'s", "like", "to", "be", "homeless", "?"]
 ["That", "is", "Goddard", "Bolt", "'s", "lesson.<br", "/", "><br", "/", ">Mel"  …  "wants", "with", "a", "future", "project", "of", "making", "more", "buildings", "."]
 ["The", "bet", "'s", "on", "where", "Bolt", "is", "thrown", "on", "the"  …  "move", "where", "he", "ca", "n't", "step", "off", "the", "sidewalk", "."]
 ["He", "'s", "given", "the", "nickname", "Pepto", "by", "a", "vagrant", "after"  …  "Wilson", ")", "who", "are", "already", "used", "to", "the", "streets", "."]
 ["They", "'re", "survivors", "."]
 ["Bolt", "is", "n't", "."]
 ["He", "'s", "not", "used", "to", "reaching", "mutual", "agreements", "like", "he"  …  "do", "n't", "know", "what", "to", "do", "with", "their", "money", "."]
 ["Maybe", "they", "should", "give", "it", "to", "the", "homeless", "instead", "of"  …  "maybe", "this", "film", "will", "inspire", "you", "to", "help", "others", "."]
```
