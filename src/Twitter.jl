struct Twitter{S}
    data::Array{S, 1}   #array of all tweets with specified category
end

function Twitter(category="train_pos")
    file_map = Dict("train" => "training.1600000.processed.noemoticon.csv", "test" => "testdata.manual.2009.06.14.csv")
    polarity_map = Dict("pos" => 4, "neg" => 0, "neu" => 2)
    file_id, polarity_id = split(category, "_")
    file = file_map[file_id]
    polarity = polarity_map[polarity_id]
    path = joinpath(datadep"Twitter Sentiment Dataset", "$file")
    dataframe = CSV.read(path, header=0)
    return Twitter(dataframe.Column6[dataframe.Column1 .== polarity])
end

MultiResolutionIterators.levelname_map(::Type{Twitter}) = [
    :documents => 1, :tweets => 1,
    :sentences => 2,
    :words => 3, :tokens => 3,
    :characters => 4
    ]

function load(dataset::Twitter)
    Channel(ctype=@NestedVector(String, 2), csize=4) do docs
        for tweet in dataset.data
            sents = [intern.(tokenize(sent)) for sent in split_sentences(tweet) if length(sent) != 0]
            put!(docs, sents)
        end
    end
end
