
## SemCor

The classical Sense Annotated corpus.
See also [WordNet.jl](https://github.com/JuliaText/WordNet.jl)

Has a structure of documents, paragraphs, sentences, words.
The words are either tagged with part of speech, or tagged with full lemma, part of speech and sensekey.
We expose the `word` function to get back the words,
and the `sensekey` function to extract the sense key.

In the demo below is is shown how one might index the corpus to get a collection of sentences that each use of a wordsense occurs within.


```julia

julia> corp = load(SemCor())
Channel{CorpusLoaders.Document{Array{Array{Array{CorpusLoaders.TaggedWord,1},1},1},InternedStrings.InternedString}}(sz_max:16,sz_curr:16)

julia> index = Dict{String, Vector{Vector{InternedString}}}()
Dict{String,Array{Array{InternedStrings.InternedString,1},1}} with 0 entries

julia> for sentence in flatten_levels(corp, (!lvls)(SemCor, :sent, :word))
           multisense_words = filter(x->x isa SenseAnnotatedWord,  sentence)
           context_words = word.(sentence)
           for target in multisense_words
               word_sense = sensekey(target)
               uses = get!(Vector{Vector{InternedString}}, index, word_sense)
               push!(uses, context_words)
           end
       end

julia> index
Dict{String,Array{Array{InternedStrings.InternedString,1},1}} with 32848 entries:
  "hill%1:17:00::"                => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "breed%2:36:00::"               => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "sculptural%3:01:00::"          => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "earthy%5:00:00:indecent:00"    => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "grammatic%3:01:00::"           => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "appear%2:36:00::"              => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "ineligible%3:00:00::"          => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "harshly%4:02:02::"             => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "arrogant%5:00:00:proud:00"     => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "concord%1:15:00::"             => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "used_to%5:00:00:accustomed:00" => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "baseball%1:04:00::"            => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "go_off%2:38:00::"              => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "direct%5:00:00:immediate:00"   => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "radio_noise%1:11:00::"         => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "cackle%2:32:00::"              => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "transportation%1:04:00::"      => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "paired%5:00:00:matched:00"     => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "banner%1:06:00::"              => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "look_on%2:39:00::"             => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "orbit%1:07:00::"               => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "sassing%1:10:00::"             => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "word_of_farewell%1:10:00::"    => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "glow%1:26:00::"                => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  "operating_budget%1:21:00::"    => Array{InternedStrings.InternedString,1}[InternedStrings.Intern…
  ⋮                               => ⋮

julia> index["abandon%1:07:00::"]
1-element Array{Array{InternedStrings.InternedString,1},1}:
 InternedStrings.InternedString["in", "his", "motherland", "in", "the", "spacious", "hunting_grounds", "of", "Uncle_Sam", "in"  …  "new", "found", "freedoms", "in", "tone", "color", "dance", "design", "and", "thought"]

julia> index["abandon%2:38:00::"]
2-element Array{Array{InternedStrings.InternedString,1},1}:
 InternedStrings.InternedString["Jonathan", "wrote", "grimly", "of", "the", "destruction", "of", "Harpers_Ferry", "before", "they"  …  "'s", "First_Brigade", "had", "destroyed", "all", "the", "rolling_stock", "of", "the", "B_+_O_Railroad"]
 InternedStrings.InternedString["The", "expense", "of_this", "type", "of", "organization", "in", "religious", "life", "when"  …  "integration", "in", "congregations", "illumines", "the", "nature", "of", "the", "Protestant", "development"]

julia> index["abandon%2:40:00::"]
5-element Array{Array{InternedStrings.InternedString,1},1}:
 InternedStrings.InternedString["If", "the", "content", "of", "faith", "is", "to", "be", "presented", "today"  …  "choice", "but", "to", "abandon", "completely", "a", "mythological", "manner", "of", "representation"]
 InternedStrings.InternedString["When", "we", "say", "that", "a", "mythological", "mode", "of", "thought", "must"  …  "or", "proper", "means", "for", "presenting", "the", "Christian", "understanding", "of", "existence"]
 InternedStrings.InternedString["It", "is", "curious", "that", "even", "centuries", "of", "repetition", "of", "the"  …  "to", "allow", "people", "to", "abandon", "the", "ceremonies", "of", "the", "winter_solstice"]
 InternedStrings.InternedString["We", "have", "staved_off", "a", "war", "and", "since", "our", "behavior", "has"  …  "we", "have", "not", "the", "slightest", "notion", "which", "parts", "are", "effective"]
 InternedStrings.InternedString["He", "had", "the", "feeling", "that", "he", "should", "abandon", "the", "car", "and", "run_off", "somewhere", "to", "hide"]

julia> index["abandon%2:40:01::"]
3-element Array{Array{InternedStrings.InternedString,1},1}:
 InternedStrings.InternedString["During", "the", "next", "five", "years", "liberal", "leaders", "in", "the", "United_States"  …  "we", "felt", "the", "greatest", "distaste", "for", "but", "could", "not", "abandon"]
 InternedStrings.InternedString["The", "cost", "of", "developing", "a", "major", "weapon_system", "is", "now", "so"  …  "to", "place", "a", "system", "into", "production", "or", "to", "abandon", "it"]
 InternedStrings.InternedString["Once", "he", "had", "abandoned", "himself", "to", "the", "very", "worst", "once"  …  "there", "would", "n't", "be", "very", "much", "for", "Mae", "to", "do"]
```
