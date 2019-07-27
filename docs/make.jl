using Documenter
using CorpusLoaders

makedocs(modules = [CorpusLoaders],
         sitename = "CorpusLoaders",
         pages = [
             "Home" => "index.md",
             "CoNLL" => "CoNLL.md",
             "IMDB" => "IMDB.md",
             "SemCor" => "SemCor.md",
             "Senseval3" => "Senseval3.md",
             "StanfordSentimentTreebank" => "StanfordSentimentTreebank.md",
             "Twitter" => "Twitter.md",
             "WikiCorpus" => "WikiCorpus.md",
             "API References" => "APIReference.md"
        ])


deploydocs(deps = Deps.pip("mkdocs", "python-markdown-math"),
           repo = "github.com/oxinabox/CorpusLoaders.jl.git"
           )
