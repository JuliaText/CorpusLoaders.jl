using DataDeps


for (ver, checksum) in [("1.6", nothing),
            ("1.7", nothing),
            ("1.7.1", nothing),
            ("2.0", nothing),
            ("3.0", "a8000014d6fc864f8bd9d83c62be601151cadd617c6554a39a1ad38b4b3f017b")]

    RegisterDataDep("SemCor $ver",
        """
        Website: http://web.eecs.umich.edu/%7Emihalcea/downloads.html#semcor
        Orignal Author: George A. Miller et al.
        Maintainer: Rada Mihalcea
        For WordNet version $ver

        This is SemCor orginally developed along side WordNet.
        It was automatically updated with the new numbering beyond WordNet 1.6,  by Rada Mihalcea

        Please cite the following publication if you use the corpora:
        George A. Miller, Claudia Leacock, Randee Tengi, and Ross T. Bunker. (1993). "A Semantic Concordance." In: Proceedings of the 3 DARPA Workshop on Human Language Technology.
        """,
        "http://web.eecs.umich.edu/~mihalcea/downloads/semcor/semcor$(ver).tar.gz",
        checksum;
        post_fetch_method = fn -> begin
            unpack(fn)
            innerdir = "semcor$(ver)"
            innerfiles = readdir(innerdir)
            # Move everything to current directory, under same name
            mv.(joinpath.(innerdir, innerfiles), innerfiles)
            rm(innerdir)
        end
    )
end
