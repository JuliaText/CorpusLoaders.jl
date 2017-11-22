
export load_challenges_semeval2007t7, lazyload_challenges_semeval2007t7, load_solutions_semeval2007t7, lazyload_solutions_semeval2007t7

immutable WsdChallenge{T<:AbstractStringVector}
    id::String
    word::String
    lemma::String
    pos::Char
    context::T
end

function parse_instance(lemma_node::XMLElement)
    word = content(lemma_node) |> lowercase
    lemma = attribute(lemma_node,"lemma")|> lowercase
    pos = first(attribute(lemma_node,"pos"))
    id = attribute(lemma_node,"id")
    id, word, lemma, pos
end



function breakdown(textnode, stopwords::Function)
    words = String[]
    instances = Tuple{Int, LightXML.XMLElement}[]
    sentences = child_elements(textnode)
    for sent in sentences
        for node in child_nodes(sent)
            if is_textnode(node)
                for line in split(content(node), "\n"; keep=false)
                    word = strip(line)
                    if !stopwords(word)
                        push!(words, word)
                    end
                end
            else
                #This is a Instance
                push!(words, strip(content(node)))
                push!(instances, (length(words), XMLElement(node)))
            end
        end
    end
    instances, words
end


"""
Lazily load semeval 2007 Task 7 corpus of challenges
Context is the sentence the word occurs in
"""
function lazyload_challenges_semeval2007t7(xdoc::XMLDocument)
    xroot = root(xdoc)
    Channel(ctype=WsdChallenge, csize=Inf) do ch
        for text_node in child_elements(xroot)
            for sentence_node in child_elements(text_node)
                sentence = punctuation_space_tokenize(content(sentence_node))
                for instance in child_elements(sentence_node) # elements (always instances) NOT nodes (can be just text)
                    context = sentence
                    put!(ch, WsdChallenge(parse_instance(instance)..., context))
                end
            end
        end
    end
end


"""
Lazily load semeval 2007 Task 7 corpus of challenges
giving every word with a window_sized context, from the document.
Filters out tokens from `stopwords`.
"""
function lazyload_challenges_semeval2007t7(xdoc::XMLDocument,
                                           window_size::Int,
                                           stopwords::Function=x->false)
    xroot = root(xdoc)
    Channel(ctype=WsdChallenge, csize=Inf) do ch
        for text_node in child_elements(xroot)
            instances, words = breakdown(text_node, stopwords)
            for (ii, instance) in instances
                context = window_excluding_center(ii, words, window_size)
                put!(ch, WsdChallenge(parse_instance(instance)..., context))
            end
        end
    end
end


"""
Load SemEval 2007 Task 7 corpus of challenges
"""
function load_challenges_semeval2007t7(args...)
    collect(lazyload_challenges_semeval2007t7(args...))
end

function lazyload_challenges_semeval2007t7(stream::IO, args...)
    xdoc = parse_string(readstring(stream))
    lazyload_challenges_semeval2007t7(xdoc, args...)
end

function lazyload_challenges_semeval2007t7(filename::AbstractString, args...)
    xdoc = parse_file(filename)
    lazyload_challenges_semeval2007t7(xdoc, args...)
end





#################################

immutable WsdSolution
    id
    lemma
    pos
    solutions
end

"""
Lazy Load SemEval 2007 Task 7 corpus of solutions
Eg `lazyload_solutions_semeval2007t7("semeval2007_t7/key/dataset21.test.key")`
"""
function lazyload_solutions_semeval2007t7(key_file="data/corpora/wsd/semeval2007_t7/key/dataset21.test.key")
    Base.Generator(eachline(key_file)) do line
        line_data, comment = split(line,"!!")
        fields = split(line_data)
        doc_id = fields[1]
        instance_id = fields[2]
        solutions = fields[3:end]

        lemma,pos = match(r"lemma=(.*)#(.)", comment).captures
        WsdSolution(instance_id, lemma, pos[1], solutions)
    end
end

"""
Load SemEval 2007 Task 7 corpus of solutions
Eg `load_solutions_semeval2007t7("semeval2007_t7/key/dataset21.test.key")`
"""
function load_solutions_semeval2007t7(keyfile::AbstractString)
    collect(lazyload_solutions_semeval2007t7(keyfile))
end

