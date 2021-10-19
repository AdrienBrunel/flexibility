# ==============================================================================
#  LOAD INPUT
# ==============================================================================

    ## Load --------------------------------------------------------------------
        pu_fname     = string(input_dir,"/pu.csv")
        puvspr_fname = string(input_dir,"/puvspr.csv")
        spec_fname   = string(input_dir,"/spec.csv")
        bound_fname  = string(input_dir,"/bound.csv")
        frontier_fname  = string(input_dir,"/frontier.csv")
        budget_fname = string(input_dir,"/budget.csv")

        for f in [pu_fname,puvspr_fname,spec_fname,bound_fname,frontier_fname,budget_fname]
            if isfile(f) == false
                @printf("\"%s\" not found ",f)
            end
        end

    ## DataFrame ---------------------------------------------------------------
        pu_data       = CSV.read(pu_fname, header=1, delim=",")
        puvspr_data   = CSV.read(puvspr_fname, header=1, delim=",")
        spec_data     = CSV.read(spec_fname, header=1, delim=",")
        bound_data    = CSV.read(bound_fname, header=1, delim=",")
        frontier_data = CSV.read(frontier_fname, header=1, delim=",")
        budget_data   = CSV.read(budget_fname, header=1, delim=",")

    ## Structure ---------------------------------------------------------------
        input_data = InputData(pu_data, spec_data, puvspr_data, bound_data, frontier_data, budget_data, grid_data)
