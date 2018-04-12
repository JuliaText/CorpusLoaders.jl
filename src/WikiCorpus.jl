struct WikiCorpus end

levels(WikiCorpus) = [:doc, :para, :sent, :word, :char]

function load(::WikiCorpus, path=datadep"English WikiCorpus v1.0")
    PenultimateType = @NestedVector(InternedString, 3)
    UltimateType = Document{PenultimateType, InternedString}

    Channel(ctype=UltimateType, csize=4) do docs
        for file in readdir(glob"*Text*", path)
            open(file, enc"latin1") do fh
                local cur_doc
                no_cur_doc = true
                while(!eof(fh))
                    para = strip(readuntil(fh, "\n\n"))
                    
                    #TODO THIS IS NOT RIGHT
                    length(para)==0 || para=="ENDOFARTICLE." || para=="</doc>" && continue

                    # deal with maybe this starts a new doc
                    doc_title_match = match(r"<doc id=.* title=\"(.*)\" nonfiltered.*>", para,1)
                    if doc_title_match != nothing
                        # Output current doc
                        if !no_cur_doc
                            put!(docs, cur_doc)
                        end
                        
                        # Start a new Doc
                        new_doc_title = first(doc_title_match.captures)
                        cur_doc = Document(InternedString(new_doc_title), PenultimateType())
                        no_cur_doc=false

                        # Done with procesing the <doc...> part of the block
                        # but there might be additional lines of content
                        parts = split(para,"\n", limit=2)
                        if length(parts)==2
                            para=parts[2]
                            #and we keep processing
                        else
                            continue # nothing more to be done
                        end
                    end

                    # an actual paragraph
                    paragraph_of_sents = split.(split(para, Sentences), Words)
                    push!(cur_doc.content, paragraph_of_sents)
                end # while(!eof)
                put!(docs, cur_doc)
            end # open
        end # for each file
    end # Channel
end
