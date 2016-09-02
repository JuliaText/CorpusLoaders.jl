using Documenter
using CorpusLoaders

makedocs(modules=[CorpusLoaders,
				  CorpusLoaders.Semcor,
				  CorpusLoaders.Semeval2007t7
				  ])


deploydocs(deps   = Deps.pip("mkdocs", "python-markdown-math"),
			repo = "github.com/oxinabox/CorpusLoaders.jl.git",
			julia  = "0.5.0",
			osname = "linux")
