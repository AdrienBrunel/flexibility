# ==============================================================================
#  PU DATA
# ==============================================================================

  ## Data declaration ----------------------------------------------------------
    id            = Array{Int64,1}(undef,pu_nb)
    xloc          = Array{Float64,1}(undef,pu_nb)
    yloc          = Array{Float64,1}(undef,pu_nb)
    locked_in     = Array{Int8,1}(undef,pu_nb)
    locked_out    = Array{Int8,1}(undef,pu_nb)
    cost          = Array{Float64,1}(undef,pu_nb)
    cost_cst      = Array{Float64,1}(undef,pu_nb)
    cost_fishing  = Array{Float64,1}(undef,pu_nb)
    cost_fshlog   = Array{Float64,1}(undef,pu_nb)
    cost_fshscale = Array{Float64,1}(undef,pu_nb)
    cost_diving   = Array{Float64,1}(undef,pu_nb)

  ## Computation ---------------------------------------------------------------
    cpt = 0
    for i in 1:Ny
      for j in 1:Nx
        global cpt = cpt + 1

        # pu id
        id[cpt] = cpt

        # pu location
        yloc[cpt] = lat_seq[i]
        xloc[cpt] = lon_seq[j]

        # pu status
        locked_in[cpt]=0
        if sum(cpt .== param_data.locked_in) > 0
          locked_in[cpt]=1
        end
        locked_out[cpt]=0
        if sum(cpt .== param_data.locked_out) > 0
          locked_out[cpt]=1
        end

        # pu cost
        cost_cst[cpt]     = 1
        cost_fishing[cpt] = 1 + fishing_intensity[i,j]
        cost_fshlog[cpt]  = 1 + log(1 + fishing_intensity[i,j])
        cost_diving[cpt]  = 1 + diving_intensity[i,j]

        FC_bnb = 10
        FC_min = min(fishing_intensity[i,j])
        FC_max = max(fishing_intensity[i,j])
        FC_bwd = (FC_max-FC_min)/FC_bnb
        for k in 1:FC_bnb
          if fishing_intensity[i,j] == FC_max
            cost_fshscale[cpt] = FC_bnb
          else
            if fishing.intensity[i,j] >= (k-1)*FC.bwd & fishing.intensity[i,j]<k*FC.bwd
              cost_fshscale[cpt] = k
            end
          end
        end
      end
    end
    eval(Meta.parse("cost=round.($(cost_type),digits=2)"))

  ## Generation ----------------------------------------------------------------
    pu_fname = string(input_dir,"/pu.csv")
    pu_data  = DataFrame([id  xloc yloc cost locked_in locked_out])
    rename!(pu_data,["id","xloc","yloc","cost","locked_in","locked_out"])
    pu_data.id = convert(Array{Int64,1},pu_data.id)
    pu_data.locked_in = convert(Array{Int8,1},pu_data.locked_in)
    pu_data.locked_out = convert(Array{Int8,1},pu_data.locked_out)
    CSV.write(pu_fname, pu_data, writeheader=true)
