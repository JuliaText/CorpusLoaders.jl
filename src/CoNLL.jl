struct CoNLL{S}
    filepaths::Vector{S}
    year::Int
    trainpath::String
    testpath::String
    devpath::String
end

function init_datadeps(::Type{CoNLL})
    register(DataDep("CoNLL 2003",
        """
        Website: https://www.clips.uantwerpen.be/conll2003/ner/
        Data Website: https://github.com/davidsbatista/NER-datasets

        The Seventh Conference on Natural Language Learning (CoNLL-2003) was held on May 31 and June 1, 2003 in association with HLT-NAACL 2003 in Edmonton, Canada.

        The details of the task are in the following paper, please cite the following publication if you are using the corpora.

        Erik F. Tjong Kim Sang, Fien De Meulder. "Introduction to the CoNLL-2003 Shared Task: Language-Independent Named Entity Recognition." Proceedings of CoNLL-2003, Edmonton, Canada, 2003.
        https://www.clips.uantwerpen.be/conll2003/pdf/14247tjo.pdf
        """,
        "https://github.com/davidsbatista/NER-datasets/archive/master.zip",
        "db332cddb12f123b92fc6653a582eec1b3f14e6741f9c6e0bf5d960c78dee3a0";
        post_fetch_method = function(fn)
            unpack(fn)
            dir = "NER-datasets-master"
            innerdir = joinpath(dir, "CONLL2003")
            innerfiles = readdir(innerdir)
            # Move everything to current directory, under same name
            mv.(joinpath.(innerdir, innerfiles), innerfiles)
            rm(dir, recursive=true)
        end
    ))
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

function parse_conll2003file(filename)
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
    if (corpus.year == 2003)
        file == "train" && return parse_conll2003file(corpus.trainpath)
        file == "test" && return parse_conll2003file(corpus.testpath)
        file == "dev" && return parse_conll2003file(corpus.devpath)
        throw("Invalid filename! Available datasets are `train`, `test` and `dev`")
    end
end
