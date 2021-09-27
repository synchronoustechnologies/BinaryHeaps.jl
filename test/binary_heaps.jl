@testset "heapify!" begin
    @testset for order = (Forward,Reverse)
        @testset for n = 0
            v = []
            heapify!(v, order)
            @test v == []
        end
        @testset for n = 1
            v = [0]
            heapify!(v, order)
            @test v == [0]
        end
        @testset for n = 2:10
            Random.seed!(42)
            for _ = 1:10
                v = rand(1:100,n)
                heapify!(v,order)
                @test isheap(v,order)
            end
        end
    end
end

@testset "bubble!" begin
    @testset for order = (Forward,Reverse)
        @testset for n = 0
            v = []
            i = bubble!((v,0),1,0,order) == []
            @test v == []
        end
        @testset for n = 1
            v = [0]
            i = bubble!((v,1),1,1,order)
            @test i == 1
            @test v == [1]
        end
        @testset for n = 2:10
            Random.seed!(42)
            for _ = 1:10
                v = rand(1:100,n)
                heapify!(v,order)
                vi = rand(1:100)
                i = bubble!((v,n),vi,rand(1:n),order)
                @test v[i] == vi
                @test isheap(v,order)
            end
        end
    end
end