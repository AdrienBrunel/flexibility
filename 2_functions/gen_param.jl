# ==============================================================================
# PARAMETERS GENERATION
# ==============================================================================

    ## Parameters --------------------------------------------------------------
        spec_nb    = 3
        BLM        = 1
        locked_out = vcat(309,346:348,384:385,421:422,456:458,492:494,527:530)
        locked_in  = vcat()
        cost_type  = "cost_fshlog"
        optim_type = "algo3"

        gap        = vcat(0.00,0.25)
        dpu        = 1
        nsol       = 21

    ## Generation --------------------------------------------------------------
        max_length = max(2,length(locked_out),length(locked_in))
        param_data = Array{String,2}(undef,max_length,13)
        param_data[1,1:4] = [string(spec_nb),string(BLM),cost_type,optim_type]
        param_data[1:2,5] = [string(lon_range[1]),string(lon_range[2])]
        param_data[1,6]   = string(lon_resol)
        param_data[1:2,7] = [string(lat_range[1]),string(lat_range[2])]
        param_data[1,8]   = string(lat_resol)
        cpt = 0
        var_name = ["spec_nb" "BLM" "cost_type" "optim_type" "lon_range" "lon_resol" "lat_range" "lat_resol" "locked_out" "locked_in" "gap" "dpu" "nsol"]
        for k in 1:length(var_name)
            global cpt = cpt+1
            eval(Meta.parse("var_length = length($(var_name[k]))"))
            if (var_name[k] == "locked_in") | (var_name[k] == "locked_out")
                for i in 1:max_length
                    if (i <= var_length)
                        eval(Meta.parse("param_data[$(i),$(cpt)] = string($(var_name[k])[$(i)])"))
                    else
                        param_data[i,cpt] = ""
                    end
                end
            else
                if (var_name[k] == "lon_range") | (var_name[k] == "lat_range")
                    param_data[3:max_length,cpt] .= ""
                else
                    param_data[2:max_length,cpt] .= ""
                end
            end
        end
        param_data[1,11] = string(gap)
        param_data[1,12] = string(dpu)
        param_data[1,13] = string(nsol)
        param_data = convert(DataFrame,param_data)
        rename!(param_data,["spec_nb","BLM","cost_type","optim_type","lon_range","lon_resol","lat_range","lat_resol","locked_out","locked_in","gap","dpu","nsol"])

        param_fname = string(sc_dir,"/param.csv")
        fid = open(param_fname,"w")
        str    = Array{String,1}(undef,13)
        str[1] = @sprintf("spec_nb,%d",spec_nb)
        str[2] = @sprintf("BLM,%f",BLM)
        str[3] = @sprintf("optim_type,%s",optim_type)
        str[4] = @sprintf("cost_type,%s",cost_type)
        str[5] = @sprintf("lon_range,%.2f,%.2f",lon_range[1],lon_range[2])
        str[6] = @sprintf("lon_resol,%.2f",lon_resol)
        str[7] = @sprintf("lat_range,%.2f,%.2f",lat_range[1],lat_range[2])
        str[8] = @sprintf("lat_resol,%.2f",lat_resol)
        str[9] = "locked_out,"
        for i in 1:length(locked_out)
            if i == length(locked_out)
                global str[9] = string(str[9],@sprintf("%d",locked_out[i]))
            else
                global str[9] = string(str[9],@sprintf("%d,",locked_out[i]))
            end
        end
        str[10] = "locked_in,"
        for i in 1:length(locked_in)
            if i == length(locked_in)
                global str[10] = string(str[10],@sprintf("%d",locked_in[i]))
            else
                global str[10] = string(str[10],@sprintf("%d,",locked_in[i]))
            end
        end
        str[11] = @sprintf("gap,%.2f,%.2f",gap[1],gap[2])
        str[12] = @sprintf("dpu,%d",dpu)
        str[13] = @sprintf("nsol,%d",nsol)
        writedlm(fid,str)
        close(fid)
