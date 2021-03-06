function reduce_subtrees!(v,r,reduce)
    @assert length(r) >= length(v)
    n = length(v)
    if n == 0; return nothing; end

    @inbounds begin
        # Reduce no-child nodes
        for i = n:-1:heapparent(n)+1
            r[i] = reduce(v[i])
        end

        # Reduce one-child node, if present
        for i = heapparent(n+1) : heapparent(n)
            r[i] = reduce(v[i],r[n])
        end

        # Reduce two-children nodes
        for i = heapparent(n)-1:-1:1
            r[i] = reduce(v[i], r[heapleft(i)], r[heapright(i)])
        end
    end
    return nothing
end

function Reducer!(v,r,reduce)
    function ReducerF(i, _, nc)
        if nc == 0; r[i] = reduce(v[i]); end
        if nc == 1; r[i] = reduce(v[i], r[heapleft(i)]); end
        if nc == 2; r[i] = reduce(v[i], r[heapleft(i)], r[heapright(i)]); end
        return :continue
    end
    return ReducerF
end
