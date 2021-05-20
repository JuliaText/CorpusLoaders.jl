struct WikiGold{S}
    filepath::S
end

function init_datadeps(::Type{WikiGold})
    register(DataDep("WikiGold",
        """
        Website: https://figshare.com/articles/Learning_multilingual_named_entity_recognition_from_Wikipedia/5462500
    
        WikiGold is a manually annotated corpus over a small sample of Wikipedia articles in CoNLL format (IOB).
        It contains 145 documents, 1696 sentences and 39152 tokens.
        The words have been labelled for each of the four CONLL-03 Named Enitty classes (LOC, MISC, ORG, PER).
    
        Please cite the following publication, if you are using the corpora:
        Dominic Balasuriya, Nicky Ringland, Joel Nothman, Tara Murphy, James R. Curran, 2009. Named Entity Recognition in Wikipedia, Proceedings of the 2009 Workshop on the People’s Web Meets NLP, ACL-IJCNLP 2009, pages 10–18.
        https://www.aclweb.org/anthology/papers/W/W09/W09-3302/
        """,
        "https://s3-eu-west-1.amazonaws.com/pfigshare-u-files/9446377/wikigold.conll.txt",
            "c797a64d0cf73ed058363f77671486bcfd413e70fda1726ad4a6ba624455225f";
        post_fetch_method = function(fn)
        end
    ))
end

WikiGold() = WikiGold(datadep"WikiGold")

MultiResolutionIterators.levelname_map(::Type{WikiGold}) = [
    :doc=>1, :document=>1, :article=>1,
    :sent=>2, :sentence=>2,
    :word=>3, :token=>3,
    :char=>4, :character=>4
    ]

function parse_WikiGold_tagged_word(line::AbstractString)
    tokens_tags = split(line)
    length(tokens_tags) != 2 && throw("Error parsing line: \"$line\". Invalid Format.")
    return NerOnlyTaggedWord(tokens_tags[2], tokens_tags[1])
end

function parse_WikiGoldfile(filename)
    local sent
    local doc
    docs = @NestedVector(NerOnlyTaggedWord,3)()
    context = Document(intern(basename(filename)), docs)

    # structure
    function new_document()
        doc = @NestedVector(NerOnlyTaggedWord,2)()
        push!(docs, doc)
    end

    function new_sentence()
        sent = @NestedVector(NerOnlyTaggedWord,1)()
        push!(doc, sent)
    end

    # words
    get_tagged(line) = push!(sent, parse_WikiGold_tagged_word(line))

    new_document()
    new_sentence()
    # parse
    for line in eachline(filename)
        if length(line) == 0
            new_sentence()
        elseif startswith(strip(line), "-DOCSTART-")
            # Handle the case of Document with zero sentences before pushing into context.
            length(docs) > 0 && isempty(doc[end]) && deleteat!(doc, lastindex(doc))
            new_document()
        else
            get_tagged(line)
        end
    end

    # The file - `filename` ends with the following two lines `-DOCSTART-\n \n`.
    # The following lines removes this document containing only empty sentence at the end.
    all(isempty, docs[end]) && deleteat!(docs, lastindex(docs))

    return context
end

function load(corpus::WikiGold)
    file = readdir(corpus.filepath)[1]
    return parse_WikiGoldfile(joinpath(corpus.filepath, file))
end
