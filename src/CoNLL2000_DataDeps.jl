using DataDeps

for (file, checksum) in [("train", "bcbbe17c487d0939d48c2d694622303edb3637ca9c4944776628cd1815c5cb34"),
                        ("test", "2695b931a505b65b1d3fe2a5aa0d749edcd53d786278da6d7726714e1426fbe8")]
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
