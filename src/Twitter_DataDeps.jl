using DataDeps

register(DataDep(
    "Twitter Sentiment Dataset",
    """
    Twitter Sentiment Corpus by Niek Sanders
    """,
    "https://cs.stanford.edu/people/alecmgo/trainingandtestdata.zip",
    post_fetch_method=unpack
))
