using DataDeps


for (ver, checksum) in [("1.0.0", "e151d953a0316c5712a52d56a5702f24cc1dc8f22425955821113437ec43a3b8"),
            ("1.1.0", "3830e7071e43ca9e659d51f2f7c5e5afea9e233993251e9f45d628caa6a372c6"),
            ("2.0.0", "30a700e2509eb1a484357a1f1e5f7f06ef8e9516267413061b7dfccdf8ba4215"),
            ("2.1.0", "e4bd7d43f7b2c1618f896784c2b7df3acde3bfe93ef4fd6e5a7a196f54b6a4f9"),
            ("2.2.0", "dd12f2617f745ea3cafa348c60ee374c804be238d184bcf91db7bd9f90261625")]

    register(DataDep("GMB $ver",
        """
        Website: https://gmb.let.rug.nl/data.php
        Orignal Author: Bos, Johan and Basile, Valerio and Evang, Kilian and Venhuizen, Noortje and Bjerva, Johannes
        
        The Groningen Meaning Bank (GMB) consists of public domain English texts with corresponding syntactic and semantic representations.
        The GMB is developed at the University of Groningen. A multi-lingual version of the GMB is the Parallel Meaning Bank. 
        A thorough description of the GMB can be found in the Handbook of Linguistic Annotation.

        Please cite the following publication if you use the corpora:
        Bos, Johan and Basile, Valerio and Evang, Kilian and Venhuizen, Noortje and Bjerva, Johannes. " Handbook of Linguistic Annotation, Publisher: Springer Netherlands, Editors: Nancy Ide, James Pustejovsky, pp.463-496."
        """,
        "https://gmb.let.rug.nl/releases/gmb-$(ver).zip",
        checksum;
        post_fetch_method = fn -> begin
            unpack(fn)
            innerdir = "gbm-$(ver)"
            innerfiles = readdir(innerdir)
            # Move everything to current directory, under same name
            mv.(joinpath.(innerdir, innerfiles), innerfiles)
            rm(innerdir)
        end
    ))
end
