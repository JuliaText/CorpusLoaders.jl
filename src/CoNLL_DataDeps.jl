using DataDeps

register(DataDep("CoNLL 2003",
    """
    Website: https://www.clips.uantwerpen.be/conll2003/ner/
    Data Website: https://github.com/davidsbatista/NER-datasets

    The Seventh Conference on Natural Language Learning (CoNLL-2003) was held on May 31 and June 1, 2003 in association with HLT-NAACL 2003 in Edmonton, Canada.

    The details of the task are in the following paper, please cite the following publication if you are using the corpora.

    Erik F. Tjong Kim Sang, Fien De Meulder. "Introduction to the CoNLL-2003 Shared Task: Language-Independent Named Entity Recognition." Proceedings of CoNLL-2003, Edmonton, Canada, 2003.
    https://www.clips.uantwerpen.be/conll2003/pdf/14247tjo.pdf
    """,
    "https://github.com/davidsbatista/NER-datasets/archive/master.zip",
    "db332cddb12f123b92fc6653a582eec1b3f14e6741f9c6e0bf5d960c78dee3a0";
    post_fetch_method = function(fn)
        unpack(fn)
        dir = "NER-datasets-master"
        innerdir = joinpath(dir, "CONLL2003")
        innerfiles = readdir(innerdir)
        # Move everything to current directory, under same name
        mv.(joinpath.(innerdir, innerfiles), innerfiles)
        rm(dir, recursive=true)
    end
))
