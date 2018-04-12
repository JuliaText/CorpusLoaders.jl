struct WikiCorpus end

    levels(WikiCorpus) = [:doc, :para, :sent, :word, :char]

    function load(::WikiCorpus, path=datadep"English WikiCorpus v1.0")
        PenultimateType = @NestedVector(InternedString, 3)
        UltimateType = Document{PenultimateType, InternedString}

        Channel(ctype=UltimateType, csize=64) do docs
            for file in readdir(glob"*Text*", path)
                open(file, enc"latin1") do fh
                    local cur_doc
                    print(file)
                    while(!eof(fh))
                        para = strip(readuntil(fh, "\n\n"))
                        length(para)==0 || para=="ENDOFARTICLE." || para=="</doc>" && continue

                        # deal with maybe this starts a new doc
                        doc_title_match = match(r"<doc id=.* title=\"(.*)\" nonfiltered.*>", para,1)
                        if doc_title_match != nothing
                            #Start a new Doc
                            if isdefined(:cur_doc) #has it been set?
                                put!(docs, cur_doc)
                            end
                            new_doc_title = first(doc_title_match.captures)
                            cur_doc = Document(InternedString(new_doc_title), PenultimateType())
                            continue
                        end

                        # an actual paragraph
                        paragraph_of_sents = split.(split(para, Sentences), Words)
                        push!(cur_doc.content, paragraph_of_sents)
                    end
                    put!(docs, cur_doc)
                end

        end

    end



end
