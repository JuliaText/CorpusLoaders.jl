struct GMB{S}
    filepath :: Vector{S}
end

function GMB(dirpath)
    @assert(isdir(dirpath), dirpath)
    paths=glob("data/*/*/en.tags",dirpath)
    GMB(paths)
end

GMB() = GMB(datadep"GMB 2.2.0") 

MultiResolutionIterators.levelname_map(::Type{GMB}) = [
    :doc=>1, :contextfile=>1, :context=>1, :document=>1,
    :para=>2, :paragraph=>2,
    :sent=>3, :sentence=>3,
    :word=>4, :token=>4,
    :char=>5, :character=>5
    ]

function parse_gmb_tagged_word(line::AbstractString)
    tokens_tags = split(line, '\t')
    return NerOnlyTaggedWord(tokens_tags[2], tokens_tags[1])
end

function parse_gmb(filename)
    local sent=[]
	sents = @NestedVector(NerOnlyTaggedWord, 2)()

    function new_sentence()
        sent = @NestedVector(NerOnlyTaggedWord, 1)()
        push!(sents, sent)
    end
    

    # words
    get_tagged(line) = push!(sent, parse_gmb_tagged_word(line))

    # parse
	for line in eachline(filename)
        if length(line) == 0
            new_sentence()
        else
            get_tagged(line)
        end
	end
    return sents
end

function load(corpus::GMB)
	ch=[]
	for fn in corpus.filepath
    	document = parse_gmb(fn)
        append!(ch, document)
	end
    return(ch)
end
