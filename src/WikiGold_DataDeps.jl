using DataDeps

register(DataDep("WikiGold",
    """
    WikiGold Corpus
    """,
    "https://raw.githubusercontent.com/pritishuplavikar/Named-Entity-Recognition/master/wikigold.conll.txt",
    post_fetch_method = function(fn)
        println(readdir("."))
    end
))
