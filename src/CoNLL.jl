struct CoNLL{S}
    filepaths::Vector{S}
    year::Int
    trainpath::String
    testpath::String
    devpath::String
end

function CoNLL(dirpath, year=2003)
    @assert(isdir(dirpath), dirpath)

    files = Dict()

    if year == 2003
        inner_files = readdir(dirpath)
        if "train.txt" ∈ inner_files
            files["train"] = "train.txt"
        end
        if "test.txt" ∈ inner_files
            files["test"] = "test.txt"
        end
        if "valid.txt" ∈ inner_files
            files["valid"] = "valid.txt"
        end
        for tuple in files
            files[tuple[1]] = joinpath(dirpath, tuple[2])
        end
    end
    return CoNLL(collect(values(files)), year, files["train"],
                  files["test"], files["valid"])
end

CoNLL() = CoNLL(datadep"CoNLL 2003")

MultiResolutionIterators.levelname_map(::Type{CoNLL}) = [
    :doc=>1, :document=>1, :article=>1,
    :sent=>2, :sentence=>2,
    :word=>3, :token=>3,
    :char=>4, :character=>4
    ]

function parse_conll2003_tagged_word(line::AbstractString)
    tokens_tags = split(line)
    length(tokens_tags) != 4 && throw("Error parsing line: \"$line\". Invalid Format.")
    return NERTaggedWord(tokens_tags[4], tokens_tags[3],
                         tokens_tags[2], tokens_tags[1])
end

function parse_conllfile(filename)
    local sent
    local doc
    docs = @NestedVector(NERTaggedWord,3)()
    context = Document(intern(basename(filename)), docs)

    # structure
    function new_document()
        doc = @NestedVector(NERTaggedWord,2)()
        push!(docs, doc)
    end

    function new_sentence()
        sent = @NestedVector(NERTaggedWord,1)()
        push!(doc, sent)
    end

    # words
    get_tagged(line) = push!(sent, parse_conll2003_tagged_word(line))

    # parse
    for line in eachline(filename)
        if length(line) == 0
            new_sentence()
        elseif startswith(strip(line), "-DOCSTART-")
            length(docs) > 0 && isempty(doc[end]) && deleteat!(doc, lastindex(doc))
            new_document()
        else
            get_tagged(line)
        end
    end
    isempty(doc[end]) && deleteat!(doc, lastindex(doc))

    return context
end

function load(corpus::CoNLL, file="train")
    file == "train" && return parse_conllfile(corpus.trainpath)
    file == "test" && return parse_conllfile(corpus.testpath)
    file == "dev" && return parse_conllfile(corpus.devpath)
    throw("Invalid filename! Available datasets are `train`, `test` and `dev`")
end
