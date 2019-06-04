struct SemCor{S}
    filepaths::Vector{S}
end

function SemCor(dirpath)
    @assert(isdir(dirpath), dirpath)

    if "brown1" ∈ readdir(dirpath) && "brown2" ∈ readdir(dirpath)
        tagfile_paths = joinpath.(dirpath, ["brown1", "brown2"], "tagfiles")

        paths = joinpath.(tagfile_paths[1], readdir(tagfile_paths[1]))
        append!(paths, joinpath.(tagfile_paths[2], readdir(tagfile_paths[2])))

    elseif "tagfiles" ∈ readdir(dirpath)
        paths = joinpath.(dirpath,"tagfiles", readdir(joinpath(dirpath, "tagfiles")))
    else
        paths = joinpath.(dirpath, readdir(dirpath))
    end
    SemCor(paths)
end

SemCor() = SemCor(datadep"SemCor 3.0")

MultiResolutionIterators.levelname_map(::Type{SemCor}) = [
    :doc=>1, :contextfile=>1, :context=>1, :document=>1,
    :para=>2, :paragraph=>2,
    :sent=>3, :sentence=>3,
    :word=>4, :token=>4,
    :char=>5, :character=>5
	]



function parse_sense_annotated_word(line::AbstractString)
    captures = match(r"<wf cmd=done.* pos=(.*) lemma=(.*) wnsn=(.*) lexsn=(\d.*:\d*).*>(.*).*</wf>", line).captures
	pos, lemma, wnsn, lexsn, word = captures
	if ';' in wnsn
		# Discard Extra Senses
		wnsn = split(wnsn, ';') |> first
		lexsn = split(lexsn, ';') |> first
	end

	SenseAnnotatedWord(pos, lemma, parse(Int, wnsn), lexsn, word)
end

function parse_tagged_word(line::AbstractString)
    captures = match(r"<wf cmd=.* pos=(.*).*>(.*)</wf>", line).captures
    PosTaggedWord(captures...)
end

function parse_punc(line::AbstractString)
    captures = match(r"<punc>(.*)</punc>", line).captures
    PosTaggedWord("PUNC", first(captures))
end

function parse_semcorfile(filename)
    local sent
    local para
    paras = @NestedVector(TaggedWord,3)()
    context = Document(intern(basename(filename)), paras)

    # structure
    function new_paragraph(line)
        para = @NestedVector(TaggedWord,2)()
        push!(paras, para)
    end

    function new_sentence(line)
        sent = @NestedVector(TaggedWord,1)()
        push!(para, sent)
    end


    # words
    get_tagged(line) = push!(sent, parse_tagged_word(line))
    get_sense_annotated(line) = push!(sent, parse_sense_annotated_word(line))
	get_punc(line) = push!(sent, parse_punc(line))

    # Parse
    subparsers = [
        "<wf cmd=tag"=>          get_tagged,
        "<wf cmd=ignore"=>       get_tagged,
        "<wf cmd=done"=>         line -> occursin("lemma=", line) ? get_sense_annotated(line) : get_tagged(line),
        "<punc>"=>               get_punc,
        "<context"=>             ignore,
        "</context" =>           ignore,
        "<p" =>                  new_paragraph,
        "</p" =>                 ignore,
        "<s" =>                  new_sentence,
        "</s" =>                 ignore
    ]

    apply_subparsers(filename,subparsers)

    return context
end

function load(corpus::SemCor, doc_buffersize=16)
    Channel(;ctype=Document{@NestedVector(TaggedWord, 3), String}, csize=doc_buffersize) do ch
        for fn in corpus.filepaths
            doc = parse_semcorfile(fn)
            put!(ch, doc)
        end
    end
end
