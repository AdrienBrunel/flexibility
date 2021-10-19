# ==============================================================================
#  OPTIMISATION EXECUTION
# ==============================================================================

    ## Computation -------------------------------------------------------------
        if meta_data.optim_type == "algo1"
            X = minset_flex_algo1(input_data,meta_data)
        elseif meta_data.optim_type == "algo2"
            X = minset_flex_algo2(input_data,meta_data)
        elseif meta_data.optim_type == "algo3"
            X = minset_flex_algo3(input_data,meta_data)
        end

    ## Results --------------------------------------------------------------
        output_data = OutputData(X,input_data,meta_data)

    ## Generation --------------------------------------------------------------
        sol_fname = string(output_dir,"/solution.csv")
        sol_data  = DataFrame([grid_data.pu_id output_data.reserve grid_data.locked_in grid_data.locked_out grid_data.xloc grid_data.yloc])
        sol_data_name = ["id"]
        for n in 1:output_data.nsol
            push!(sol_data_name,@sprintf("reserve%d",n))
        end
        push!(sol_data_name,"locked_out","locked_in","xloc","yloc")
        rename!(sol_data,sol_data_name)

        sol_data.id         = convert(Array{Int64,1},sol_data.id)
        sol_data.locked_out = convert(Array{Int8,1},sol_data.locked_out)
        sol_data.locked_in  = convert(Array{Int8,1},sol_data.locked_in)
        for n in 1:output_data.nsol
            eval(Meta.parse("sol_data.reserve$(n) = convert(Array{Int8,1},sol_data.reserve$(n))"))
        end

        CSV.write(sol_fname, sol_data, writeheader=true)

        for n in 1:output_data.nsol
            max_length      = max(1,length(output_data.coverage[:,n]))
            global res_data        = Array{String,2}(undef,max_length,7)
            res_data[1,1:5] = [string(output_data.pu[n]),string(output_data.cost[n]),string(output_data.boundary[n]),
                               string(output_data.score_minset[n]),string(output_data.score_maxcov[n])]
            res_data[1,7]   = string(output_data.wgt_coverage[n])
            var_name        = ["pu","cost","boundary","score_minset","score_maxcov","coverage","wgt_coverage"]
            global cpt = 0
            for k in 1:length(var_name)
                global cpt = cpt+1
                eval(Meta.parse("var_length = length(output_data.$(var_name[k]))"))
                if (var_name[k] == "coverage")
                    for i in 1:max_length
                        if (i <= var_length)
                            eval(Meta.parse("res_data[$(i),$(cpt)] = string(output_data.$(var_name[k])[$(i)])"))
                        end
                    end
                else
                    res_data[2:max_length,cpt] .= ""
                end
            end
            res_data = convert(DataFrame,res_data)
            rename!(res_data,["pu","cost","boundary","score_minset","score_maxcov","coverage","wgt_coverage"])
            #CSV.write(res_fname, res_data, writeheader=true)

            res_fname = @sprintf("%s/r%05d_results.csv",output_dir,n)
            fid       = open(res_fname,"w")
            str    = Array{String,1}(undef,7)
            str[1] = @sprintf("pu,%d",output_data.pu[n])
            str[2] = @sprintf("cost,%.2f",output_data.cost[n])
            str[3] = @sprintf("boundary,%.2f",output_data.boundary[n])
            str[4] = @sprintf("score_minset,%.2f",output_data.score_minset[n])
            str[5] = @sprintf("score_maxcov,%.2f",output_data.score_maxcov[n])
            str[6] = "coverage,"
            str[7] = @sprintf("wgt_coverage,%.2f",output_data.wgt_coverage[n])
            for i in 1:size(output_data.coverage)[1]
                if i == size(output_data.coverage)[1]
                    global str[6] = string(str[6],@sprintf("%.2f",output_data.coverage[i,n]))
                else
                    global str[6] = string(str[6],@sprintf("%.2f,",output_data.coverage[i,n]))
                end
            end
            writedlm(fid,str)
            close(fid)
        end
