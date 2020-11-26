using FHIRClientJSON
using Documenter

makedocs(;
    modules=[FHIRClientJSON],
    authors="Dilum Aluthge, Rhode Island Quality Institute, contributors",
    repo="https://github.com/JuliaHealth/FHIRClientJSON.jl/blob/{commit}{path}#L{line}",
    sitename="FHIRClientJSON.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaHealth.github.io/FHIRClientJSON.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaHealth/FHIRClientJSON.jl",
)
