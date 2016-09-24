using Documenter
using CorpusLoaders

makedocs(modules=[CorpusLoaders])


deploydocs(deps   = Deps.pip("mkdocs", "python-markdown-math"),
			repo = "github.com/oxinabox/CorpusLoaders.jl.git",
			osname = "linux")
