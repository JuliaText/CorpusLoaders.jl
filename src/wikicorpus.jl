export load_wikicorpus

"""
    load_wikicorpus(path = datadep"Wikicorpus-en raw"; sentence_min_length = 5)

Lazily loads text from wikicorpus.

 - If there are less than `sentence_min_length` tokens on a line it is skipped.
   - this gets rid of a lot of cruft like lists, titles, data-blocks etc
"""
function load_wikicorpus(path = datadep"Wikicorpus-en raw"; sentence_min_length = 5)
    Channel(ctype=InternedString, csize=2048) do ch
        for file in readdir(glob"*Text*", path)
            for sent in eachline(file, enc"latin1")
                # Note: wikicorpus is not correct XML
                # For now we will just drop the document identifying stuff
                if any(startswith.(sent, ["<doc id", "</doc>", "ENDOFARTICLE."]))
                    continue
                end
                tokens = punctuation_space_tokenize(sent)
                if length(tokens) < sentence_min_length
                    continue
                else
                    put!.(ch, tokens)
                end
            end
        end
    end
end
