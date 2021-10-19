# ==============================================================================
# INPUT VISUALISATION
# ==============================================================================

  ## Reserve solution ----------------------------------------------------------
    for n in 1:output_data.nsol
      global coverage_str = @sprintf("%.1f",output_data.coverage[1,n])
      global target_str = @sprintf("%.1f",input_data.t[1])
      for i in 2:input_data.P
        coverage_str = @sprintf("%s,%.1f",coverage_str,output_data.coverage[i,n])
        target_str   = @sprintf("%s,%.1f",target_str,input_data.t[i])
      end
      title = @sprintf("Reserve solution\n
                        %s | %s | BLM=%f | spec_nb=%d | target=%s | budget=%.1f\n
                        pu=%d | cost=%.1f | boundary=%.1f | score_minset=%.1f | score_maxcov=%.2f | coverage=%s",
                       meta_data.optim_type,meta_data.cost_type,meta_data.BLM,meta_data.spec_nb,target_str,input_data.b,
                       output_data.pu[n],output_data.cost[n],output_data.boundary[n],output_data.score_minset[n],output_data.score_maxcov[n],coverage_str)

      Plots.plot(xlim=xloc_lim, ylim=yloc_lim, title=title, xlabel=xloc_lab,
                 ylabel=yloc_lab, size=(png_res_width,png_res_height),legend=false)
      C  = palette([:white, :yellow, :orange, :red],100)
      z  = output_data.reserve[:,n]
      for k in 1:input_data.N
        xc = grid_data.xloc[k]
        yc = grid_data.yloc[k]
        zk = z[k]
        if zk == 1
          Plots.plot!(rectangle(grid_data.lon_resol,grid_data.lat_resol,xc-grid_data.lon_resol/2,yc-grid_data.lat_resol/2),fillcolor=:green,linecolor=:green)
        end
      end
      Plots.plot!(Plots.Shape(convert(Array,mpa_FdN_data.lon),convert(Array,mpa_FdN_data.lat)),fillcolor=:black,lw=0.5,opacity=0.2)
      Plots.scatter!(convert(Array,coast_FdN_data.lon),convert(Array,coast_FdN_data.lat),fillcolor=:black)
      png(string(pic_dir,"/solution_$(n).png"))
    end

  ## Selection frequency -------------------------------------------------------
    Plots.plot(xlim=xloc_lim, ylim=yloc_lim, title="Selection frequency", xlabel=xloc_lab,
               ylabel=yloc_lab, size=(png_res_width,png_res_height),legend=false)
    C = palette([:blue, :green],100)

    z = zeros(input_data.N,1)
    for k in 1:input_data.N
      z[k] = sum(output_data.reserve[k,:])/output_data.nsol
    end

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
      if zk > 0
        Plots.plot!(rectangle(grid_data.lon_resol,grid_data.lat_resol,xc-grid_data.lon_resol/2,yc-grid_data.lat_resol/2),fillcolor=rgb2col(ck),linecolor=rgb2col(ck))
        Plots.annotate!([(xc,yc,Plots.text(@sprintf("%.1f",100*zk),8))])
      end
    end
    Plots.plot!(Plots.Shape(convert(Array,mpa_FdN_data.lon),convert(Array,mpa_FdN_data.lat)),fillcolor=:black,lw=0.5,opacity=0.2)
    Plots.scatter!(convert(Array,coast_FdN_data.lon),convert(Array,coast_FdN_data.lat),fillcolor=:black)
    png(string(pic_dir,"/solution_frequency.png"))
