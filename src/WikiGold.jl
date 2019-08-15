struct WikiGold{S}
    filepath::S
end

WikiGold() = WikiGold(datadep"WikiGold")

MultiResolutionIterators.levelname_map(::Type{WikiGold}) = [
    :doc=>1, :document=>1, :article=>1,
    :sent=>2, :sentence=>2,
    :word=>3, :token=>3,
    :char=>4, :character=>4
    ]

function parse_WikiGold_tagged_word(line::AbstractString)
    tokens_tags = split(line)
    length(tokens_tags) != 2 && throw("Error parsing line: \"$line\". Invalid Format.")
    return NerOnlyTaggedWord(tokens_tags[2], tokens_tags[1])
end

function parse_WikiGoldfile(filename)
    local sent
    local doc
    docs = @NestedVector(NerOnlyTaggedWord,3)()
    context = Document(intern(basename(filename)), docs)

    # structure
    function new_document()
        doc = @NestedVector(NerOnlyTaggedWord,2)()
        push!(docs, doc)
    end

    function new_sentence()
        sent = @NestedVector(NerOnlyTaggedWord,1)()
        push!(doc, sent)
    end

    # words
    get_tagged(line) = push!(sent, parse_WikiGold_tagged_word(line))

    new_document()
    new_sentence()
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
    isempty(vcat(docs[end]...)) && deleteat!(docs, lastindex(docs))

    return context
end

function load(corpus::WikiGold)
    file = readdir(corpus.filepath)[1]
    return parse_WikiGoldfile(joinpath(corpus.filepath, file))
end
