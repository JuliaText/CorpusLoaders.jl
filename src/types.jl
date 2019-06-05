## A General Type that represents a wrapper around an Interator.
# The inner iterator must be in the `content` field

abstract type AnnotatedIterator{T} end
function Base.IteratorEltype(::Type{<:AnnotatedIterator{T}}) where T
     Base.IteratorEltype(T)
 end
function Base.IteratorSize(::Type{AnnotatedIterator{T}}) where T
    Base.IteratorSize(T)
end
function Base.IndexStyle(::Type{AnnotatedIterator{T}}) where T
    Base.IndexStyle(T)
end

Base.iterate(aiter::AnnotatedIterator) = Base.iterate(aiter.content)
Base.iterate(aiter::AnnotatedIterator, state) = Base.iterate(aiter.content, state)

Base.length(aiter::AnnotatedIterator) = length(aiter.content)
Base.lastindex(aiter::AnnotatedIterator) = lastindex(aiter.content)

Base.getindex(aiter::AnnotatedIterator, args...) = getindex(aiter.content, args...)
Base.setindex!(aiter::AnnotatedIterator, args...) = setindex!(aiter.content, args...)

####

struct Document{T, S} <: AnnotatedIterator{T}
    title::S
    #topics::Vector{String}
    content::T
end

Document(content)=Document(nothing,content)
title(doc::Document) = doc.title

#### Making nice with MultiResolutionIterators

@generated function _call_on_content(ff, aiter::T) where T<:AnnotatedIterator
    constructor = T.name.name # Toss away the type params
    args =  map(fieldnames(T)) do fn
        fieldval = :(getfield(aiter, $(Meta.quot(fn))))
        if fn == :content
            # work  only on the content
            Expr(:call, :ff, fieldval)
        else
             # keep everything else as is
            fieldval
        end
    end
    Expr(:call, constructor, args...)
end


function MultiResolutionIterators.apply(ff, aiter::T)::AnnotatedIterator where T<:AnnotatedIterator
    _call_on_content(aiter) do content
        MultiResolutionIterators.apply(ff, content)
    end
end

########################

abstract type TaggedWord end

struct SenseAnnotatedWord <: TaggedWord
    pos::String
    lemma::String
    wnsn::Int
    lexsn::String
    word::String
    function SenseAnnotatedWord(pos, lemma, wnsn, lexsn, word)
        new(intern(pos), intern(lemma), wnsn, intern(lexsn), intern(word))
    end
end

struct PosTaggedWord <: TaggedWord
    pos::String
    word::String
    function PosTaggedWord(pos, word)
        new(intern(pos), intern(word))
    end
end

struct NERTaggedWord <: TaggedWord
    ner_tag::String
    chunk::String
    pos::String
    word::String
    function NERTaggedWord(ner_tag, chunk, pos, word)
        new(intern(ner_tag), intern(chunk), intern(pos), intern(word))
    end
end

const TaggedSentence = Vector{TaggedWord}

word(tword::TaggedWord) = tword.word
word(str::AbstractString) = str
sensekey(saword::SenseAnnotatedWord) = saword.lemma * "%" * saword.lexsn
named_entity(ner_word::NERTaggedWord) = ner_word.ner_tag

#######################

macro NestedVector(T::Symbol, N::Int)
    code=Expr(:curly)
    cur_code = code
    for lvl in 1:N-1
        new_cur_code=Expr(:curly)
        push!(cur_code.args,:Vector)
        push!(cur_code.args, new_cur_code)
        cur_code = new_cur_code
    end
    push!(cur_code.args,:Vector)
    push!(cur_code.args, Symbol(T))
    esc(code)
end
