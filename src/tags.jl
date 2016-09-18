export pennPOStoWordNetPOS, brownPOStoWordNetPOS

const WORDNET_TAGSET = ('a', 'v', 'n', 'r', 's')

"""
Convert a Penn Treebank part of speech tag to a 
"""
function pennPOStoWordNetPOS(tag::AbstractString)
	cc = lowercase(first(tag))
	if cc=='j' #Penn uses J* for adjectoves, Brown uses 'a'
		cc = 'a'
	end
	if cc ∉ WORDNET_TAGSET
		throw(KeyError("There is no WordNet POS Tag for $tag"))
	end
	return cc
end

"""
Converts a Brown part of speech tag to a wordnet one.
Coincientally identical to the conventing a Penn Treebank tag to wordnet.
"""
const brownPOStoWordNetPOS = pennPOStoWordNetPOS

