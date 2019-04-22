using DataDeps

register(DataDep(
"SST-2",
"This contains the Stanford Senitment binary dataset",
"http://nlp.stanford.edu/~socherr/stanfordSentimentTreebank.zip",
post_fetch_method=unpack
))
