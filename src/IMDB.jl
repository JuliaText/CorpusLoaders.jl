struct IMDB{S}
    filepaths::Vector{S}    #paths to all the files of specified category
end

function IMDB(category = "train_pos")
    paths = Dict{String, Vector{String}}()
    folder, subfolder = split(category, "_")
    basepath = joinpath(datadep"IMDB movie reviews dataset", "aclImdb", "$folder", "$subfolder")
    paths = joinpath.(basepath, readdir(basepath))
    IMDB(paths)
end

MultiResolutionIterators.levelname_map(::Type{IMDB}) = [
    :documents => 1,
    :sentences => 2,
    :words => 3, :tokens => 3,
    :characters => 4]

function load(dataset::IMDB)
    Channel(ctype=@NestedVector(String, 2), csize=4) do docs
        for path in dataset.filepaths   #extract data from the files in directory and put into channel
            open(path) do fileio
                cur_text = read(fileio, String)
                sents = [intern.(tokenize(sent)) for sent in split_sentences(cur_text)]
                put!(docs, sents)
            end #open
        end #for
    end #channel
end
