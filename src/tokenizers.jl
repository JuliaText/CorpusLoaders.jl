
export poormans_tokenize, punctuation_space_tokenize

"""Tokenizes by removing punctuation and splitting on spaces"""
function poormans_tokenize(source::AbstractString)
    cleaned = filter(s->!ispunct(s), lowercase(source))
    split(cleaned)
end

"""Tokenizes by removing punctuation, unless it occurs inside of a word"""
function punctuation_space_tokenize(source::AbstractString)
    preprocced = lowercase(source)
    pass1=replace(preprocced,r"[[:punct:]]*[[:space:]][[:punct:]]*"," ")
    pass2=replace(pass1,r"[[:punct:]]*$|^[[:punct:]]*","")
    split(pass2)
end


#TODO: Consider Implementing Robert MacIntyre's Penn Treebanks Tokenizer
#TODO: ^ http://www.cis.upenn.edu/~treebank/tokenizer.sed
#TODO: ^ However it requires sentence tokenizing to be done first
