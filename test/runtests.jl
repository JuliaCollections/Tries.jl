using Compat.Test
using Tries
const IntSet = Tries.IntSet
using Primes, Compat
using Compat.Unicode: lowercase

@test isempty(detect_ambiguities(Base, Core, Tries))

tests = ["int_set",
         "deque",
         "circ_deque",
         "sorted_containers",
         "stack_and_queue",
         "accumulator",
         "classified_collections",
         "disjoint_set",
         "binheap",
         "mutable_binheap",
         "default_dict",
         "ordered_dict",
         "ordered_set",
         "trie",
         "list",
         "multi_dict",
         "circular_buffer",
         "sorting",
         "priority_queue"
        ]

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
