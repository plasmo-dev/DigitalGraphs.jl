using Documenter, ComputingGraphs

makedocs(;
    modules=[ComputingGraphs],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/jalving/ComputingGraphs.jl/blob/{commit}{path}#L{line}",
    sitename="ComputingGraphs.jl",
    authors="Jordan Jalving",
    assets=[],
)

deploydocs(;
    repo="github.com/jalving/ComputingGraphs.jl",
)
