# ==============================================================================
#  BUDGET DATA
# ==============================================================================

  ## Data declaration ----------------------------------------------------------
    budget = Array{Float64,1}(undef,1)

  ## Computation ---------------------------------------------------------------
    budget[1] = 0.3

  ## Generation ----------------------------------------------------------------
    budget_fname = string(input_dir,"/budget.csv")
    budget_data  = DataFrame([budget])
    rename!(budget_data,["budget"])
    CSV.write(budget_fname, budget_data, writeheader=true)
