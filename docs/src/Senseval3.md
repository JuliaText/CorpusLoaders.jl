# Senseval-3

Senseval-3 is a sense annotated corpus
Has a structure of documents, sentences, words.
The words are either tagged with part of speech, or tagged with full lemma, part of speech and sensekey.


In the demo below it is shown how one might index the corpus to get a collection of sentences that each use of a wordsense occurs within.

```julia

julia> corp = load(Senseval3())
Channel{CorpusLoaders.Document{Array{Array{CorpusLoaders.TaggedWord,1},1},String}}(sz_max:16,sz_curr:3)


julia> index = Dict{String, Vector{Vector{String}}}()
Dict{String,Array{Array{String,1},1}} with 0 entries


julia> for sentence in flatten_levels(corp, (!lvls)(Senseval3, :sent, :word))
           multisense_words = filter(x->x isa SenseAnnotatedWord,  sentence)
           context_words = word.(sentence)
           for target in multisense_words
               word_sense = sensekey(target)
               uses = get!(Vector{Vector{String}}, index, word_sense)
               push!(uses, context_words)
           end
       end

julia> index
Dict{String,Array{Array{String,1},1}} with 1208 entries:
  "go_to_bed%2:29:00::"     => Array{String,1}[String["The", "stranger", "reall…
  "evening%1:28:00::"       => Array{String,1}[String["He", "began", "to", "wis…
  "virtue%1:07:03::"        => Array{String,1}[String["The", "theory", "relies"…
  "coincidence%1:11:00::"   => Array{String,1}[String["But", "after", "all", ",…
  "american%1:18:00::"      => Array{String,1}[String["What", "accounts", "for"…
  "bacon%U"                 => Array{String,1}[String["If", "they", "put", "a",…
  "first_name%1:10:00::"    => Array{String,1}[String["When", "he", "finally", …
  "first%NOANSWER"          => Array{String,1}[String["First", ",", "why", "tic…
  "air%1:27:00::"           => Array{String,1}[String["Then", "the", "auto", "p…
  "ticket%U"                => Array{String,1}[String["Tuesday", "'s", "rout", …
  "newfound%5:00:00:new:00" => Array{String,1}[String["Was", "the", "man", "dru…
  "brand%1:09:00::"         => Array{String,1}[String["The", "theory", "relies"…
  "little%NOANSWER"         => Array{String,1}[String["It", "will", "take", "li…
  "deal%1:10:00::"          => Array{String,1}[String["Community_property", "de…
  "professional%3:00:01::"  => Array{String,1}[String["Suppose", "--", "just", …
  "come_back%2:30:00::"     => Array{String,1}[String["It", "was", "blurred", "…
  "daughter%1:18:00::"      => Array{String,1}[String["ONEZIE", ":", "My", "you…
  "face%2:32:00::"          => Array{String,1}[String["If", "these", "assumptio…
  "ride%2:32:00::"          => Array{String,1}[String["He", "keeps", "riding", …
  ⋮                         => ⋮


julia> index["answer%1:04:00::"]
1-element Array{Array{String,1},1}:
 String["He", "had", "no", "ready", "answer", ",", "as", "much", "from", "surprise", "as", "from", "the", "fit", "of", "coughing", "."]


julia> index["answer%1:10:00::"]
1-element Array{Array{String,1},1}:
 String["When", "he", "finally", "got", "the", "coughing", "under_control", ",", "he", "realized"  …  "even", "seem", "to", "wink", "as", "he", "continued", "to", "stare", "."]

julia> index["answer%2:32:00::"]
1-element Array{Array{String,1},1}:
 String["He", "made", "the", "mistake", "of", "answering", "in", "an", "offhand", "way"  …  "skepticism", "must", "have", "showed", "in", "his", "face", "or", "voice", "."]
