
unpack(f) = BinDeps.unpack_cmd(f, cwd(), last(splitext(f)), last(first(splitext(f))))

RegisterDataDep(
    "Wikicorpus-en raw",
    """
    A corpus based on a plain text extraction of a 2006 dump of wikipedia.
    Website: http://www.cs.upc.edu/~nlp/wikicorpus/

    Please cite the following publication if you use the corpora:
    Samuel Reese, Gemma Boleda, Montse Cuadros, Lluís Padró, German Rigau. Wikicorpus: A Word-Sense Disambiguated Multilingual Wikipedia Corpus. In Proceedings of 7th Language Resources and Evaluation Conference (LREC'10), La Valleta, Malta. May, 2010.
    """,
    ["http://www.cs.upc.edu/~nlp/wikicorpus/README.txt", "http://www.cs.upc.edu/~nlp/wikicorpus/raw.en.tgz"],
    "935c81879c76ac6e5d80abd6d8c7eb276cbd90c74cfa422e3483c20960209155",
    post_fetch_method=[identity, unpack]
)

readdir(datadep"Wikicorpus-en raw")
