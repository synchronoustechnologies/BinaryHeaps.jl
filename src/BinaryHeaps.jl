module BinaryHeaps

export
    MutableBinaryHeapWithReduction,
    update!

using TypeParams
using UnPack
using Base.Order


include("walk.jl")
include("binary_heaps.jl")
include("Permutations.jl")
include("Tracked.jl")
include("reduction.jl")

include("MutableBinaryHeapsWithReduction.jl")

end # module
