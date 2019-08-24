struct CoNLL2000{S}
    filepaths::Vector{S}
    year::Int
    trainpath::String
    testpath::String
end

function CoNLL2000(path1, path2, year=2000)
    @assert(isdir(path1), path1)
    @assert(isdir(path2), path2)

    files = Dict("train" => joinpath(path1, "train.txt"),
             "test" => joinpath(path2, "test.txt"))

    return CoNLL2000(collect(values(files)), year, files["train"],
                  files["test"])
end

CoNLL2000() = CoNLL2000(datadep"CoNLL 2000 train", datadep"CoNLL 2000 test")

MultiResolutionIterators.levelname_map(::Type{CoNLL2000}) = [
    :sent=>1, :sentence=>1,
    :word=>2, :token=>2,
    :char=>3, :character=>3
    ]

function parse_conll2000_tagged_word(line::AbstractString)
    tokens_tags = split(line)
    length(tokens_tags) != 3 && throw("Error parsing line: \"$line\". Invalid Format.")
    return POSTaggedWord(tokens_tags[2], tokens_tags[3], tokens_tags[1])
end

function parse_conll2000file(filename)
    local sent
    sents = @NestedVector(POSTaggedWord, 2)()
    context = Document(intern(basename(filename)), sents)

    function new_sentence()
        sent = @NestedVector(POSTaggedWord,1)()
        push!(sents, sent)
    end

    # words
    get_tagged(line) = push!(sent, parse_conll2000_tagged_word(line))

    new_sentence()
    # parse
    for line in eachline(filename)
        if length(line) == 0 && length(sent) > 0
            new_sentence()
        else
            get_tagged(line)
        end
    end
    isempty(sents[end]) && deleteat!(sents, lastindex(sents))

    return context
end

function load(corpus::CoNLL2000, file="train")
    file == "train" && return parse_conll2000file(corpus.trainpath)
    file == "test" && return parse_conll2000file(corpus.testpath)
    file == "dev" && throw("Dev set not available in $year.")
    throw("Invalid filename! Available datasets are `train` & `test`")
end
