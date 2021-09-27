@typeparams struct Tracked!{T} <: AbstractVector{Tuple{Int,T}}
    v::{<:AbstractVector{T}}     # Data
    o2d::{<:AbstractVector{Int}} # Permutation original index -> current d index
    d2o::{<:AbstractVector{Int}} # Permutation current d index -> original index
end

Base.size(t::Tracked!) = size(t.v)
Base.getindex(t::Tracked!, i::Int) = (t.d2o[i],t.v[i])
function Base.setindex!(t::Tracked!{T}, (oj,vj)::Tuple{Int,T}, di::Int) where {T}
    @unpack v,d2o,o2d = t
    v[di] = vj
    Permutation!(d2o,o2d)[di] = oj
    return t
end