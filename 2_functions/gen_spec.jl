# ==============================================================================
#  SPEC DATA
# ==============================================================================

  ## Data declaration ----------------------------------------------------------
    id     = Array{Int64,1}(undef,spec_nb)
    name   = Array{String,1}(undef,spec_nb)
    amount = Array{Float64,1}(undef,spec_nb)
    weight = Array{Float64,1}(undef,spec_nb)

  ## Computation ---------------------------------------------------------------

    # id
    id = vcat(1:spec_nb)

    # name
    name[1] = "acoustic_biomass"
    if spec_nb==3
      name[2] = "continental_shelf"
      name[3] = "shelf_break"
    end

    # amount
    amount[1] = 0.5
    if spec_nb==3
      amount[2] = 0.5
      amount[3] = 0.5
    end

    # relative weight
    weight[1] = 1
    if spec_nb==3
      weight[2] = 1
      weight[3] = 1
    end

  ## Generation ----------------------------------------------------------------
    spec_fname = string(input_dir,"/spec.csv")
    spec_data  = DataFrame([id name amount weight])
    rename!(spec_data,["id","name","amount","weight"])
    CSV.write(spec_fname, spec_data, writeheader=true)
