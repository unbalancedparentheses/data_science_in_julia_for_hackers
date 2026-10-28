using Test
import Pluto

const ROOT = normpath(joinpath(@__DIR__, "../.."))
const CASES = [
    ("14_model_evaluation/14_model_evaluation.jl", :false_positive_cost, 1, 1, :(copy(costs))),
    ("15_tabular_learning/15_tabular_learning.jl", :tree_depth, 7, 8, :tree_error),
    ("16_causal_inference/notebook.jl", :tendency, 1, 0.5, :naive),
    ("17_bayesian_workflow/notebook.jl", :strength, 5, 30.0, :(mean(posterior))),
    ("17_bayesian_workflow/notebook.jl", :proposal_scale, 1, 0.00001, :(copy(sampler_fit.acceptance))),
]

# The raw values are browser-side Slider indices. PlutoUI transforms them into
# the actual range values before Pluto reruns dependent cells.
@testset "Pluto native bonds and reactive updates" begin
    for (relative_path, bond, browser_value, expected_value, dependent) in CASES
        @testset "$relative_path / $bond" begin
            path = joinpath(ROOT, relative_path)
            original = read(path)
            session = Pluto.ServerSession()
            session.options.server.disable_writing_notebook_files = true
            notebook = nothing
            try
                notebook = Pluto.SessionActions.open(session, path; run_async=false)
                errors = filter(c -> c.errored, notebook.cells)
                for cell in errors
                    @error "Notebook cell failed" path cell.code cell.output.body
                end
                @test isempty(errors)
                @test bond in Pluto.get_bond_names(session, notebook)
                if isempty(errors)
                    before = Pluto.WorkspaceManager.eval_fetch_in_workspace((session, notebook), dependent)
                    notebook.bonds[bond] = Dict("value" => browser_value)
                    Pluto.set_bond_values_reactive(; session, notebook,
                        bound_sym_names=[bond], is_first_values=[false], run_async=false)
                    @test !any(c -> c.errored, notebook.cells)
                    actual = Pluto.WorkspaceManager.eval_fetch_in_workspace((session, notebook), bond)
                    after = Pluto.WorkspaceManager.eval_fetch_in_workspace((session, notebook), dependent)
                    @test actual == expected_value
                    @test !isequal(before, after)
                end
                @test read(path) == original
            finally
                isnothing(notebook) || Pluto.SessionActions.shutdown(session, notebook)
            end
        end
    end
end
