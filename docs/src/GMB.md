# GMB
The dataset an extract from GMB corpus which is tagged, annotated, 
and built specifically to train the classifier to predict named entities such as name, location, etc. 

GMB is a fairly large corpus with a lot of annotations.
Unfortunately, GMB is not perfect. It is not a gold standard corpus, meaning that it’s not completely human annotated and it’s not considered 100% correct. 
The corpus is created by using already existed annotators and then corrected by humans where needed.


```julia

julia> corp = load(GMB())
37789-element Array{Any,1}:
 CorpusLoaders.NerOnlyTaggedWord[NerOnlyTaggedWord("NNS", "Families"), NerOnlyTaggedWord("IN", "of"), 
NerOnlyTaggedWord("NNS", "soldiers"), NerOnlyTaggedWord("VBN", "killed"), NerOnlyTaggedWord("IN", "in"), 
NerOnlyTaggedWord("DT", "the"), NerOnlyTaggedWord("NN", "conflict"), NerOnlyTaggedWord("VBD", "joined"), 
NerOnlyTaggedWord("DT", "the"), NerOnlyTaggedWord("NNS", "protesters")  …  NerOnlyTaggedWord("CD", "One"), 
NerOnlyTaggedWord("NN", "Terrorist"), NerOnlyTaggedWord("RQU", "\""), NerOnlyTaggedWord("CC", "and"), 
NerOnlyTaggedWord("LQU", "\""), NerOnlyTaggedWord("VB", "Stop"), NerOnlyTaggedWord("DT", "the"), 
NerOnlyTaggedWord("NNS", "Bombings"), NerOnlyTaggedWord(".", "."), NerOnlyTaggedWord("LQU", "\"")]

 CorpusLoaders.NerOnlyTaggedWord[NerOnlyTaggedWord("PRP", "They"), NerOnlyTaggedWord("VBD", "marched"), 
NerOnlyTaggedWord("IN", "from"), NerOnlyTaggedWord("DT", "the"), NerOnlyTaggedWord("NNS", "Houses"), 
NerOnlyTaggedWord("IN", "of"), NerOnlyTaggedWord("NN", "Parliament"), NerOnlyTaggedWord("TO", "to"), 
NerOnlyTaggedWord("DT", "a"), NerOnlyTaggedWord("NN", "rally"), NerOnlyTaggedWord("IN", "in"), 
NerOnlyTaggedWord("NNP", "Hyde"), NerOnlyTaggedWord("NNP", "Park"), NerOnlyTaggedWord(".", ".")]

 CorpusLoaders.NerOnlyTaggedWord[NerOnlyTaggedWord("NNS", "Police"), NerOnlyTaggedWord("VBD", "put"), 
NerOnlyTaggedWord("DT", "the"), NerOnlyTaggedWord("NN", "number"), NerOnlyTaggedWord("IN", "of"), 
NerOnlyTaggedWord("NNS", "marchers"), NerOnlyTaggedWord("IN", "at"), NerOnlyTaggedWord("CD", "10,000"), 
NerOnlyTaggedWord("IN", "while"), NerOnlyTaggedWord("NNS", "organizers"), NerOnlyTaggedWord("VBD", "claimed"), 
NerOnlyTaggedWord("PRP", "it"), NerOnlyTaggedWord("VBD", "was"), NerOnlyTaggedWord("CD", "100,000"), 
NerOnlyTaggedWord(".", ".")]

  ⋮

 CorpusLoaders.NerOnlyTaggedWord[NerOnlyTaggedWord("IN", "At"), NerOnlyTaggedWord("JJ", "last"), 
NerOnlyTaggedWord("DT", "the"), NerOnlyTaggedWord("NNP", "Goatherd"), NerOnlyTaggedWord("VBD", "threw"), 
NerOnlyTaggedWord("DT", "a"), NerOnlyTaggedWord("NN", "stone"), NerOnlyTaggedWord(",", ","), NerOnlyTaggedWord("CC", 
"and"), NerOnlyTaggedWord("VBG", "breaking")  …  NerOnlyTaggedWord(",", ","), NerOnlyTaggedWord("VBD", "begged"), 
NerOnlyTaggedWord("DT", "the"), NerOnlyTaggedWord("NNP", "Goat"), NerOnlyTaggedWord("RB", "not"), 
NerOnlyTaggedWord("TO", "to"), NerOnlyTaggedWord("VB", "tell"), NerOnlyTaggedWord("PRP\$", "his"), 
NerOnlyTaggedWord("NN", "master"), NerOnlyTaggedWord(".", ".")]

 CorpusLoaders.NerOnlyTaggedWord[NerOnlyTaggedWord("DT", "The"), NerOnlyTaggedWord("NNP", "Goat"),
 NerOnlyTaggedWord("VBD", "replied"), NerOnlyTaggedWord(",", ","), NerOnlyTaggedWord("LQU", "\""),
 NerOnlyTaggedWord("WRB", "Why"), NerOnlyTaggedWord(",", ","), NerOnlyTaggedWord("PRP", "you"), 
NerOnlyTaggedWord("JJ", "silly"), NerOnlyTaggedWord("NN", "fellow")  …  NerOnlyTaggedWord("DT", "the"), 
NerOnlyTaggedWord("NN", "horn"), NerOnlyTaggedWord("MD", "will"), NerOnlyTaggedWord("VB", "speak"), 
NerOnlyTaggedWord("IN", "though"), NerOnlyTaggedWord("PRP", "I"), NerOnlyTaggedWord("VB", "be"), 
NerOnlyTaggedWord("JJ", "silent"), NerOnlyTaggedWord(".", "."), NerOnlyTaggedWord("LQU", "\"")]

 CorpusLoaders.NerOnlyTaggedWord[NerOnlyTaggedWord("VBP", "Do"), NerOnlyTaggedWord("RB", "not"), 
NerOnlyTaggedWord("VB", "attempt"), NerOnlyTaggedWord("TO", "to"), NerOnlyTaggedWord("VB", "hide"), 
NerOnlyTaggedWord("NNS", "things"), NerOnlyTaggedWord("WDT", "which"), NerOnlyTaggedWord("MD", "can"), 
NerOnlyTaggedWord("RB", "not"), NerOnlyTaggedWord("VB", "be"), NerOnlyTaggedWord("JJ", "hid"), NerOnlyTaggedWord(".", ".")]

```
