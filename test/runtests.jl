using FHIRClientJSON
using Test

import HTTP
import JSON3

@testset "FHIRClientJSON.jl" begin
    include("unit-tests.jl")
    include("integration-tests.jl")
end
