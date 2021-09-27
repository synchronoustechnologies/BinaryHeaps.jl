@typeparams struct MutableBinaryHeapWithReduction{T}
    v::{<:AbstractVector{T}}
    r::{<:AbstractVector}
    o2h::{<:AbstractVector{Int}}
    h2o::{<:AbstractVector{Int}}
    order::{<:Ordering}
    reduce::{}
end

function MutableBinaryHeapWithReduction(
    v::AbstractVector,
    r::AbstractVector;
    reduce,
    lt = isless,
    by = identity,
    rev::Bool = false,
    order::Ordering = Forward
)
    @assert length(r) >= length(v)
    n = length(v)
    o2h = collect(1:n)
    h2o = collect(1:n)
    order = ord(lt, by, rev, order)

    heapify!(
        Tracked!(v,o2h,h2o),
        By(((oi,vi),) -> vi, order)
    )
    reduce_subtrees!(v,r,reduce)

    return MutableBinaryHeapWithReduction(
        v, r, o2h, h2o,
        order, reduce
    )
end

function update!(h::MutableBinaryHeapWithReduction, oi, vi)
    @unpack v,r,o2h,h2o,order,reduce = h
    n = length(v)
    if n == 0; return oi; end

    hi = h.o2h[oi]
    tracked_v = Tracked!(v, o2h, h2o)
    tracked_vi = (oi,vi)
    tracked_order = By(((oi,vi),) -> vi, order)

    if lt(order, vi, v[hi])
        hi = walk(
            piggyback(
                Bubbler!(tracked_v, tracked_vi, tracked_order, Val(:up)),
                Reducer!(v,r,reduce)
            ),
            n, hi, Val(:up)
        )
    else
        hi = walk(
            Bubbler!(tracked_v, tracked_vi, tracked_order, Val(:down)),
            n, hi, Val(:down)
        )
    end
    tracked_v[hi] = tracked_vi
    walk(Reducer!(v,r,reduce),n,hi, Val(:up))
    return hi
end