using DataDeps

register(DataDep(
    "Twitter Sentiment Dataset",
    """
    The Twitter Sentiment Analysis Dataset contains 1,578,627 classified tweets,
    each row is marked as 1 for positive sentiment and 0 for negative sentiment.

    Dataset is based on two sources:
    1. University of Michigan Sentiment Analysis competition on Kaggle
    2. Twitter Sentiment Corpus by Niek Sanders
    """,
    "http://thinknook.com/wp-content/uploads/2012/09/Sentiment-Analysis-Dataset.zip",
    post_fetch_method=unpack
))
