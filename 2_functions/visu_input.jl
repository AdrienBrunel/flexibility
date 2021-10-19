# ==============================================================================
# INPUT VISUALISATION
# ==============================================================================

  ## PU vs Cost ----------------------------------------------------------------
    Plots.plot(xlim=xloc_lim, ylim=yloc_lim, title="PU vs Cost", xlabel=xloc_lab,
               ylabel=yloc_lab, size=(png_res_width,png_res_height),legend=false)
    C  = palette([:white, :yellow, :orange, :red],100)
    z  = input_data.c
    z1 = min(z...)
    z2 = max(z...)
    Z  = range(z1,z2,length=length(C))
    for k in 1:input_data.N
      xc = grid_data.xloc[k]
      yc = grid_data.yloc[k]
      zk = z[k]
      if z1!=z2
        idx = min(findall(Z .- zk .> 0)...,length(Z))
        t = (zk-Z[idx-1])/(Z[idx]-Z[idx-1])
        ck = t*col2rgb(C[idx])+(1-t)*col2rgb(C[idx-1])
      else
        idx = 1
        ck = col2rgb(C[idx])
      end
      Plots.plot!(rectangle(grid_data.lon_resol,grid_data.lat_resol,xc-grid_data.lon_resol/2,yc-grid_data.lat_resol/2),fillcolor=rgb2col(ck),linecolor=rgb2col(ck))
      if zk > 1
        Plots.annotate!([(xc,yc,"$(round(zk,digits=1))")])
      end
    end
    Plots.plot!(Plots.Shape(convert(Array,mpa_FdN_data.lon),convert(Array,mpa_FdN_data.lat)),fillcolor=:black,lw=0.5,opacity=0.2)
    #Plots.scatter!(Plots.Shape(convert(Array,mpa_FdN_data.lon),convert(Array,mpa_FdN_data.lat)),fillcolor=:red,lw=0.5,opacity=0.2)
    #Plots.plot!(Plots.Shape(convert(Array,coast_FdN_data.lon),convert(Array,coast_FdN_data.lat)),fillcolor=:black,lw=0.5,opacity=0.9,seriestype=:shape)
    Plots.scatter!(convert(Array,coast_FdN_data.lon),convert(Array,coast_FdN_data.lat),fillcolor=:black)
    ##Plots.plot!(Plots.Shape(test.x1,test.x2),fillcolor=:black,lw=0.5,opacity=0.9)
    png(string(pic_dir,"/cost.png"))

  ## PU vs CF ------------------------------------------------------------------
    for sp in 1:meta_data.spec_nb
      Plots.plot(xlim=xloc_lim, ylim=yloc_lim, title="PU vs CF$(sp)", xlabel=xloc_lab,
                 ylabel=yloc_lab, size=(png_res_width,png_res_height),legend=false)
      C  = palette([:white, :yellow, :orange, :red],100)
      z  = input_data.A[sp,:]
      z1 = min(z...)
      z2 = max(z...)
      Z  = range(z1,z2,length=length(C))
      for k in 1:input_data.N
        xc = grid_data.xloc[k]
        yc = grid_data.yloc[k]
        zk = z[k]
        if z1!=z2
          idx = min(findall(Z .- zk .> 0)...,length(Z))
          t = (zk-Z[idx-1])/(Z[idx]-Z[idx-1])
          ck = t*col2rgb(C[idx])+(1-t)*col2rgb(C[idx-1])
        else
          idx = 1
          ck = col2rgb(C[idx])
        end
        Plots.plot!(rectangle(grid_data.lon_resol,grid_data.lat_resol,xc-grid_data.lon_resol/2,yc-grid_data.lat_resol/2),fillcolor=rgb2col(ck),linecolor=rgb2col(ck))
        if zk > 0
          Plots.annotate!([(xc,yc,"$(round(zk,digits=1))")])
        end
      end
      Plots.plot!(Plots.Shape(convert(Array,mpa_FdN_data.lon),convert(Array,mpa_FdN_data.lat)),fillcolor=:black,lw=0.5,opacity=0.2)
      #Plots.scatter!(Plots.Shape(convert(Array,mpa_FdN_data.lon),convert(Array,mpa_FdN_data.lat)),fillcolor=:red,lw=0.5,opacity=0.2)
      #Plots.plot!(Plots.Shape(convert(Array,coast_FdN_data.lon),convert(Array,coast_FdN_data.lat)),fillcolor=:black,lw=0.5,opacity=0.9,seriestype=:shape)
      Plots.scatter!(convert(Array,coast_FdN_data.lon),convert(Array,coast_FdN_data.lat),fillcolor=:black)
      ##Plots.plot!(Plots.Shape(test.x1,test.x2),fillcolor=:black,lw=0.5,opacity=0.9)
      png(string(pic_dir,"/cf$(sp).png"))
    end

    #xticks = (grid_data.lon_seq, grid_data.lon_seq)
