using FHIRClientJSON
using Test

import BSON
import BrokenRecord
import HTTP
import JSON3

@testset "FHIRClientJSON.jl" begin
    include("unit-tests.jl")
    include("recorded-tests.jl")
end
