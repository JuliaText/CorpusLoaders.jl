struct Senseval3{S}
    filepaths::Vector{S}
end

function Senseval3(dirpath, ver=3.0)
    @assert(isdir(dirpath), dirpath)

    if "wordnet$ver" ∈ readdir(dirpath)
        paths = joinpath.(dirpath,"wordnet$ver", readdir(joinpath(dirpath, "wordnet$ver")))
    else
        paths = joinpath.(dirpath, readdir(dirpath))
    end
    Senseval3(paths)
end

Senseval3() = Senseval3(datadep"Senseval 3")

MultiResolutionIterators.levelname_map(::Type{Senseval3}) = [
    :doc=>1, :contextfile=>1, :context=>1, :document=>1,
    :sent=>2, :sentence=>2,
    :word=>3, :token=>3,
    :char=>4, :character=>4
    ]


function parse_sense_annotated_word_senseval3(line::AbstractString)
    captures = match(r"<wf cmd=done.* pos=(.*) lemma=(.*) wnsn=(.*) lexsn=(\d.*:\d*|[U]|NOANSWER|NOWN).*>(.*).*</wf>", line).captures
    pos, lemma, wnsn, lexsn, word = captures
    if ';' in wnsn
        # Discard Extra Senses
        wnsn = split(wnsn, ';') |> first
        lexsn = split(lexsn, ';') |> first
    end

    SenseAnnotatedWord(pos, lemma, parse(Int, wnsn), lexsn, word)
end


function parse_senseval3file(filename)
    local sent
    lines = @NestedVector(TaggedWord,2)()
    context = Document(intern(basename(filename)), lines)

    # structure

    function new_sentence(line)
        sent = @NestedVector(TaggedWord,1)()
        push!(lines, sent)
    end


    # words
    get_tagged(line) = push!(sent, parse_tagged_word(line))
    get_sense_annotated(line) = push!(sent, parse_sense_annotated_word_senseval3(line))
    get_punc(line) = push!(sent, parse_punc(line))

    # Parse
    subparsers = [
        "<wf cmd=tag"=>          get_tagged,
        "<wf cmd=ignore"=>       get_tagged,
        "<wf cmd=done"=>         line -> occursin("lemma=", line) ? get_sense_annotated(line) : get_tagged(line),
        "<punc>"=>               get_punc,
        "<context"=>             ignore,
        "</context" =>           ignore,
        "<s" =>                  new_sentence,
        "</s" =>                 ignore
    ]

    apply_subparsers(filename,subparsers)

    return context
end

function load(corpus::Senseval3, doc_buffersize=16)
    Channel(;ctype=Document{@NestedVector(TaggedWord, 2), String}, csize=doc_buffersize) do ch
        for fn in corpus.filepaths
            doc = parse_senseval3file(fn)
            put!(ch, doc)
        end
    end
end
