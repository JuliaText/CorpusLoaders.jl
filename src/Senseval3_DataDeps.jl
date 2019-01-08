using DataDeps

register(DataDep("Senseval 3",
    """
    Website: http://web.eecs.umich.edu/~mihalcea/senseval/senseval3/index.html
    Data Website: http://web.eecs.umich.edu/~mihalcea/downloads.html#sensevalsemcor
    Prepared by: Rada Mihalcea, Timothy Chklovski, Adam Kilgarriff
    Current Maintainer: Rada Mihalcea

    Senseval-3 took place in March-April 2004, followed by a workshop held in July 2004 in Barcelona, in conjunction with ACL 2004.
    This is corpus was updated by Rada Mihalcea with the word senses according to WordNet 1.7.1, 2.0, 2.1, 3.0.

    The details of the task are in the following paper, please cite the following publication if you are using the corpora.

    Mihalcea, Rada, Timothy Chklovski, and Adam Kilgarriff. "The Senseval-3 English lexical sample task." In Proceedings of SENSEVAL-3, the third international workshop on the evaluation of systems for the semantic analysis of text. 2004.
    http://www.aclweb.org/anthology/W04-0807
    """,
    "http://web.eecs.umich.edu/~mihalcea/downloads/senseval.semcor/senseval3.semcor.tar.gz",
    "ab5a1230d1109ac7847b86babf442b2006276d73e6ee47d67f7f7c372c50d9eb";
    post_fetch_method = fn -> begin
        unpack(fn)
        innerdir = "senseval3.semcor"
        innerfiles = readdir(innerdir)
        # Move everything to current directory, under same name
        mv.(joinpath.(innerdir, innerfiles), innerfiles)
        rm(innerdir)
    end
))
