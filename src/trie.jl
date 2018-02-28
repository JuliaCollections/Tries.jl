const TrieKey = Union{AbstractString, AbstractVector}

mutable struct Trie{K, V, E}
    value::V
    children::Dict{E, Trie{K, V, E}}
    is_key::Bool

    function Trie{K, V, E}() where {K, V, E}
        self = new{K, V, E}()
        self.children = Dict{E, Trie{K, V, E}}()
        self.is_key = false
        self
    end

    function Trie{K, V, E}(ks, vs) where {K, V, E}
        t = Trie{K, V, E}()
        for (k, v) in zip(ks, vs)
            t[k] = v
        end
        return t
    end

    function Trie{K, V, E}(kv) where {K, V, E}
        t = Trie{K, V, E}()
        for (k,v) in kv
            t[k] = v
        end
        return t
    end
end

Trie() = Trie{String, Any, Char}()
Trie(K::Type) = Trie{K, Any, eltype(K)}()
Trie(K::Type, V::Type) = Trie{K, V, eltype(K)}()

Trie(ks::AbstractVector{K}, vs::AbstractVector{V}) where {K<:TrieKey, V} =
    Trie{K, V, eltype(K)}(ks, vs)
Trie(kv::AbstractVector{Tuple{K,V}}) where {K<:TrieKey, V} = Trie{K, V, eltype(K)}(kv)
Trie(kv::AbstractDict{K,V}) where {K<:TrieKey, V} = Trie{K, V, eltype(K)}(kv)
Trie(ks::AbstractVector{K}) where {K<:TrieKey} =
    Trie{K, Nothing, eltype(K)}(ks, similar(ks, Nothing))

function setindex!(t::Trie{K, V}, val::V, key::K) where {K, V}
    node = t
    for char in key
        if !haskey(node.children, char)
            node.children[char] = Trie(K, V)
        end
        node = node.children[char]
    end
    node.is_key = true
    node.value = val
end

function getindex(t::Trie, key)
    node = subtrie(t, key)
    if node != nothing && node.is_key
        return node.value
    end
    throw(KeyError("key not found: $key"))
end

function subtrie(t::Trie, prefix)
    node = t
    for k in prefix
        if !haskey(node.children, k)
            return nothing
        else
            node = node.children[k]
        end
    end
    node
end

function haskey(t::Trie, key)
    node = subtrie(t, key)
    node != nothing && node.is_key
end

function get(t::Trie, key, notfound)
    node = subtrie(t, key)
    if node != nothing && node.is_key
        return node.value
    end
    notfound
end

keys(t::Trie{K}) where {K<:AbstractString} = keys(t, "", K[])
keys(t::Trie{K}) where {K<:AbstractVector} = keys(t, K(), K[])

function keys(t::Trie, prefix, found)
    if t.is_key
        push!(found, prefix)
    end

    for (k, child) in t.children
        keys(child, append_key(prefix, k), found)
    end
    found
end

# I was here!
function keys_with_prefix(t::Trie{K}, prefix::K) where {K}
    st = subtrie(t, prefix)
    st != nothing ? keys(st, prefix, Vector{K}()) : Vector{K}()
end

# We special appending a value to the prefix as this will be different for
# strings and arrays.
append_key(prefix::AbstractString, x::Char) = string(prefix, x)
append_key(prefix::AbstractVector{T}, x::T) where {T} = vcat(prefix, x)

# The state of a TrieIterator is a pair (t::Trie, i::Int),
# where t is the Trie which was the output of the previous iteration
# and i is the index of the current character of the string.
# The indexing is potentially confusing;
# see the comments and implementation below for details.
struct TrieIterator{K}
    t::Trie{K}
    key::K
end

# At the start, there is no previous iteration,
# so the first element of the state is undefined.
# We use a "dummy value" of it.t to keep the type of the state stable.
# The second element is 0
# since the root of the trie corresponds to a length 0 prefix of str.
start(it::TrieIterator) = (it.t, 0)

function next(it::TrieIterator, state)
    t, i = state
    i == 0 && return it.t, (it.t, 1)

    t = t.children[it.key[i]]
    return (t, (t, i + 1))
end

function done(it::TrieIterator, state)
    t, i = state
    i == 0 && return false
    i == length(it.key) + 1 && return true
    return !(it.key[i] in keys(t.children))
end

path(t::Trie{K}, key::K) where {K} = TrieIterator(t, key)
Base.iteratorsize(::Type{<:TrieIterator}) = Base.SizeUnknown()
