"""
    apply_subparsers(filename, subparsers)

Applies subparses to each line of the file.
`subparsers` should be a `Vector{Pair{String,Function}}`,
or similar ordered mapping from a line prefix, to a closure for how to parse that line.
This function does not return anything, instead the subparser closures (functions),
should mutate the state in the environment they are defined.
"""
function apply_subparsers(filename, subparsers)
    for line in eachline(filename)
        try
            found = false
            for (prefix, subparse) in subparsers
                if startswith(line, prefix)
                    found=true
                    subparse(line)
                    break
                end
            end
            @assert(found, "No parser for \"$line\"")
        catch ee
            @warn "Error parsing \"$line\". $ee"
            rethrow()
        end
    end
    return nothing
end

"""
    ignore(line)

Ignore lines while using subparsers.
"""
function ignore(line)
    nothing
end
