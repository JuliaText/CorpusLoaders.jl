using DataDeps

register(DataDep(
    "Stanford Sentiment Treebank",
    """
    Stanford Sentiment Treebank V1.0

    It includes fine grained sentiment labels for 215,154 phrases in the parse trees of 11,855 sentences.

    title       :   Parsing With Compositional Vector Grammars
    author      :   Richard Socher and Alex Perelygin and Jean Wu and Jason Chuang and Christopher Manning and Andrew Ng and Christopher Potts
    booktitle   :   EMNLP
    year        :   2013
    Website     :   https://nlp.stanford.edu/sentiment/index.html

    Cite this paper if this dataset is used:
    https://nlp.stanford.edu/~socherr/EMNLP2013_RNTN.pdf
    """,
    "http://nlp.stanford.edu/~socherr/stanfordSentimentTreebank.zip",
    "3f5209483b46bbf129cacbbbe6ae02fe780407034f61cf6342b7833257c3f1db",
    post_fetch_method = function (fn)
        unpack(fn)
        dir = "stanfordSentimentTreebank"
        files = readdir(dir)
        mv.(joinpath.(dir, files), files)
        rm(dir), rm("__MACOSX", recursive=true)
    end
))
