@testset "MutableBinaryHeapWithReduction" begin
    @testset for reduce = (+,*)
        @testset for order = (Forward,Reverse)
            @testset for n = 0
                h = MutableBinaryHeapWithReduction([],[]; reduce, order)
                @test h.v == []
                @test h.r == []
                @test h.o2h == []
                @test h.h2o == []
            end
            @testset for n = 1
                h = MutableBinaryHeapWithReduction([0],[-1]; reduce, order)
                @test h.v == [0]
                @test h.r == [0]
                @test h.o2h == [1]
                @test h.h2o == [1]
            end
            @testset for n = 2:10
                Random.seed!(42)
                for _ = 1:10
                    v̂ = rand(0:99,n)
                    h = MutableBinaryHeapWithReduction(
                        copy(v̂),
                        Vector{Int}(undef, n);
                        reduce, order
                    )
                    @test isheap(h.v,order)
                    @test isreduction(h.v,h.r,reduce)
                    @test h.v[h.o2h] == v̂
                    @test h.o2h[h.h2o] == 1:n
                end
            end
        end
    end
end

@testset "update!(::MutableBinaryHeapWithReduction)" begin
    @testset for reduce = (+,#=*=#)
        @testset for order = (Forward,Reverse)
            @testset for n = 0
                h = MutableBinaryHeapWithReduction([],[]; reduce, order)
                update!(h, 1, 0)
                @test h.v == []
                @test h.r == []
                @test h.o2h == []
                @test h.h2o == []
            end
            @testset for n = 1
                h = MutableBinaryHeapWithReduction([0],[-1]; reduce, order)
                update!(h, 1, 1)
                @test h.v == [1]
                @test h.r == [1]
                @test h.o2h == [1]
                @test h.h2o == [1]
            end
            @testset for n = 2:10
                Random.seed!(42)
                v̂ = rand(0:99,n)
                h = MutableBinaryHeapWithReduction(
                    copy(v̂),
                    Vector{Int}(undef, n);
                    reduce, order
                )
                for _ = 1:10
                    i = rand(1:n)
                    vi = rand(0:99)
                    update!(h, i, vi)
                    v̂[i] = vi
                    @test isheap(h.v,order)
                    @test isreduction(h.v,h.r,reduce)
                    @test h.v[h.o2h] == v̂
                    @test h.o2h[h.h2o] == 1:n
                end
            end
        end
    end
end