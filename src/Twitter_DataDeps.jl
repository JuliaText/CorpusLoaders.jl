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
    "004a3772c8a7ff9bbfeb875880f47f0679d93fc63e5cf9cff72d54a8a6162e57",
    post_fetch_method=unpack
))
