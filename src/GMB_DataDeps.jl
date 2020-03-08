using DataDeps


for (ver, checksum) in [("1.0.0", "16814254fe194d55a2fcc24858aa76d71de3c49e495bd98478cc7345e766d8b7"),
            ("1.1.0", "0495577ac3a87c2a64fe6189798ea046de0f44943dfb7b60fe38cf648d34c421"),
            ("2.0.0", "70b9eb7ca0dc9d67655f9d671d40be10aeff490f0bea4f10cb1946127b74c102"),
            ("2.1.0", "93fbae725f0125dedb7369403fda1dace85b2dcd8a523ed80af23e863b18ef2c"),
            ("2.2.0", "0714f07dbcb84a215d668f3ee85892fa8fa4a8154439662eb7529413367b8f56")]

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
