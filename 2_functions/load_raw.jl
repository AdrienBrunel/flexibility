# ==============================================================================
#  BATHYMETRY
# ==============================================================================

  ## Load --------------------------------------------------------------------
    bathy_fname = string(data_dir,"/noronha/GEBCO_2014_2D_-35.0_-6.0_-30.0_-1.5.nc")
    bathy_lat   = ncread(bathy_fname,"lat")
    bathy_lon   = ncread(bathy_fname,"lon")
    bathy_elv   = ncread(bathy_fname,"elevation")

  ## Processing --------------------------------------------------------------
    cpt = 0
    bathy_raw = zeros(length(bathy_lon)*length(bathy_lat),3)
    for i in 1:length(bathy_lon)
      for j in 1:length(bathy_lat)
          if (bathy_lat[j,1] >= lat_range[1]) & (bathy_lat[j,1] <= lat_range[2]) & (bathy_lon[i,1] >= lon_range[1]) & (bathy_lon[i,1] <= lon_range[2])
              global cpt=cpt+1
              bathy_raw[cpt,1:3] = [bathy_lon[i,1],bathy_lat[j,1],bathy_elv[i,j]]
          end
      end
    end
    bathy_data = DataFrame(lon=bathy_raw[1:cpt,1], lat=bathy_raw[1:cpt,2], elv=bathy_raw[1:cpt,3])


# ==============================================================================
#  ACOUSTIC
# ==============================================================================

  ## Load --------------------------------------------------------------------
    acoustic_fname = string(data_dir,"/acoustic/kriged_acoustic_class.csv")
    acoustic_data = CSV.read(acoustic_fname, header=1, delim=",")

  ## Processing --------------------------------------------------------------
    cpt = zeros(Int64,Ny,Nx)
    for k in 1:length(acoustic_data.class)
      i = min(findall(acoustic_data.lat[k] .< lat_seq .+ lat_resol/2)...)
      j = min(findall(acoustic_data.lon[k] .< lon_seq .+ lon_resol/2)...)
      cpt[i,j] = cpt[i,j] + 1
    end

    acoustic_class_serie = zeros(Ny,Nx,max(cpt...))
    cpt = zeros(Int64,Ny,Nx)
    for k in 1:length(acoustic_data.class)
      i = min(findall(acoustic_data.lat[k] .< lat_seq .+ lat_resol/2)...)
      j = min(findall(acoustic_data.lon[k] .< lon_seq .+ lon_resol/2)...)
      cpt[i,j] = cpt[i,j] + 1
      acoustic_class_serie[i,j,cpt[i,j]] = acoustic_data.class[k]
    end

    acoustic_class_sum  = zeros(Ny,Nx)
    acoustic_class_mean = zeros(Ny,Nx)
    acoustic_class_med  = zeros(Ny,Nx)
    for i in 1:Ny
      for j in 1:Nx
        if cpt[i,j]>0
          acoustic_class_sum[i,j]  = sum(acoustic_class_serie[i,j,1:cpt[i,j]])
          acoustic_class_mean[i,j] = acoustic_class_sum[i,j]/cpt[i,j]
          acoustic_class_med[i,j]  = median(acoustic_class_serie[i,j,1:cpt[i,j]])
        end
      end
    end


# ==============================================================================
#  FISHING
# ==============================================================================

  ## Load --------------------------------------------------------------------
    fishing_fname = string(data_dir,"/fishing/fishing.csv")
    fishing_data  = CSV.read(fishing_fname, header=1, delim=",")

  ## Processing -------------------------------------------------------------
    fishing_intensity = zeros(Ny,Nx)
    for k in 1:length(fishing_data.ID)
      i = min(findall(fishing_data.lat[k] .< lat_seq .+ lat_resol/2)...)
      j = min(findall(fishing_data.lon[k] .< lon_seq .+ lon_resol/2)...)
      fishing_intensity[i,j] = fishing_intensity[i,j] + 1
    end

# ==============================================================================
#  DIVING
# ==============================================================================

  ## Load --------------------------------------------------------------------
    diving_fname = string(data_dir,"/diving/diving.csv")
    diving_data  = CSV.read(diving_fname, header=1, delim=",")

  ## Processing --------------------------------------------------------------
    diving_intensity = zeros(Ny,Nx)
    for k in 1:length(diving_data.level)
      i = min(findall(diving_data.lat[k] .< lat_seq .+ lat_resol/2)...)
      j = min(findall(diving_data.lon[k] .< lon_seq .+ lon_resol/2)...)
      diving_intensity[i,j] = diving_intensity[i,j] + diving_data.level[k]
    end
