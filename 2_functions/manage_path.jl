# ==============================================================================
#  PATH MANAGEMENT
# ==============================================================================
    home_dir   = homedir();
    data_dir   = string(root_dir,"/1_data");
    func_dir   = string(root_dir,"/2_functions");
    res_dir    = string(root_dir,"/3_results");
    report_dir = string(root_dir,"/4_report");
    sc_dir     = string(res_dir,"/",folder);
    input_dir  = string(sc_dir,"/input");
    output_dir = string(sc_dir,"/output");
    pic_dir    = string(report_dir,"/pictures/",folder);

    dirs = [sc_dir;input_dir;output_dir;pic_dir]
    for i in 1:length(dirs)
        if !isdir(dirs[i,1])
            mkdir(dirs[i,1]);
        end
    end
