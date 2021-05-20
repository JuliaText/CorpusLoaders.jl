struct CoNLL2000{S}
    filepaths::Vector{S}
    year::Int
    trainpath::String
    testpath::String
end

function init_datadeps(::Type{CoNLL2000})
    for (file, checksum) in [("train", "bcbbe17c487d0939d48c2d694622303edb3637ca9c4944776628cd1815c5cb34"),
	                ("test", "2695b931a505b65b1d3fe2a5aa0d749edcd53d786278da6d7726714e1426fbe8")]
        register(DataDep("CoNLL 2000 $file",
	    """
	    Website: https://www.clips.uantwerpen.be/conll2000/chunking/$file.txt.gz
	    Data Website:https://www.clips.uantwerpen.be/conll2000/chunking/

	    The Fourth Conference on Natural Language Learning (CoNLL-2003) was held on September 13 and September 14, 2000 in conjunction with ICGI-2000 and LLL-2000 at the Instituto Superior Técnico in Lisbon, Portugal.

	    The details of the task are in the following paper, please cite the following publication if you are using the corpora.

	    Erik F. Tjong Kim Sang, Sabine Buchholz. "Introduction to the CoNLL-2000 Shared Task: Chunking." In: Proceedings of CoNLL-2000 and LLL-2000, pages 127-132, Lisbon, Portugal, 2000.
	    https://www.clips.uantwerpen.be/conll2000/pdf/12732tjo.pdf
	    """,
	    "https://www.clips.uantwerpen.be/conll2000/chunking/$file.txt.gz",
	    checksum;
	    post_fetch_method = unpack
        ))
    end
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
