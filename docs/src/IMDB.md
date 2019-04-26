### IMDB

IMDB movie reviews dataset a standard collection for Binary Sentiment Analysis task. It is used for benchmarking Sentiment Analysis algorithms. It provides a set of 25,000 highly polar movie reviews for training, and 25,000 for testing. There is additional unlabeled data for use as well. Raw text and already processed bag of words formats are provided

Structure of the reviews contain different levels:
documents, sentences, words/tokens, characters

Whole data is divided into 5 parts which can be accessed by providing following keywords:
`train_pos`     : positive polarity training examples
`train_neg`     : negative polarity training examples
`test_pos`      : positive polarity testing examples
`test_neg`      : negative polarity testing examples
`train_unsup`   : unlabeled examples

To get rid of unwanted levels, `flatten_levels` function can be used.


Example:

```

```
