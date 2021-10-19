# ==============================================================================
#  LOAD INPUT
# ==============================================================================

    ## Load --------------------------------------------------------------------
        sol_fname = string(output_dir,"/solution.csv")

        for f in [sol_fname]
            if isfile(f) == false
                @printf("\"%s\" not found ",f)
            end
        end

    ## DataFrame ---------------------------------------------------------------
        sol_data = CSV.read(sol_fname, header=1, delim=",")

    ## Structure ---------------------------------------------------------------
        output_data = OutputData(sol_data[:,2:size(sol_data)[2]-4], input_data, meta_data)
