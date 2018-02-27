using Documenter
using Tries


makedocs(
    format = :html,
    sitename = "Tries.jl",
    pages = [
        "index.md",
        "deque.md",
        "circ_buffer.md",
        "circ_deque.md",
        "stack_and_queue.md",
        "priority-queue.md",
        "accumulators.md",
        "disjoint_sets.md",
        "heaps.md",
        "ordered_containers.md",
        "default_dict.md",
        "trie.md",
        "linked_list.md",
        "intset.md",
        "sorted_containers.md",
    ]
)

deploydocs(
    repo = "github.com/JuliaCollections/Tries.jl.git",
    julia  = "0.6",
    latest = "master",
    target = "build",
    deps = nothing,  # we use the `format = :html`, without `mkdocs`
    make = nothing,  # we use the `format = :html`, without `mkdocs`
)
