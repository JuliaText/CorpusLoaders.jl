struct Document{T, S}
    title::S
    #topics::Vector{String}
    content::T
end

Document(content)=Document(nothing,content)

Base.start(doc::Document)=Base.start(doc.content)
Base.next(doc::Document, state)=Base.next(doc.content, state)
Base.done(doc::Document, state)=Base.done(doc.content, state)
Base.iteratoreltype(::Type{Document{T}}) where T = Base.iteratoreltype(T)
Base.iteratorsize(::Type{Document{T}}) where T = Base.iteratorsize(T)
Base.length(doc::Document) = length(doc.content)

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
