using DataDeps
using DelimitedFiles
include("SST-2_DataDeps.jl")

sentiments_labels = readdlm(datadep"SST-2\\stanfordSentimentTreebank\\sentiment_labels.txt", '|')
dictionary = readdlm(datadep"SST-2\\stanfordSentimentTreebank\\dictionary.txt", '|')
