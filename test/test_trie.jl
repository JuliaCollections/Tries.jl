

@testset "Trie" begin

    @testset "String Keys" begin
        t=Trie(String, Int)

        t["amy"]=56
        t["ann"]=15
        t["emma"]=30
        t["rob"]=27
        t["roger"]=52

        @test haskey(t, "roger")
        @test get(t,"rob",nothing) == 27
        @test sort(keys(t)) == ["amy", "ann", "emma", "rob", "roger"]
        @test t["rob"] == 27
        @test sort(keys_with_prefix(t,"ro")) == ["rob", "roger"]


        # constructors
        ks = ["amy", "ann", "emma", "rob", "roger"]
        vs = [56, 15, 30, 27, 52]
        kvs = collect(zip(ks, vs))
        @test isa(Trie(ks, vs), Trie{String, Int})
        @test isa(Trie(kvs), Trie{String, Int})
        @test isa(Trie(Dict(kvs)), Trie{String, Int})
        @test isa(Trie(ks), Trie{String, Nothing})


        # path iterator
        t0 = t
        t1 = t0.children['r']
        t2 = t1.children['o']
        t3 = t2.children['b']
        @test collect(path(t, "b")) == [t0]
        @test collect(path(t, "rob")) == [t0, t1, t2, t3]
        @test collect(path(t, "robb")) == [t0, t1, t2, t3]
        @test collect(path(t, "ro")) == [t0, t1, t2]
        @test collect(path(t, "roa")) == [t0, t1, t2]
    end

    @testset "Symbol Vector Keys" begin
        t = Trie(Vector{Symbol}, Int)

        ks = [
            [:a, :m, :y],
            [:a, :n, :n],
            [:e, :m, :m, :a],
            [:r, :o, :b],
            [:r, :o, :g, :e, :r],
        ]

        vs = [56, 15, 30, 27, 52]

        t[[:a, :m, :y]] = 56
        t[[:a, :n, :n]] = 15
        t[[:e, :m, :m, :a]] = 30
        t[[:r, :o, :b]] = 27
        t[[:r, :o, :g, :e, :r]] = 52

        @test haskey(t, [:r, :o, :g, :e, :r])
        @test get(t, [:r, :o, :b], nothing) == 27
        @test Set(keys(t)) == Set(ks)

        @test t[[:r, :o, :b]] == 27
        @test Set(keys_with_prefix(t, [:r, :o])) == Set([[:r, :o, :b], [:r, :o, :g, :e, :r]])

        # constructors
        kvs = collect(zip(ks, vs))
        @test isa(Trie(ks, vs), Trie{Vector{Symbol}, Int})
        @test isa(Trie(kvs), Trie{Vector{Symbol}, Int})
        @test isa(Trie(Dict(kvs)), Trie{Vector{Symbol}, Int})
        @test isa(Trie(ks), Trie{Vector{Symbol}, Nothing})

        # path iterator
        t0 = t
        t1 = t0.children[:r]
        t2 = t1.children[:o]
        t3 = t2.children[:b]
        @test collect(path(t, [:b])) == [t0]
        @test collect(path(t, [:r, :o, :b])) == [t0, t1, t2, t3]
        @test collect(path(t, [:r, :o, :b, :b])) == [t0, t1, t2, t3]
        @test collect(path(t, [:r, :o])) == [t0, t1, t2]
        @test collect(path(t, [:r, :o, :a])) == [t0, t1, t2]
    end

    @testset "UInt8 Vector Keys" begin
        t = Trie(Vector{UInt8}, Int)

        # We're using strings as the source of the Vector{UInt8} data just to
        # help with test readability.
        amy = Vector{UInt8}("amy")
        ann = Vector{UInt8}("ann")
        emma = Vector{UInt8}("emma")
        rob = Vector{UInt8}("rob")
        roger = Vector{UInt8}("roger")

        ks = [amy, ann, emma, rob, roger]
        vs = [56, 15, 30, 27, 52]

        t[amy] = 56
        t[ann] = 15
        t[emma] = 30
        t[rob] = 27
        t[roger] = 52

        @test haskey(t, roger)
        @test get(t, rob, nothing) == 27
        @test Set(keys(t)) == Set(ks)

        @test t[rob] == 27
        @test Set(keys_with_prefix(t, Vector{UInt8}("ro"))) == Set([rob, roger])

        # constructors
        kvs = collect(zip(ks, vs))
        @test isa(Trie(ks, vs), Trie{Vector{UInt8}, Int})
        @test isa(Trie(kvs), Trie{Vector{UInt8}, Int})
        @test isa(Trie(Dict(kvs)), Trie{Vector{UInt8}, Int})
        @test isa(Trie(ks), Trie{Vector{UInt8}, Nothing})

        # path iterator
        t0 = t
        t1 = t0.children[UInt8('r')]
        t2 = t1.children[UInt8('o')]
        t3 = t2.children[UInt8('b')]
        @test collect(path(t, Vector{UInt8}("b"))) == [t0]
        @test collect(path(t, rob)) == [t0, t1, t2, t3]
        @test collect(path(t, Vector{UInt8}("robb"))) == [t0, t1, t2, t3]
        @test collect(path(t, Vector{UInt8}("ro"))) == [t0, t1, t2]
        @test collect(path(t, Vector{UInt8}("roa"))) == [t0, t1, t2]
    end
end # @testset Trie
