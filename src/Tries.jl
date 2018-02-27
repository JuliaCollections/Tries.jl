__precompile__()

module Tries

    import Base: start, next, done, getindex, setindex!, get,
                 haskey, keys

    using Compat: uninitialized, Nothing, Cvoid, AbstractDict

    export Trie, subtrie, keys_with_prefix, path

    include("trie.jl")
end
