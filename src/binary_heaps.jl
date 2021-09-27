heapleft(i) = 2i
heapright(i) = 2i + 1
heapparent(i) = div(i,2)

function heapify!(v, order)
    # https://en.wikipedia.org/wiki/Binary_heap#Building_a_heap
    n = length(v)
    for i = heapparent(n):-1:1
        bubble!((v,n), v[i], i, order, Val(:down))
    end
    return v
end

function bubble!((v,n), vi, i, order)
    if n == 0; return i; end
    if lt(order, vi, v[i])
        return bubble!((v,n), vi, i, order, Val(:up))
    else
        return bubble!((v,n), vi, i, order, Val(:down))
    end
end

function bubble!((v,n), vi, i, order, dir)
    if n == 0; return i; end
    i = walk(
        Bubbler!(v,vi,order,dir),
        n, i, dir
    )
    v[i] = vi
    return i
end

function Bubbler!(v, vi, order, ::Val{:up})
    UpBubblerF(i, ::Val{0}, _) = Val(:break)
    function UpBubblerF(i, ::Val{1}, _)
        vp = v[heapparent(i)]
        if lt(order, vi, vp)
            v[i] = vp
            return Val(:continue)
        end
        return Val(:break)
    end
    return UpBubblerF
end

function Bubbler!(v, vi, order, ::Val{:down})
    DownBubblerF(i, _, ::Val{0}) = Val(:break)
    function DownBubblerF(i, _, ::Val{1})
        if lt(order, v[heapleft(i)], vi)
            v[i] = v[heapleft(i)]
            return Val(:continue)
        end
        return Val(:break)
    end
    function DownBubblerF(i, _, ::Val{2})
        vl,vr = v[heapleft(i)], v[heapright(i)]
        d,vj = if lt(order, vl, vr)
            Val(:left), vl
        else
            Val(:right), vr
        end
        if lt(order, vj, vi)
            v[i] = vj
            return d
        end
        return Val(:break)
    end
    return DownBubblerF
end