struct SemCor{S}
    filepaths::Vector{S}
end

function init_datadeps(::Type{SemCor})
    for (ver, checksum) in [("1.6", "16814254fe194d55a2fcc24858aa76d71de3c49e495bd98478cc7345e766d8b7"),
                ("1.7", "0495577ac3a87c2a64fe6189798ea046de0f44943dfb7b60fe38cf648d34c421"),
                ("1.7.1", "70b9eb7ca0dc9d67655f9d671d40be10aeff490f0bea4f10cb1946127b74c102"),
                ("2.0", "93fbae725f0125dedb7369403fda1dace85b2dcd8a523ed80af23e863b18ef2c"),
                ("2.1", "0714f07dbcb84a215d668f3ee85892fa8fa4a8154439662eb7529413367b8f56"),
                ("3.0", "a8000014d6fc864f8bd9d83c62be601151cadd617c6554a39a1ad38b4b3f017b")]

        register(DataDep("SemCor $ver",
            """
            Website: http://web.eecs.umich.edu/%7Emihalcea/downloads.html#semcor
            Orignal Author: George A. Miller et al.
            Maintainer: Rada Mihalcea
            For WordNet version $ver

            This is SemCor orginally developed along side WordNet.
            It was automatically updated with the new numbering beyond WordNet 1.6,  by Rada Mihalcea

            Please cite the following publication if you use the corpora:
            George A. Miller, Claudia Leacock, Randee Tengi, and Ross T. Bunker. (1993). "A Semantic Concordance." In: Proceedings of the 3 DARPA Workshop on Human Language Technology.
            """,
            "http://web.eecs.umich.edu/~mihalcea/downloads/semcor/semcor$(ver).tar.gz",
            checksum;
            post_fetch_method = fn -> begin
                unpack(fn)
                innerdir = "semcor$(ver)"
                innerfiles = readdir(innerdir)
                # Move everything to current directory, under same name
                mv.(joinpath.(innerdir, innerfiles), innerfiles)
                rm(innerdir)
            end
        ))
    end
end

"""
    SemCor()

Creates a SemCor instance for lazy loading the corpus.

# Example Usage

```jldoctest
julia> corp = load(SemCor())
Channel{CorpusLoaders.Document{Array{Array{Array{CorpusLoaders.TaggedWord,1},1},1},String}}(sz_max:16,sz_curr:16)

julia> index = Dict{String, Vector{Vector{String}}}()
Dict{String,Array{Array{String,1},1}} with 0 entries

julia> for sentence in flatten_levels(corp, (!lvls)(SemCor, :sent, :word))
           multisense_words = filter(x->x isa SenseAnnotatedWord,  sentence)
           context_words = word.(sentence)
           for target in multisense_words
               word_sense = sensekey(target)
               uses = get!(Vector{Vector{String}}, index, word_sense)
               push!(uses, context_words)
           end
       end

julia> index["abandon%1:07:00::"]
1-element Array{Array{String,1},1}:
 String["in", "his", "motherland", ";", "in", "the", "spacious", "hunting_grounds", "of", "``"  …  ",", "color", ",", "dance", ",", "design", ",", "and", "thought", "."]

julia> index["abandon%2:38:00::"]
2-element Array{Array{String,1},1}:
 String["Jonathan", "wrote", "grimly", "of", "the", "destruction", "of", "Harpers_Ferry", "before", "they"  …  "First_Brigade", "had", "destroyed", "all", "the", "rolling_stock", "of", "the", "B_+_O_Railroad", "."]
 String["The", "expense", "of_this", "type", "of", "organization", "in", "religious", "life", ","  …  "in", "congregations", "illumines", "the", "nature", "of", "the", "Protestant", "development", "."]

```

SemCor is a classical Sense Annotated Corpus.

It has a structure of documents, paragraphs, sentences, words.

The words are either tagged with part of speech, or tagged with full lemma, part of speech and sensekey.

We expose the word function to get back the words, and the sensekey function to extract the sense key.

Texts semantically annotated with WordNet 1.6 senses (created at Princeton University), and automatically mapped to WordNet 1.7, WordNet 1.7.1, WordNet 2.0, WordNet 2.1, WordNet 3.0 to get: 
SemCor 1.7 
SemCor 1.7.1 
SemCor 2.0 
SemCor 2.1 
SemCor 3.0

Please cite the following publication if you use the corpora:
        George A. Miller, Claudia Leacock, Randee Tengi, and Ross T. Bunker. (1993). "A Semantic Concordance." In: Proceedings of the 3 DARPA Workshop on Human Language Technology.

"""
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
