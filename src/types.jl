## A General Type that represents a wrapper around an Interator.
# The inner iterator must be in the `content` field

abstract type AnnotatedIterator{T} end
function Base.iteratoreltype(::Type{<:AnnotatedIterator{T}}) where T
     Base.iteratoreltype(T)
 end
function Base.iteratorsize(::Type{AnnotatedIterator{T}}) where T
    Base.iteratorsize(T)
end
function Base.IndexStyle(::Type{AnnotatedIterator{T}}) where T
    Base.IndexStyle(T)
end

Base.start(aiter::AnnotatedIterator)=Base.start(aiter.content)
Base.next(aiter::AnnotatedIterator, state)=Base.next(aiter.content, state)
Base.done(aiter::AnnotatedIterator, state)=Base.done(aiter.content, state)

Base.length(aiter::AnnotatedIterator) = length(aiter.content)
Base.endof(aiter::AnnotatedIterator) = endof(aiter.content)

Base.getindex(aiter::AnnotatedIterator, args...) = getindex(aiter.content, args...)
Base.setindex!(aiter::AnnotatedIterator, args...) = setindex!(aiter.content, args...)

####

struct Document{T, S} <: AnnotatedIterator{T}
    title::S
    #topics::Vector{String}
    content::T
end

Document(content)=Document(nothing,content)

#### Making nice with MultiResolutionIterators


@generated function _call_on_content(ff, aiter::T) where T<:AnnotatedIterator
    constructor = T.name.name # Toss away the type params
    args =  map(fieldnames(T)) do fn
        fieldval = :(getfield(aiter, $(Meta.quot(fn))))
        if fn == :content
            # consolidate only the content
            #Expr(:call, :ff, Expr(:call, :getfield, :aiter, fn))
            Expr(:call, :ff, fieldval)
        else
             # keep everything else as is
            #Expr(:call, :getfield, :aiter, fn)
            fieldval
        end
    end
    Expr(:call, constructor, args...)
end


#_call_on_content(consolidate, Document("foos",["a", "b", "c"]))


function MultiResolutionIterators.consolidate(aiter::T)::AnnotatedIterator where T<:AnnotatedIterator
    _call_on_content(consolidate, aiter)
end

function MultiResolutionIterators.apply(ff, aiter::T)::AnnotatedIterator where T<:AnnotatedIterator
    _call_on_content(aiter) do content
        @show typeof(content)
        MultiResolutionIterators.apply(ff, content)
    end
end


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
