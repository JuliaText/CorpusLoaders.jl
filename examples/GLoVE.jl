#=
# This is an implementation of
# Glove: Global vectors for word representation
# J Pennington, R Socher, C Manning
# Proceedings of the 2014 conference on empirical methods in natural language
# https://nlp.stanford.edu/pubs/glove.pdf
# (Made from the paper without reference to the source code)
#=#


using CorpusLoaders
using MLDataUtils
using StringInterning
using DataStructures
using Optim
#using CatViews

function coocurrs(data, hw=5)
    coocurs = DefaultDict{Tuple{InternedString,InternedString}, Float32}(0f0)
    distance_weights = [1f0/abs(d-hw) for d in 0:2hw  if d!=hw]
    for (word_, window) in slidingwindow(i->[i-hw:i-1; i+1:i+hw], data, 1, stride=1)
        word = first(word_)
        for (weight, coword) in zip(distance_weights, window)
            coocurs[(word,coword)]+=weight
        end
    end

    encoding = labelenc(last.(collect(keys(coocurs))))
    coocurs_mat = spzeros(Float32, nlabel(encoding), nlabel(encoding))
    for (coocurance, score) in coocurs
        inds = convertlabel.(LabelEnc.Indices(nlabel(encoding)), coocurance, encoding)
        coocurs_mat[inds...] = score
    end
    coocurs_mat, encoding
end

f(x, xmax=100f0, α=3/4)::Float32 = x>xmax ? 1f0 : (x/xmax)^α

function glove(data, ndim=300, halfwindow=5)
    xco, encoding = coocurrs(data, halfwindow)
    # sum f.(xco)

    nwords = nlabel(encoding)
    ws = 0.01randn(ndim, nwords)
    vs = 0.01randn(ndim, nwords)
    bs = 0.01randn(nwords)
    cs = 0.01randn(nwords)

    optimize(loss, [xco, ws, vs, bs, cs])
    [ws vs], encoding
end

loss(params) = loss(params...)

function loss(xco, ws, vs, bs, cs)
    loss = 0f0
    @inbounds for (i, j, x) in zip(findnz(xco)...)
         loss += f(x)(ws[:,i]⋅vs[:,j] + bs[i] + cs[j] - log(x))^2
    end
end
