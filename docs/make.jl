using Documenter
using CorpusLoaders

makedocs(modules = [CorpusLoaders],
         sitename = "CorpusLoaders",
         format = Documenter.HTML(
            assets = ["assets/favicon.ico"],
         ),
         pages = [
             "Home" => "index.md",
             "CoNLL" => "CoNLL.md",
             "CoNLL2000" => "CoNLL2000.md",
             "IMDB" => "IMDB.md",
             "SemCor" => "SemCor.md",
             "Senseval3" => "Senseval3.md",
             "StanfordSentimentTreebank" => "StanfordSentimentTreebank.md",
             "Twitter" => "Twitter.md",
             "WikiCorpus" => "WikiCorpus.md",
             "WikiGold" => "WikiGold.md",
             "API References" => "APIReference.md"
        ])


deploydocs(deps = Deps.pip("mkdocs", "python-markdown-math"),
           repo = "github.com/oxinabox/CorpusLoaders.jl.git"
           )
