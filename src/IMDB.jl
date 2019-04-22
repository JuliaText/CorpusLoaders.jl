struct IMDB{S}
    filepaths::Vector{S}
end

function IMDB(path, category)
    paths = Dict{String, Vector{String}}()
    folder, subfolder = split(category, "_")
    basepath = joinpath(datadep"IMDB movie reviews dataset", "aclImdb\\$folder\\$subfolder")
    paths = joinpath.(basepath, readdir(basepath))
    IMDB(paths)
end

IMDB(category="train_pos") = IMDB(datadep"IMDB movie reviews dataset", category)

MultiResolutionIterators.levelname_map(::Type{IMDB}) = [
    :document => 1,
    :sentences => 2,
    :words => 3, :tokens => 3,
    :characters => 4]

function load(dataset::IMDB)
    Channel(ctype=@NestedVector(String, 2), csize=4) do docs
        for path in dataset.filepaths
            open(path) do fileio
                cur_text = read(fileio, String)
                para_of_sents = [intern.(tokenize(sent)) for sent in split_sentences(cur_text)]
                put!(docs, para_of_sents)
            end
        end
    end
end
