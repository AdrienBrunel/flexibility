# ==============================================================================
#  LOAD PARAMETERS
# ==============================================================================

    ## Read file ---------------------------------------------------------------
        param_fname = string(sc_dir,"/param.csv")

        for f in [param_fname]
            if isfile(f) == false
              @printf("\"%s\" not found ",f)
            end
        end

    ## DataFrame ---------------------------------------------------------------
        fid = open(param_fname)
        max_length = 0
        while !eof(fid)
            line = readline(fid)
            elmt = split(line,",")
            if length(elmt) > max_length
                global max_length = length(elmt)
            end
        end
        max_length = max_length-1
        close(fid)

        var_name = ["spec_nb","BLM","optim_type","cost_type","lon_range","lon_resol","lat_range","lat_resol","locked_out","locked_in","gap","dpu","nsol"]
        for k in 1:length(var_name)
            eval(Meta.parse("$(var_name[k]) = Array{String,1}(undef,max_length)"))
        end
        fid = open(param_fname)
        while !eof(fid)
            line = readline(fid)
            global elmt = split(line,",")
            for k in 1:length(var_name)
                if elmt[1] == var_name[k]
                    for i in 2:length(elmt)
                        eval(Meta.parse("$(var_name[k])[$(i-1)] = elmt[$(i)]"))
                    end
                    for i in length(elmt):max_length
                        eval(Meta.parse("$(var_name[k])[$(i)] = \"\""))
                    end
                end
            end
        end
        close(fid)
        param_data = DataFrame([spec_nb BLM optim_type cost_type lon_range lon_resol lat_range lat_resol locked_out locked_in gap dpu nsol])
        rename!(param_data,["spec_nb","BLM","optim_type","cost_type","lon_range","lon_resol","lat_range","lat_resol","locked_out","locked_in","gap","dpu","nsol"])

    ## Data structure ----------------------------------------------------------
        meta_data = MetaData(param_data)
        grid_data = GridData(param_data)
