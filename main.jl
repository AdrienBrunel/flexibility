clearconsole(); root_dir=pwd(); install_pkg=0;
# ==============================================================================
# 1 - PARAMETERS
# ==============================================================================
    folder = "example_algo3_gamma2_0.25_n_21"
    gen    = true
    opti   = true
    visu   = true

    println("manage_path.jl    ...");include(string(root_dir,"/2_functions/manage_path.jl"));
    println("manage_package.jl ...");include(string(func_dir,"/manage_package.jl"));
    println("load_functions.jl ...");include(string(func_dir,"/load_functions.jl"));
    println("load_struct.jl    ...");include(string(func_dir,"/load_struct.jl"));
    println("gen_grid.jl       ...");include(string(func_dir,"/gen_grid.jl"));

# ==============================================================================
# 2 - GENERATION
# ==============================================================================
if gen == true
    t1 = time_ns()
    println("gen_param.jl  ...");include(string(func_dir,"/gen_param.jl"));
    println("load_raw.jl   ...");include(string(func_dir,"/load_raw.jl"));
    println("gen_pu.jl     ...");include(string(func_dir,"/gen_pu.jl"));
    println("gen_puvspr.jl ...");include(string(func_dir,"/gen_puvspr.jl"));
    println("gen_spec.jl   ...");include(string(func_dir,"/gen_spec.jl"));
    println("gen_bound.jl  ...");include(string(func_dir,"/gen_bound.jl"));
    println("gen_budget.jl ...");include(string(func_dir,"/gen_budget.jl"));
    t2 = time_ns()
    @printf("\nInput files generated (%.2fs) \n\n",(t2-t1)/1e9)
end

# ==============================================================================
# 3 - OPTIMISATION
# ==============================================================================
if opti == true
    t1 = time_ns()
    println("optim_minset.jl ...");include(string(func_dir,"/optim_minset.jl"));
    println("load_param.jl   ...");include(string(func_dir,"/load_param.jl"));
    println("load_input.jl   ...");include(string(func_dir,"/load_input.jl"));
    println("optim_exe.jl    ...");include(string(func_dir,"/optim_exe.jl"));
    t2 = time_ns()
    @printf("\nOptimisation achieved (%.2fs) \n\n",(t2-t1)/1e9)
end

# ==============================================================================
# 4 - VISUALISATION
# ==============================================================================
if visu == true
    t1 = time_ns()
    println("load_param.jl  ...");include(string(func_dir,"/load_param.jl"));
    println("load_input.jl  ...");include(string(func_dir,"/load_input.jl"));
    println("load_output.jl ...");include(string(func_dir,"/load_output.jl"));
    println("visu_opt.jl    ...");include(string(func_dir,"/visu_opt.jl"));
    println("visu_input.jl  ...");include(string(func_dir,"/visu_input.jl"));
    println("visu_output.jl ...");include(string(func_dir,"/visu_output.jl"));
    t2 = time_ns()
    @printf("\nVisualisation over (%.2fs) \n\n",(t2-t1)/1e9)
end
