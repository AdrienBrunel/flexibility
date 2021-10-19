# ==============================================================================
#  LOAD PACKAGES
# ==============================================================================
    ENV["GUROBI_HOME"]="/opt/gurobi901/linux64"
    ENV["GRB_LICENSE_FILE"]="/opt/gurobi901/linux64/gurobi.lic"

    if install_pkg==1
        import Pkg
        Pkg.add("Printf");
        Pkg.add("DataFrames");
        Pkg.add("DelimitedFiles");
        Pkg.add("CSV");
        Pkg.add("JuMP");
        Pkg.add("Cbc");
        Pkg.add("Gurobi");Pkg.build("Gurobi");
        Pkg.add("Plots");
        Pkg.add("GR");
        Pkg.add("NetCDF");
        Pkg.add("LinearAlgebra");
        Pkg.add("Distributions");
    end

    using Printf;
    using DataFrames;
    using DelimitedFiles;
    using CSV;
    using JuMP;
    using Cbc;
    using Gurobi
    using Plots;
    using GR;
    using NetCDF;
    using LinearAlgebra;
    using Distributions;
