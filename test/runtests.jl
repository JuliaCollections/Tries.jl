using Compat.Test
using Tries

import Compat: Nothing


tests = ["trie"]

if length(ARGS) > 0
    tests = ARGS
end

@testset "Tries" begin

for t in tests
    fp = joinpath(dirname(@__FILE__), "test_$t.jl")
    println("$fp ...")
    include(fp)
end

end # @testset
