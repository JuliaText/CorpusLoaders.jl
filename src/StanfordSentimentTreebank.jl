"""StanfordSentimentTreebank Type
having dict and senti fields for
phrases and corresponding sentiments respectively"""
struct StanfordSentimentTreebank
    filepath :: String
end

function StanfordSentimentTreebank()
    path = joinpath(datadep"Stanford Sentiment Treebank", "sa_dataset.txt")
    StanfordSentimentTreebank(path)
end

MultiResolutionIterators.levelname_map(::Type{StanfordSentimentTreebank}) = [
    :documents => 1,
    :sentences => 2,
    :words => 3, :tokens => 3,
    :characters => 4
]

function load(dataset::StanfordSentimentTreebank)
    data = map(eachline(dataset.filepath)) do line
        doc_raw, sentiment_raw = split(line, '|')
        sents = [intern.(tokenize(sent)) for sent in split_sentences(doc_raw)]
        sentiment = parse(Float64, sentiment_raw)
        [sents, sentiment]
    end
    permutedims(hcat(data...))
end
