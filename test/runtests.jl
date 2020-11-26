using FHIRClientJSON
using Test

@testset "FHIRClientJSON.jl" begin
    @test FHIRClientJSON.f(1) == 2
end
