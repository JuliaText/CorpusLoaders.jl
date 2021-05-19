struct Senseval3{S}
    filepaths::Vector{S}
end

function init_datadeps(::Type{Senseval3})
    register(DataDep("Senseval 3",
        """
        Website: http://web.eecs.umich.edu/~mihalcea/senseval/senseval3/index.html
        Data Website: http://web.eecs.umich.edu/~mihalcea/downloads.html#sensevalsemcor
        Prepared by: Rada Mihalcea, Timothy Chklovski, Adam Kilgarriff
        Current Maintainer: Rada Mihalcea

        Senseval-3 took place in March-April 2004, followed by a workshop held in July 2004 in Barcelona, in conjunction with ACL 2004.
        This is corpus was updated by Rada Mihalcea with the word senses according to WordNet 1.7.1, 2.0, 2.1, 3.0.

        The details of the task are in the following paper, please cite the following publication if you are using the corpora.

        Mihalcea, Rada, Timothy Chklovski, and Adam Kilgarriff. "The Senseval-3 English lexical sample task." In Proceedings of SENSEVAL-3, the third international workshop on the evaluation of systems for the semantic analysis of text. 2004.
        http://www.aclweb.org/anthology/W04-0807
        """,
        "http://web.eecs.umich.edu/~mihalcea/downloads/senseval.semcor/senseval3.semcor.tar.gz",
        "ab5a1230d1109ac7847b86babf442b2006276d73e6ee47d67f7f7c372c50d9eb";
        post_fetch_method = fn -> begin
            unpack(fn)
            innerdir = "senseval3.semcor"
            innerfiles = readdir(innerdir)
            # Move everything to current directory, under same name
            mv.(joinpath.(innerdir, innerfiles), innerfiles)
            rm(innerdir)
        end
    ))
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
