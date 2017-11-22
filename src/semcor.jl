# Note: SemCor is *not* XML.
export TaggedWord, SenseAnnotatedWord, PosTaggedWord, TaggedSentence,
		parse_sense_annotated_word, parse_tagged_word,
		lazyload_semcor, load_semcor, index_semcor,
		strip_tags, SemcorIndex, sensekey


@enum SegmentBy NoSegmenting ByDocument ByParagraph BySentence

abstract type TaggedWord end

immutable SenseAnnotatedWord{S<:AbstractString} <: TaggedWord
    pos::S
    lemma::S
    wnsn::Int
    lexsn::S
    word::S
end


immutable PosTaggedWord{S<:AbstractString} <: TaggedWord
    pos::S
    word::S
end

const TaggedSentence = Vector{TaggedWord}



sensekey(saword::SenseAnnotatedWord) = saword.lemma * "%" * saword.lexsn

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


function parse_semcorfile(lines, segmentby::SegmentBy=BySentence)
	#GOLDPLATE: There is a nicer way to do this, lazily, with coroutines.
    chunks = Vector{TaggedWord}[]

    ignore(line) = nothing
    get_tagged(line) = push!(chunks[end], parse_tagged_word(line))
    get_sense_annotated(line) = push!(chunks[end], parse_sense_annotated_word(line))
    get_entity_annodated(line) = push!(chunks[end], parse_entity_annotated_word(line))
	push_chunk!(line) = push!(chunks, TaggedWord[]) #New Chunk

    subparsers = Dict(
        "<wf cmd=tag"=> get_tagged,
        "<wf cmd=ignore"=> get_tagged,
        "<wf cmd=done"=> line -> contains(line,"lemma=") ? get_sense_annotated(line) : get_tagged(line),
        "<punc>"=>ignore,
        "<context"=> ignore,
        "</context" => ignore,
        "<p" => ignore,#parastart,
        "</p" => ignore, #paraend,
        "<s" => ignore, #sentstart,
        "</s" => ignore#sentend
    )

	if segmentby==ByDocument
		subparsers["<context"]=push_chunk!
	elseif	segmentby == ByParagraph
		subparsers["<p"]=push_chunk!
	elseif segmentby == BySentence
		subparsers["<s"]=push_chunk!
	end

	for line in lines
        try
            found = false
            for (prefix, subparse) in subparsers
                if startswith(line, prefix)
                    found=true
                    subparse(line)
                    break
                end
            end
            @assert(found, "No parser for \"$line\"")
        catch ee
            error("Error parsing \"$line\". $ee")
        end
    end
    return chunks
end


"""
Load Semcor lazily, returns a sequence of Tuples
where the first element is a word, and the next is it's content
"""
function lazyload_semcor(tagdir_path::AbstractString,
						 window_size::Int)
    Task() do
        for filename in [joinpath(tagdir_path, d) for d in readdir(tagdir_path)]
            document_chunks = parse_semcorfile(eachline(filename), ByDocument)
			for document::Vector{TaggedWord} in document_chunks
				indexed_instances = ((ii, instance) for (ii,instance) in enumerate(document)
													if  isa(instance, SenseAnnotatedWord))
				for (ii, instance) in indexed_instances
					context = window_excluding_center(ii, document, window_size)
					produce((instance, context))
				end
			end
		end
    end
end




"""
Load up a semcor corpus, lazily -- one file at a time.
For word with multiple senses defined, (~187 in Semcore 2.1),
the first is kept and all others discarded.

Eg
````
lazyload_semcor("semcor2.1/brown1/tagfiles/")
```
"""
function lazyload_semcor(tagdir_path::AbstractString)
    Task() do
        for filename in [joinpath(tagdir_path, d) for d in readdir(tagdir_path)]
            produce.(parse_semcorfile(eachline(filename)))
        end
    end
end


"""Load up a semcor corpus. Eg `load_semcor("corpora/semcor2.1/brown1/tagfiles/")`"""
load_semcor(tagdir_path::AbstractString) = collect(lazyload_semcor(tagdir_path))

const SemcorIndex =  Dict{String, Vector{Tuple{TaggedSentence, Int}}}

"""
Index a semcor stream, by word (sense-key),
so that examples of sentenced where that word was used can found.
Each value of the dictionary is a vector of (sentence, position),
where 

```
iter = lazyload_indexed_semcor("corpora/semcor2.1/brown1/tagfiles/")
uses = index_semcor(iter)
for (sent, position) in  uses["produce%2:39:01::"]
	for (ii, word) in enumerate(strip_tags(sent))
		if ii == keyword_position
			print("**", word, "** ")
		else
			print(word, " ")
		end
	end
	println()
end
```
"""
function index_semcor(tagged_sentence_stream)
    uses = SemcorIndex()
    for sent::TaggedSentence in tagged_sentence_stream
        for (index, word) in enumerate(sent)
            if typeof(word)<:SenseAnnotatedWord
                key = sensekey(word)
				uses_of_word = get!(Vector{TaggedSentence}, uses, key)
                push!(uses_of_word, (sent, index))
            end
        end
    end
    uses
end

"""Remove all the tagging information, returning just tokenized words"""
strip_tags(sent) = [w.word for w in sent]

