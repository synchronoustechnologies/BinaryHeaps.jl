@typeparams struct MutableBinaryHeapWithReduction
    v::{}
    r::{}
    k2i::{}
    i2k::{}
    order::{<:Ordering}
    reduce::{}
end

function MutableBinaryHeapWithReduction(
    v,
    r = Vector{eltype(v)}(undef, length(v)),
    i2k = nothing,
    k2i = nothing;
    reduce,
    lt = isless,
    by = identity,
    rev::Bool = false,
    order::Ordering = Forward
)
    if isnothing(i2k)
        @assert isnothing(k2i)
        n = length(v)
        i2k = collect(1:n)
        k2i = collect(1:n)
    elseif isnothing(k2i)
        k2i = Dict(k=>i for (i,k) in enumerate(i2k))
    end
    order = ord(lt, by, rev, order)
    heapify!(
        PermutationTracker(v,k2i,i2k),
        By(((k,vk),) -> vk, order)
    )
    reduce_subtrees!(v,r,reduce)
    return MutableBinaryHeapWithReduction(
        v, r, k2i, i2k,
        order, reduce
    )
end

function update!(h::MutableBinaryHeapWithReduction, k, vk)
    @unpack v,r,k2i,i2k,order,reduce = h
    n = length(v)
    if n == 0; return k; end

    i = k2i[k]
    tv = PermutationTracker(v, k2i, i2k)
    tvk = (k,vk)
    torder = By(((k,vk),) -> vk, order)

    if lt(order, vk, v[i])
        i = walk(
            piggyback(
                Bubbler!(tv, tvk, torder, Val(:up)),
                Reducer!(v,r,reduce)
            ),
            n, i, Val(:up)
        )
    else
        i = walk(
            Bubbler!(tv, tvk, torder, Val(:down)),
            n, i, Val(:down)
        )
    end
    tv[i] = tvk
    walk(Reducer!(v,r,reduce),n,i, Val(:up))
    return i
end