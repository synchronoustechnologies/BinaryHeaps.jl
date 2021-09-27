function walk(f, n, i, ::Val{:up})
    if n == 0; return i; end
    @assert 1 <= i <= n

    if heapleft(i) > n  # i has no children
        val = f(i, ifelse(i > 1,Val(1),Val(0)), Val(0))
        if val == Val(:break)
            return i
        elseif val != Val(:continue)
            error("Invalid value leaf($i) = $val encountered in walk_up($n,$i;...)")
        end
        i = heapparent(i)
    end

    if heapright(i) > n  # i has one child
        val = f(i, ifelse(i > 1,Val(1),Val(0)), Val(1))
        if val == Val(:break)
            return i
        elseif val != Val(:continue)
            error("Invalid value border($i) = $val encountered in walk_up($n,$i;...)")
        end
        i = heapparent(i)
    end

    while i > 1
        val = f(i, Val(1), Val(2))
        if val == Val(:break)
            return i
        elseif val != Val(:continue)
            error("Invalid value inner($i) = $val encountered in walk_up($n,$i;...)")
        end
        i = heapparent(i)
    end

    if i > 0
        f(i, Val(0), ifelse(n > 1, ifelse(n > 2, Val(2),Val(1)), Val(0)))
    end
    return 1
end

function walk(f, n, i, ::Val{:down})
    if n == 0; return i; end
    @assert 1 <= i <= n
    while heapright(i) <= n
        val = f(i, ifelse(i > 1, Val(1), Val(0)), Val(2))
        if val == Val(:left)
            i = heapleft(i)
        elseif val == Val(:right)
            i = heapright(i)
        elseif val == Val(:break)
            return i
        else
            error("Invalid value inner($i) = $val encountered in walk_down($n,$i;...)")
        end
    end
    if heapleft(i) <= n
        val = f(i, ifelse(i > 1, Val(1), Val(0)), Val(1))
        if val == Val(:break)
            return i
        elseif val != Val(:continue)
            error("Invalid value border($i) = $val encountered in walk_down($n,$i;...)")
        end
        i = heapleft(i)
    end
    val = f(i, ifelse(i > 1, Val(1), Val(0)), Val(0))
    return i
end

function piggyback(primary, secondaries...)
    return (args...) -> begin
        val = primary(args...)
        for secondary in secondaries
            secondary(args...)
        end
        return val
    end
end