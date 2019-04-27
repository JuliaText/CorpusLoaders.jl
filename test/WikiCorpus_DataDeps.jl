using DataDeps

register(DataDep("English WikiCorpus v1.0",
    """
    Website: http://www.cs.upc.edu/~nlp/wikicorpus/
    Author: Samual Reese, et al.
    The Wikicorpus contains large portions of the Wikipedia, based on a 2006 dump.
    This is the English portion which has around 600 million words.

    Please cite the following publication if you use the corpora:
    Samuel Reese, Gemma Boleda, Montse Cuadros, Lluís Padró, German Rigau. Wikicorpus: A Word-Sense Disambiguated Multilingual Wikipedia Corpus. In Proceedings of 7th Language Resources and Evaluation Conference (LREC'10), La Valleta, Malta. May, 2010.
    """,
    "http://www.cs.upc.edu/~nlp/wikicorpus/raw.en.tgz",
    "cab102a59f7e5bfb4ac832c15210bd22840bbed5508899f2dee04b857830e858";
    post_fetch_method = unpack
))
