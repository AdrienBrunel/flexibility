# flexibility
Code associated with the publication "Provide flexibility in the reserve site selection problem with exact resolution methods"

# steps
1. If this is the first time the code run on your computer, you have to set install_pkg variable to 1 so the needed Julia package can be installed. Otherwise, set the variable to 0

2. Julia version for this code is 1.4.2

3. Fill in parameter values in gen_param.jl file according to the scenario you want to simulate

4. In main.jl, give a name to the scenario your want to simulate. Set "gen", "opti" and "visu" variables to true values if you want to generate input data, solve the reserve site selection optimisation problem and visualize the results. 

5. Run main.jl

6. Results of the scenario simulation will be produced and stored in /3_results/your_scenario_name/ inside .csv files

7. Figures associated with the results will be produced and stored in /4_report/your_scenario_name/ 
