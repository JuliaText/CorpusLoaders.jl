struct CoNLL{S}
    filepaths::Vector{S}
end

function CoNLL(dirpath)
    @assert(isdir(dirpath), dirpath)

    files = []
    for file in readdir(dirpath)
        if length(file) > 4 && file[end-3:end] == ".txt"
            push!(files, file)
        end
    end

    files = joinpath.(dirpath, files)
    CoNLL(files)
end

CoNLL() = CoNLL(datadep"CoNLL 2003")

MultiResolutionIterators.levelname_map(::Type{CoNLL}) = [
    :doc=>1, :document=>1,
    :sent=>2, :sentence=>2,
    :word=>3, :token=>3,
    :char=>4, :character=>4
    ]
