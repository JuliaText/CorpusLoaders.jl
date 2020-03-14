# GMB
The dataset an extract from GMB corpus which is tagged, annotated, 
and built specifically to train the classifier to predict named entities such as name, location, etc. 

GMB is a fairly large corpus with a lot of annotations.
Unfortunately, GMB is not perfect. It is not a gold standard corpus, meaning that it’s not completely human annotated and it’s not considered 100% correct. 
The corpus is created by using already existed annotators and then corrected by humans where needed.

The Groningen Meaning Bank (GMB) consists of public domain English texts with corresponding syntactic and semantic representations.
The GMB is developed at the [University of Groningen](https://www.rug.nl/).
 A multi-lingual version of the GMB is the [Parallel Meaning Bank](https://pmb.let.rug.nl/). A thorough description of the GMB can be found in the Handbook of Linguistic Annotation.

For more detail [refer](https://gmb.let.rug.nl/about.php)

```julia

 Data= load(GMB())
37789-element Array{Array{PosTaggedWord,1},1}:
 [PosTaggedWord("NNS", "Families"), PosTaggedWord("IN", "of"), PosTaggedWord("NNS", "soldiers"), PosTaggedWord("VBN", "killed"), PosTaggedWord("IN", "in"), PosTaggedWord("DT", "the"), PosTaggedWord("NN", "conflict"), PosTaggedWord("VBD", "joined"), PosTaggedWord("DT", "the"), PosTaggedWord("NNS", "protesters")  …  PosTaggedWord("CD", "One"), PosTaggedWord("NN", "Terrorist"), PosTaggedWord("RQU", "\""), PosTaggedWord("CC", "and"), PosTaggedWord("LQU", "\""), PosTaggedWord("VB", "Stop"), PosTaggedWord("DT", "the"), PosTaggedWord("NNS", "Bombings"), PosTaggedWord(".", "."), PosTaggedWord("LQU", "\"")]

 [PosTaggedWord("PRP", "They"), PosTaggedWord("VBD", "marched"), PosTaggedWord("IN", "from"), PosTaggedWord("DT", "the"), PosTaggedWord("NNS", "Houses"), PosTaggedWord("IN", "of"), PosTaggedWord("NN", "Parliament"), PosTaggedWord("TO", "to"), PosTaggedWord("DT", "a"), PosTaggedWord("NN", "rally"), PosTaggedWord("IN", "in"), PosTaggedWord("NNP", "Hyde"), PosTaggedWord("NNP", "Park"), PosTaggedWord(".", ".")]

 [PosTaggedWord("NNS", "Police"), PosTaggedWord("VBD", "put"), PosTaggedWord("DT", "the"), PosTaggedWord("NN", "number"), PosTaggedWord("IN", "of"), PosTaggedWord("NNS", "marchers"), PosTaggedWord("IN", "at"), PosTaggedWord("CD", "10,000"), PosTaggedWord("IN", "while"), PosTaggedWord("NNS", "organizers"), PosTaggedWord("VBD", "claimed"), PosTaggedWord("PRP", "it"), PosTaggedWord("VBD", "was"), PosTaggedWord("CD", "100,000"), PosTaggedWord(".", ".")]

  ⋮
                                                                            
 [PosTaggedWord("IN", "At"), PosTaggedWord("JJ", "last"), PosTaggedWord("DT", "the"), PosTaggedWord("NNP", "Goatherd"), PosTaggedWord("VBD", "threw"), PosTaggedWord("DT", "a"), PosTaggedWord("NN", "stone"), PosTaggedWord(",", ","), PosTaggedWord("CC", "and"), PosTaggedWord("VBG", "breaking")  …  PosTaggedWord(",", ","), PosTaggedWord("VBD", "begged"), PosTaggedWord("DT", "the"), PosTaggedWord("NNP", "Goat"), PosTaggedWord("RB", "not"), PosTaggedWord("TO", "to"), PosTaggedWord("VB", "tell"), PosTaggedWord("PRP\$", "his"), PosTaggedWord("NN", "master"), PosTaggedWord(".", ".")]

 [PosTaggedWord("DT", "The"), PosTaggedWord("NNP", "Goat"), PosTaggedWord("VBD", "replied"), PosTaggedWord(",", ","), PosTaggedWord("LQU", "\""), PosTaggedWord("WRB", "Why"), PosTaggedWord(",", ","), PosTaggedWord("PRP", "you"), PosTaggedWord("JJ", "silly"), PosTaggedWord("NN", "fellow")  …  PosTaggedWord("DT", "the"), PosTaggedWord("NN", "horn"), PosTaggedWord("MD", "will"), PosTaggedWord("VB", "speak"), PosTaggedWord("IN", "though"), PosTaggedWord("PRP", "I"), PosTaggedWord("VB", "be"), PosTaggedWord("JJ", "silent"), PosTaggedWord(".", "."), PosTaggedWord("LQU", "\"")]

 [PosTaggedWord("VBP", "Do"), PosTaggedWord("RB", "not"), PosTaggedWord("VB", "attempt"), PosTaggedWord("TO", "to"), PosTaggedWord("VB", "hide"), PosTaggedWord("NNS", "things"), PosTaggedWord("WDT", "which"), PosTaggedWord("MD", "can"), PosTaggedWord("RB", "not"), PosTaggedWord("VB", "be"), PosTaggedWord("JJ", "hid"), PosTaggedWord(".", ".")] 

julia> Data[1]
30-element Array{PosTaggedWord,1}:
 PosTaggedWord("NNS", "Families")
 PosTaggedWord("IN", "of")
 PosTaggedWord("NNS", "soldiers")
 PosTaggedWord("VBN", "killed")
 PosTaggedWord("IN", "in")
 PosTaggedWord("DT", "the")
 PosTaggedWord("NN", "conflict")
 PosTaggedWord("VBD", "joined")
 PosTaggedWord("DT", "the")
 PosTaggedWord("NNS", "protesters")
 PosTaggedWord("WP", "who")
 PosTaggedWord("VBD", "carried")
 PosTaggedWord("NNS", "banners") 
 PosTaggedWord("IN", "with") 
 ⋮
 PosTaggedWord("IN", "as")
 PosTaggedWord("LQU", "\"")
 PosTaggedWord("NNP", "Bush")
 PosTaggedWord("NN", "Number")
 PosTaggedWord("CD", "One") 
 PosTaggedWord("NN", "Terrorist")
 PosTaggedWord("RQU", "\"") 
 PosTaggedWord("CC", "and") 
 PosTaggedWord("LQU", "\"") 
 PosTaggedWord("VB", "Stop")
 PosTaggedWord("DT", "the") 
 PosTaggedWord("NNS", "Bombings")
 PosTaggedWord(".", ".") 
 PosTaggedWord("LQU", "\"") 

```
