@typeparams struct Permutation <: AbstractVector{Int}
    p::{}   # Forward permutation
    ip::{}  # Backward permutation
end

Base.size(p::Permutation) = size(p.p)
Base.getindex(p::Permutation, i) = p.p[i]
Base.@propagate_inbounds function Base.setindex!(p::Permutation, pi, i)
    @unpack p,ip = p
    ip[pi] = i
    return setindex!(p,pi,i)
end



@typeparams struct PermutationTracker{K,V} <: AbstractVector{Tuple{K,V}}
    v::{<:AbstractVector{V}}     # Data
    k2i::{}                      # Key -> current index in d
    i2k::{<:AbstractVector{K}} # Current index in d -> key
end
PermutationTracker(v,k2i,i2k) = PermutationTracker{keytype(k2i), eltype(v)}(v,k2i,i2k)

Base.size(t::PermutationTracker) = size(t.v)
Base.getindex(t::PermutationTracker, i::Int) = (t.i2k[i],t.v[i])
function Base.setindex!(t::PermutationTracker{K,V}, (k,vk)::Tuple{K,V}, i::Int) where {K,V}
    @unpack v,k2i,i2k = t
    v[i] = vk
    Permutation(i2k,k2i)[i] = k
    return t
end