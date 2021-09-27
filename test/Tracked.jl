@testset "Tracked!" begin
    @testset for n = 0
        v = []
        o2v = Int[]
        v2o = Int[]
        heapify!(
            Tracked!(v,o2v,v2o),
            By(((oi,vi),) -> vi, Forward)
        )
        @test v == []
        @test o2v == []
        @test v2o == []
    end
    @testset for n = 1
        v = [0]
        o2v = Int[1]
        v2o = Int[1]
        heapify!(
            Tracked!(v,o2v,v2o),
            By(((oi,vi),) -> vi, Forward)
        )
        @test v == [0]
        @test o2v == [1]
        @test v2o == [1]
    end
    @testset for n = 2:10
        Random.seed!(42)
        for _ = 1:10
            v̂ = rand(1:100,n)
            v = copy(v̂)
            o2v = collect(1:n)
            v2o = collect(1:n)
            heapify!(
                Tracked!(v,o2v,v2o),
                By(((oi,vi),) -> vi, Forward)
            )
            @test isheap(v,Forward)
            @test v[o2v] == v̂
            @test o2v[v2o] == 1:n
        end
    end
end