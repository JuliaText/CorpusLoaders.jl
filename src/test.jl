using DataFrames
using DataDeps
using CSV

include("IMDB_DataDeps.jl")

dataset = DataFrame(review = [], rating = [], sentiment_label = [])

for folder in ["test", "train"]
    for subfolder in ["neg", "pos"]
        paths = joinpath.(joinpath(datadep"IMDB movie reviews dataset", "aclImdb\\$folder\\$subfolder"),
        readdir(joinpath(datadep"IMDB movie reviews dataset", "aclImdb\\$folder\\$subfolder")))
        for path in paths
            open(path) do file
                data = read(file, String)
                if path[end-5] == '_'
                    push!(dataset, [data, parse(Int, path[end-4]) ,subfolder])
                    print(path[end-4])
                elseif path[end-5] == '1'
                    push!(dataset, [data, 10, subfolder])
                end
            end
        end
    end
end
