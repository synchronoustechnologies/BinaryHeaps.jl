using BenchmarkTools

function benchmark(f, args...)
    for tag in (:Direct, :DataStructures, :BinaryHeaps)
        if applicable(f, Val(tag), args...)
            title = "$tag implementation"
            println(repeat("-", length(title)+1))
            println("$title:")
            println(repeat("-", length(title)+1))
            println()
            display(@benchmark $f($(Val(tag)),$args...))
            println()
            println()
        end
    end
end

module WalkDown
    function run(::Val{:Direct}, n)
        i = 1
        s = 0
        while heapleft(i) <= n
            s += i
            i = heapleft(i)
        end
        s += i
        return s
    end

    using BinaryHeaps: heapleft, walk
    function run(::Val{:BinaryHeaps}, n)
        s = Ref(0)
        walk(n, 1, Val(:down)) do i,np,nc
            s[] += i
            return Val(:left)
        end
        return s[]
    end
end

module Heapify
    using Base.Order

    using DataStructures
    run(::Val{:DataStructures}, v) = DataStructures.heapify!(v, Forward)

    using BinaryHeaps
    run(::Val{:BinaryHeaps}, v) = BinaryHeaps.heapify!(v, Forward)
end
