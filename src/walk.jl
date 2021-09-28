function walk(f, n, i, ::Val{:up})
    if n == 0; return i; end
    @assert 1 <= i <= n

    if heapleft(i) > n  # i has no children
        val = f(i, Int(i>1), 0)
        if val == :break
            return i
        elseif val != :continue
            error("Invalid value leaf($i) = $val encountered in walk_up($n,$i;...)")
        end
        i = heapparent(i)
    end

    if heapright(i) > n  # i has one child
        val = f(i, Int(i>1), 1)
        if val == :break
            return i
        elseif val != :continue
            error("Invalid value border($i) = $val encountered in walk_up($n,$i;...)")
        end
        i = heapparent(i)
    end

    while i > 1
        val = f(i,1,2)
        if val == :break
            return i
        elseif val != :continue
            error("Invalid value inner($i) = $val encountered in walk_up($n,$i;...)")
        end
        i = heapparent(i)
    end

    if i > 0
        f(i,0, min(n-1,2))
    end
    return 1
end

function walk(f, n, i, ::Val{:down})
    if n == 0; return i; end
    @assert 1 <= i <= n
    while heapright(i) <= n
        val = f(i, Int(i>1), 2)
        if val == :left
            i = heapleft(i)
        elseif val == :right
            i = heapright(i)
        elseif val == :break
            return i
        else
            error("Invalid value inner($i) = $val encountered in walk_down($n,$i;...)")
        end
    end
    if heapleft(i) <= n
        val = f(i, Int(i>1), 1)
        if val == :break
            return i
        elseif val != :continue
            error("Invalid value border($i) = $val encountered in walk_down($n,$i;...)")
        end
        i = heapleft(i)
    end
    val = f(i, Int(i>1), 0)
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