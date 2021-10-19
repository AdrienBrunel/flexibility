# ===========================================================================
#  BOUNDARY DATA
# ===========================================================================

  ## Data declaration ----------------------------------------------------------
    id1      = Array{Int64,1}()
    id2      = Array{Int64,1}()
    id3      = Array{Int64,1}()
    boundary = Array{Float64,1}()
    frontier = Array{Float64,1}()

  ## Computation ---------------------------------------------------------------
    cpt = 0
    for k in 1:pu_nb
      if mod(k,Nx) != 0
        global cpt = cpt + 1
        push!(id1,k)
        push!(id2,k+1)
        push!(boundary,1)
      end
    end
    for k in 1:((Ny-1)*Nx)
      global cpt = cpt + 1
      push!(id1,k)
      push!(id2,k+Nx)
      push!(boundary,1)
    end

    frontier=zeros(pu_nb,1)
    for k in 1:pu_nb
      push!(id3,k)
      frontier[k]=0
      if (k <= Nx) #lower edge
        frontier[k]=frontier[k]+1
      end
      if (mod(k,Nx) == 0) #left edge
        frontier[k]=frontier[k]+1
      end
      if (mod(k,Nx) == 1) #right edge
        frontier[k]=frontier[k]+1
      end
      if ((k <= Nx*Ny) & (k > Nx*(Ny-1))) #upper edge
        frontier[k]=frontier[k]+1
      end
    end

  ## Generation ----------------------------------------------------------------
    bound_fname = string(input_dir,"/bound.csv")
    bound_data  = DataFrame([id1 id2 boundary])
    rename!(bound_data,["id1","id2","boundary"])
    bound_data.id1 = convert(Array{Int64,1},bound_data.id1)
    bound_data.id2 = convert(Array{Int64,1},bound_data.id2)
    CSV.write(bound_fname, bound_data, writeheader=true)

    frontier_fname = string(input_dir,"/frontier.csv")
    frontier_data = DataFrame([id3 frontier])
    rename!(frontier_data,["id","frontier"])
    frontier_data.id = convert(Array{Int64,1},frontier_data.id)
    CSV.write(frontier_fname, frontier_data, writeheader=true)
