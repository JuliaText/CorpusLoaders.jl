# SemCor

The classical Sense Annotated corpus.
See also [WordNet.jl](https://github.com/JuliaText/WordNet.jl)

Has a structure of documents, paragraphs, sentences, words.
The words are either tagged with part of speech, or tagged with full lemma, part of speech and sensekey.
We expose the `word` function to get back the words,
and the `sensekey` function to extract the sense key.

In the demo below is is shown how one might index the corpus to get a collection of sentences that each use of a wordsense occurs within.


```julia

julia> corp = load(SemCor())
Channel{CorpusLoaders.Document{Array{Array{Array{CorpusLoaders.TaggedWord,1},1},1},String}}(sz_max:16,sz_curr:16)

julia> index = Dict{String, Vector{Vector{String}}}()
Dict{String,Array{Array{String,1},1}} with 0 entries

julia> for sentence in flatten_levels(corp, (!lvls)(SemCor, :sent, :word))
           multisense_words = filter(x->x isa SenseAnnotatedWord,  sentence)
           context_words = word.(sentence)
           for target in multisense_words
               word_sense = sensekey(target)
               uses = get!(Vector{Vector{String}}, index, word_sense)
               push!(uses, context_words)
           end
       end

julia> index
Dict{String,Array{Array{String,1},1}} with 32848 entries:
  "hill%1:17:00::"                => Array{String,1}[String["Ants", "carry_away…
  "breed%2:36:00::"               => Array{String,1}[String["Show", "her", "the…
  "sculptural%3:01:00::"          => Array{String,1}[String["In", "the", "upper…
  "earthy%5:00:00:indecent:00"    => Array{String,1}[String["The", "soldiers", …
  "grammatic%3:01:00::"           => Array{String,1}[String["Finally", ",", "in…
  "appear%2:36:00::"              => Array{String,1}[String["A", "comedy", "in"…
  "ineligible%3:00:00::"          => Array{String,1}[String["But", "he", "was",…
  "harshly%4:02:02::"             => Array{String,1}[String["``", "We", "'ll", …
  "arrogant%5:00:00:proud:00"     => Array{String,1}[String["Poor", "where", "t…
  "concord%1:15:00::"             => Array{String,1}[String["The", "rider", "fr…
  "used_to%5:00:00:accustomed:00" => Array{String,1}[String["It", "is", "a", "f…
  "baseball%1:04:00::"            => Array{String,1}[String["Boston_Red_Sox", "…
  "go_off%2:38:00::"              => Array{String,1}[String["I", "went_off", "w…
  "direct%5:00:00:immediate:00"   => Array{String,1}[String["The", "popularity"…
  "radio_noise%1:11:00::"         => Array{String,1}[String["The", "radio_emiss…
  "cackle%2:32:00::"              => Array{String,1}[String["He", "stroked", "t…
  "transportation%1:04:00::"      => Array{String,1}[String["This", "delightful…
  "paired%5:00:00:matched:00"     => Array{String,1}[String["To", "each", "pair…
  "banner%1:06:00::"              => Array{String,1}[String["They", "ate", "the…
  ⋮                               => ⋮

julia> index["abandon%1:07:00::"]
1-element Array{Array{String,1},1}:
 String["in", "his", "motherland", ";", "in", "the", "spacious", "hunting_grounds", "of", "``"  …  ",", "color", ",", "dance", ",", "design", ",", "and", "thought", "."]


julia> index["abandon%2:38:00::"]
2-element Array{Array{String,1},1}:
 String["Jonathan", "wrote", "grimly", "of", "the", "destruction", "of", "Harpers_Ferry", "before", "they"  …  "First_Brigade", "had", "destroyed", "all", "the", "rolling_stock", "of", "the", "B_+_O_Railroad", "."]
 String["The", "expense", "of_this", "type", "of", "organization", "in", "religious", "life", ","  …  "in", "congregations", "illumines", "the", "nature", "of", "the", "Protestant", "development", "."]

julia> index["abandon%2:40:00::"]
5-element Array{Array{String,1},1}:
 String["If", "the", "content", "of", "faith", "is", "to", "be", "presented", "today"  …  "but", "to", "abandon", "completely", "a", "mythological", "manner", "of", "representation", "."]
 String["When", "we", "say", "that", "a", "mythological", "mode", "of", "thought", "must"  …  "proper", "means", "for", "presenting", "the", "Christian", "understanding", "of", "existence", "."]
 String["It", "is", "curious", "that", "even", "centuries", "of", "repetition", "of", "the"  …  "allow", "people", "to", "abandon", "the", "ceremonies", "of", "the", "winter_solstice", "."]
 String["We", "have", "staved_off", "a", "war", "and", ",", "since", "our", "behavior"  …  "have", "not", "the", "slightest", "notion", "which", "parts", "are", "effective", "."]
 String["He", "had", "the", "feeling", "that", "he", "should", "abandon", "the", "car", "and", "run_off", "somewhere", "to", "hide", "."]

julia> index["abandon%2:40:01::"]
3-element Array{Array{String,1},1}:
 String["During", "the", "next", "five", "years", "liberal", "leaders", "in", "the", "United_States"  …  "felt", "the", "greatest", "distaste", "for", "but", "could", "not", "abandon", ":"]
 String["The", "cost", "of", "developing", "a", "major", "weapon_system", "is", "now", "so"  …  "place", "a", "system", "into", "production", "or", "to", "abandon", "it", "."]
 String["Once", "he", "had", "abandoned", "himself", "to", "the", "very", "worst", ","  …  "would", "n't", "be", "very", "much", "for", "Mae", "to", "do", "."]
```
