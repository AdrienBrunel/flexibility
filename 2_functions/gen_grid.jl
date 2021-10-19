# ==============================================================================
# DISCRETISATION GRID
# ==============================================================================

    ## Resolution --------------------------------------------------------------
        lon_resol = 0.01
        lat_resol = 0.01 

    ## Boundaries --------------------------------------------------------------
        lon_range = [-32.65,-32.30]
        lat_range = [-3.95,-3.75]

    ## Grid vector -------------------------------------------------------------
        lon_seq = lon_range[1]:lon_resol:lon_range[2]
        lat_seq = lat_range[1]:lat_resol:lat_range[2]

    ## PU number ---------------------------------------------------------------
        Nx = length(lon_seq)
        Ny = length(lat_seq)
        pu_nb = Nx*Ny
