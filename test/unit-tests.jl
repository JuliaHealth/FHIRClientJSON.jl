@testset "Unit tests" begin
    @testset "requests.jl" begin
        @testset "_add_trailing_slash" begin
            @test FHIRClientJSON._add_trailing_slash(HTTP.URI("http://julialang.org")) == HTTP.URI("http://julialang.org/")
            @test FHIRClientJSON._add_trailing_slash(HTTP.URI("http://julialang.org/")) == HTTP.URI("http://julialang.org/")
        end
        @testset "_write_struct_request_body" begin
            @test FHIRClientJSON._write_struct_request_body(nothing) == nothing
            @test FHIRClientJSON._write_struct_request_body(JSON3.read("{}")) == "{}"
        end
    end
end
