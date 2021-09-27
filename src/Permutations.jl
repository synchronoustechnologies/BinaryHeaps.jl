@typeparams struct Permutation! <: AbstractVector{Int}
    p::{<:AbstractVector{Int}}   # Forward permutation
    ip::{<:AbstractVector{Int}}  # Backward permutation
end

Base.size(p::Permutation!) = size(p.p)
Base.getindex(p::Permutation!, i::Int) = p.p[i]
Base.@propagate_inbounds function Base.setindex!(p::Permutation!, pi::Int, i::Int)
    @unpack p,ip = p
    ip[pi] = i
    return setindex!(p,pi,i)
end