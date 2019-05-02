struct SST{S}
    dict :: Array{S, 2}
    senti :: Array{S, 2}
end

function SST()
    dictionary = readdlm(joinpath(datadep"SST", "dictionary.txt"), '|')[2:end, :]
    sentiments = readdlm(joinpath(datadep"SST", "sentiment_labels.txt"), '|')[2:end, :]
    return SST(dictionary, sentiments)
end

MultiResolutionIterators.levelname_map(::Type{SST}) = [
    :documents => 1,
    :sentences => 2,
    :words => 3, :tokens => 3,
    :characters => 4
]

function load(dataset::SST)
    Channel(ctype=Array{Any, 1}, csize=4) do docs
        for id in dataset.senti[:, 1]
            idx = findall(x->x==id, dataset.dict[:, 2])
            if length(idx) == 0 continue end
            para_of_sents = [intern.(tokenize(sent)) for sent in split_sentences(dataset.dict[idx[1], 1])]
            put!(docs, [para_of_sents, dataset.senti[id+1, 2]])
        end
    end
end
