using DataDeps

register(DataDep(
    "IMDB movie reviews dataset",
    """
    author    : Maas, Andrew L.  and  Daly, Raymond E.  and  Pham, Peter T.  and  Huang, Dan  and  Ng, Andrew Y.  and  Potts, Christopher
    title     : Learning Word Vectors for Sentiment Analysis
    booktitle : Proceedings of the 49th Annual Meeting of the Association for Computational Linguistics: Human Language Technologies
    month     : June
    year      : 2011
    address   : Portland, Oregon, USA
    publisher : Association for Computational Linguistics

    This is a dataset for binary sentiment classification.:
    25,000 highly polar reviews for training, 25,000 reviews for testing and additional unlabelled examples.

    Website:https://ai.stanford.edu/~amaas/data/sentiment/

    When using this dataset, please cite this paper
    http://www.aclweb.org/anthology/P11-1015
    """,
    "http://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz",
    "c40f74a18d3b61f90feba1e17730e0d38e8b97c05fde7008942e91923d1658fe",
    post_fetch_method = unpack
))
