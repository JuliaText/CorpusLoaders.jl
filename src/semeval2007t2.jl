using LightXML

export load_challenges_semeval2007t7, lazyload_challenges_semeval2007t7, load_solutions_semeval2007t7, lazyload_solutions_semeval2007t7

immutable WsdChallenge
    id::String
    word::String
    lemma::String
    pos::Char
    context::Vector{String}
end

"""
Lazily load semeval 2007 Task 7 corpus of challenges
Eg `lazyload_challenges_semeval2007t7("semeval2007_t7/test/eng-coarse-all-words.xml")`
"""
function lazyload_challenges_semeval2007t7(xml_file::AbstractString)
    xdoc = parse_file(xml_file)
    xroot = root(xdoc)
    Task() do
        for text_node in child_elements(xroot)
            #@show text_node
            #text = child_nodes(text_node) |> collect
            #println(text)
            for sentence_node in child_elements(text_node)
                sentence = punctuation_space_tokenize(content(sentence_node))

                for lemma_node in child_elements(sentence_node)
                    word = content(lemma_node) |> lowercase
                    lemma = attribute(lemma_node,"lemma")|> lowercase
                    pos = first(attribute(lemma_node,"pos"))
                    id = attribute(lemma_node,"id")
                    context = filter(w->w!=word, sentence)
                    produce(WsdChallenge(id, word, lemma, pos, context))
                end
            end
        end
    end
end

"""
Load SemEval 2007 Task 7 corpus of challenges
Eg `lazyload_challenges_semeval2007t7("semeval2007_t7/test/eng-coarse-all-words.xml")`
"""
function load_challenges_semeval2007t7(xml_file::AbstractString)
	collect(lazyload_challenges_semeval2007t7(xml_file))
end

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
    Task() do
        for line in eachline(key_file)
            line_data, comment = split(line,"!!")
            fields = split(line_data)
            doc_id = fields[1]
            instance_id = fields[2]
            solutions = fields[3:end]

            lemma,pos = match(r"lemma=(.*)#(.)", comment).captures
            produce(WsdSolution(instance_id, lemma, pos[1], solutions))
        end
    end
end

"""
Load SemEval 2007 Task 7 corpus of solutions
Eg `load_solutions_semeval2007t7("semeval2007_t7/key/dataset21.test.key")`
"""
function load_solutions_semeval2007t7(keyfile::AbstractString)
	collect(lazyload_solutions_semeval2007t7(keyfile))
end


