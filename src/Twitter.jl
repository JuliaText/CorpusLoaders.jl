struct Twitter{S}
    data::Array{S, 1}   #array of all tweets with specified category
end

function init_datadeps(::Type{Twitter})
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
