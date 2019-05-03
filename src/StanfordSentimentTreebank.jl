"""StanfordSentimentTreebank Type
having dict and senti fields for
phrases and corresponding sentiments respectively"""
struct StanfordSentimentTreebank{S}
    dict :: Array{S, 2}
    senti :: Array{S, 2}
end

function StanfordSentimentTreebank()
    dictionary = readdlm(joinpath(datadep"Stanford Sentiment Treebank", "dictionary.txt"), '|')[2:end, :] #dictionay.txt files is import here from dataset directory
    sentiments = readdlm(joinpath(datadep"Stanford Sentiment Treebank", "sentiment_labels.txt"), '|')[2:end, :] #corresponding sentiments files from dataset
    return StanfordSentimentTreebank(dictionary, sentiments)
end

MultiResolutionIterators.levelname_map(::Type{StanfordSentimentTreebank}) = [
    :documents => 1,
    :sentences => 2,
    :words => 3, :tokens => 3,
    :characters => 4
]

function load(dataset::StanfordSentimentTreebank)
    Channel(ctype=@NestedVector(Any, 1), csize=4) do docs
        for id in dataset.senti[:, 1]   #matching sentiment id with phrase id in dictionary then putting into channel
            idx = findall(isequal(id), dataset.dict[:, 2])
            length(idx) == 0 && continue
            sents = [intern.(tokenize(sent)) for sent in split_sentences(dataset.dict[idx[1], 1])]
            put!(docs, [sents, dataset.senti[id+1, 2]])
        end
    end
end
