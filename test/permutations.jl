@testset "PermutationTracker" begin
    @testset for n = 0
        v = []
        k2i = Int[]
        i2k = Int[]
        heapify!(
            PermutationTracker(v,k2i,i2k),
            By(((k,vk),) -> vk, Forward)
        )
        @test v == []
        @test k2i == []
        @test i2k == []
    end
    @testset for n = 1
        v = [0]
        k2i = Int[1]
        i2k = Int[1]
        heapify!(
            PermutationTracker(v,k2i,i2k),
            By(((k,vk),) -> vk, Forward)
        )
        @test v == [0]
        @test k2i == [1]
        @test i2k == [1]
    end
    @testset for n = 2:10
        Random.seed!(42)
        for _ = 1:10
            v̂ = rand(1:100,n)
            v = copy(v̂)
            k2i = collect(1:n)
            i2k = collect(1:n)
            heapify!(
                PermutationTracker(v,k2i,i2k),
                By(((k,vk),) -> vk, Forward)
            )
            @test isheap(v,Forward)
            @test v[k2i] == v̂
            @test k2i[i2k] == 1:n
        end
    end
end