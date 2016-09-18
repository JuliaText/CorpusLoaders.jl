# Note: SemCor is *not* XML.
module Semcor

export TaggedWord, SenseAnnotatedWord, PosTaggedWord, TaggedSentence,
		parse_sense_annotated_word, parse_tagged_word,
		lazyload_semcor, load_semcor, index_semcor,
		strip_tags, SemcorIndex, sensekey


abstract TaggedWord
immutable SenseAnnotatedWord{S<:AbstractString} <: TaggedWord
    pos::S
    lemma::S
    wnsn::Int
    lexsn::S
    word::S
end
function SenseAnnotatedWord{S}(pos::S, lemma::S, wnsn::S, lexsn::S, word::S)
end


immutable PosTaggedWord{S<:AbstractString} <: TaggedWord
    pos::S
    word::S
end

typealias TaggedSentence Vector{Semcor.TaggedWord}

sensekey(saword::SenseAnnotatedWord) = saword.lemma * "%" * saword.lexsn

function parse_sense_annotated_word(line::AbstractString)
    captures = match(r"<wf cmd=done.* pos=(.*) lemma=(.*) wnsn=(.*) lexsn=(\d.*:\d*).*>(.*).*</wf>", line).captures
    SenseAnnotatedWord(captures...)
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


function parse_semcorfile(lines)
    #GOLDPLATE: There is a nicer way to do this, lazily, with coroutines.
    sents = Vector{TaggedWord}[]

    ignore(line) = nothing
    get_tagged(line) = push!(sents[end], parse_tagged_word(line))
    get_sense_annotated(line) = push!(sents[end], parse_sense_annotated_word(line))
    get_entity_annodated(line) = push!(sents[end], parse_entity_annotated_word(line))


    subparsers = Dict(
        "<wf cmd=tag"=> get_tagged,
        "<wf cmd=ignore"=> get_tagged,
        "<wf cmd=done"=> line -> contains(line,"lemma=") ? get_sense_annotated(line) : get_tagged(line),
        "<punc>"=>ignore,
        "<context"=> ignore,
        "</context" => ignore,
        "<p" => ignore,#parastart,
        "</p" => ignore, #paraend,
        "<s" => line -> push!(sents,TaggedWord[]), #sentstart,
        "</s" => ignore#sentend
    )
    
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
    return sents
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

typealias SemcorIndex Dict{String, Vector{Tuple{Semcor.TaggedSentence, Int}}}

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
strip_tags(sent::TaggedSentence) = [w.word for w in sent]

end #module
