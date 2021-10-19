  # Coast -------------------------------------------------------------------
    coast_FdN_fname = string(data_dir,"/noronha/coast_FdN.csv")
    coast_FdN_data  = CSV.read(coast_FdN_fname, delim=",", header=1)

  # MPA ---------------------------------------------------------------------
    mpa_FdN_fname = string(data_dir,"/noronha/mpa_FdN.csv")
    mpa_FdN_data  = CSV.read(mpa_FdN_fname, delim=",", header=1)

  # Plot --------------------------------------------------------------------
    png_res_width  = 1360
    png_res_height = 775
    xloc_lab = "Longitude [deg]"
    yloc_lab = "Latitude [deg]"
    xloc_lim = grid_data.lon_range
    yloc_lim = grid_data.lat_range
