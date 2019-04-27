using DataDeps

register(DataDep(
    "Twitter Sentiment Dataset",
    """
    Twitter Sentiment Corpus by Niek Sanders
    This is downloaded from:
    http://help.sentiment140.com/for-students

    This dataset contains Twitter tweets:
    1600000 training examples
    498 test examples

    If you are using this data, cite Sentiment140
    https://cs.stanford.edu/people/alecmgo/papers/TwitterDistantSupervision09.pdf
    """,
    "https://cs.stanford.edu/people/alecmgo/trainingandtestdata.zip",
    post_fetch_method=unpack
))
