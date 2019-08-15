using DataDeps

register(DataDep("WikiGold",
    """
    Website: https://figshare.com/articles/Learning_multilingual_named_entity_recognition_from_Wikipedia/5462500

    WikiGold is a manually annotated corpus over a small sample of Wikipedia articles in CoNLL format (IOB).
    It contains 145 documents, 1696 sentences and 39152 tokens.
    The Corpus has topics from each of the four CONLL-03 classes (LOC, MISC, ORG, PER).

    Please cite the following publication, if you are using the corpora:
    Dominic Balasuriya, Nicky Ringland, Joel Nothman, Tara Murphy, James R. Curran, 2009. Named Entity Recognition in Wikipedia, Proceedings of the 2009 Workshop on the People’s Web Meets NLP, ACL-IJCNLP 2009, pages 10–18.
    https://www.aclweb.org/anthology/papers/W/W09/W09-3302/
    """,
    "https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/9446377/wikigold.conll.txt",
    post_fetch_method = function(fn)
        println(readdir("."))
    end
))
