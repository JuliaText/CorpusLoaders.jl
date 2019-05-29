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
    Channel(ctype=@NestedVector(Any, 1), csize=4) do docs
        open(dataset.filepath, "r") do file
            file = split.(split(read(file, String), '\n'), '|')
            for example in file
                sents = [intern.(tokenize(sent)) for sent in split_sentences(example[1])]
                put!(docs, [sents, parse(Float64, example[2])])
            end
        end
    end
end
