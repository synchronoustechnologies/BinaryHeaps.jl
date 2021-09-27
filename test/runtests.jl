using Test
using Random
using Base.Order

using BinaryHeaps
using BinaryHeaps:
    walk,
    heapparent, heapleft, heapright,
    heapify!, bubble!,
    PermutationTracker,
    reduce_subtrees!, Reducer!

function isheap(v,order)
    n = length(v)

    # Nodes with two children
    for i = 1:heapparent(n-1)
        if lt(order, v[heapleft(i)], v[i]) ||
           lt(order, v[heapright(i)], v[i])
            return false
        end
    end

    # Node with one child
    for i = heapparent(n+1) : heapparent(n)
        if lt(order, v[heapleft(i)], v[i])
            return false
        end
    end

    return true
end

macro return_if_false(expr)
    return quote
        if !$(esc(expr))
            return false
        end
    end
end

function isreduction(v,r,reduce)
    n = length(v)
    if n == 0; return true; end

    # Check no-child nodes
    for i = n:-1:heapparent(n)+1
        @return_if_false r[i] == reduce(v[i])
    end

    # Check one-child node, if present
    for i = heapparent(n+1) : heapparent(n)
        @return_if_false r[i] == reduce(v[i],r[n])
    end

    # Reduce two-children nodes
    for i = heapparent(n)-1:-1:1
        @return_if_false r[i] == reduce(v[i], r[heapleft(i)], r[heapright(i)])
    end

    return true
end

include("walk.jl")
include("binary_heaps.jl")
include("permutations.jl")
include("reduction.jl")

include("MutableBinaryHeapsWithReduction.jl")