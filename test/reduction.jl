@testset "reduce_subtrees!" begin
    @testset for reduce = (+,*)
        @testset for n = 0:10
            Random.seed!(42)
            v = rand(0:10,n)
            r = Vector{Int}(undef, n)
            reduce_subtrees!(v,r,reduce)
            @test isreduction(v,r,reduce)
        end
    end
end

@testset "Reducer!" begin
    @testset for reduce = (+,*)
        @testset for n = 1:10
            Random.seed!(42)
            for _ = 1:10
                v = rand(0:10,n)
                r = Vector{Int}(undef, n)
                reduce_subtrees!(v,r,reduce)

                i = rand(1:n)
                v[i] = rand(1:10)
                walk(Reducer!(v,r,reduce), n, i, Val(:up))
                @test isreduction(v,r,reduce)
            end
        end
    end
end