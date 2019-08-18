using DataDeps

for (file, checksum) in [("train", "82033cd7a72b209923a98007793e8f9de3abc1c8b79d646c50648eb949b87cea"),
                        ("test", "73b7b1e565fa75a1e22fe52ecdf41b6624d6f59dacb591d44252bf4d692b1628")]
    register(DataDep("CoNLL 2000 $file",
        """
        Website: https://www.clips.uantwerpen.be/conll2000/chunking/$file.txt.gz
        Data Website:https://www.clips.uantwerpen.be/conll2000/chunking/

        The Fourth Conference on Natural Language Learning (CoNLL-2003) was held on September 13 and September 14, 2000 in conjunction with ICGI-2000 and LLL-2000 at the Instituto Superior Técnico in Lisbon, Portugal.

        The details of the task are in the following paper, please cite the following publication if you are using the corpora.

        Erik F. Tjong Kim Sang, Sabine Buchholz. "Introduction to the CoNLL-2000 Shared Task: Chunking." In: Proceedings of CoNLL-2000 and LLL-2000, pages 127-132, Lisbon, Portugal, 2000.
        https://www.clips.uantwerpen.be/conll2000/pdf/12732tjo.pdf
        """,
        "https://www.clips.uantwerpen.be/conll2000/chunking/$file.txt.gz",
        checksum;
        post_fetch_method = unpack
    ))
end
