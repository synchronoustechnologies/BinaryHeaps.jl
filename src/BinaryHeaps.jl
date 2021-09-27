module BinaryHeaps

export
    MutableBinaryHeapWithReduction,
    update!

using TypeParams
using UnPack
using Base.Order


include("walk.jl")
include("binary_heaps.jl")
include("permutations.jl")
include("reduction.jl")

include("MutableBinaryHeapsWithReduction.jl")

end # module
