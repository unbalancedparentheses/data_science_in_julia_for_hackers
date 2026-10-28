# Regenerate the browser parity oracle from the actual Julia mission core.
# From repository root: julia --startup-file=no 06_gravity/mission/browser_fixtures.jl
include("core.jl")
using .MarsMission

output = joinpath(@__DIR__, "..", "..", "docs", "interactive", "mars", "julia-fixtures.json")
distances = [25.94, 38.84, 52.81, 45.54, 17.24]
times = [3.91, 4.57, 5.43, 4.85, 3.15]
rows = String[]
for halfwidth in (0.0, 7.5, 15.0), sigma in (1.0, 3.0, 10.0)
    result = posterior(distances, times; halfwidth, sigma)
    decisions = [mission_summary(result; budget) for budget in (3.0, 5.0, 7.0)]
    # These finite numeric arrays have the same syntax in Julia and JSON.
    push!(rows, "{\"halfwidth\":$halfwidth,\"sigma\":$sigma,\"masses\":$(repr(result.masses)),\"interval\":$(repr(decisions[1].interval)),\"probabilities\":$(repr([d.probability_within_budget for d in decisions]))}")
end
write(output, "[\n" * join(rows, ",\n") * "\n]\n")
println("Wrote ", length(rows), " Julia posterior fixtures to ", output)
