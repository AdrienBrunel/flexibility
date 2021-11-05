# ==============================================================================
#  MINSET ; W BLM ; W LINEARIZATION ; GUROBI ; FIND ALTERNATIVES
# ==============================================================================

	## Algo 1 ------------------------------------------------------------------
	function minset_flex_algo1(data,meta)

		# solutions collection
		X = zeros(data.N,meta.nsol)

		# model declaration
		P = Model(Gurobi.Optimizer)
		#set_optimizer_attribute(model, "TimeLimit", 100)

	    #m = Model(Cbc.Optimizer)
		#set_optimizer_attribute(m, "logLevel", 1)
		#set_optimizer_attribute(m, "maxnodes", 100000)
		#set_optimizer_attribute(m, "seconds", 1000)
		#set_optimizer_attribute(m, "ratiogap", 0.001)

		# ranges
		PU = 1:data.N
		CF = 1:data.P
		LZ = 1:data.M
		FI = 1:data.F

		# decision variable
	    @variable(P, x[PU,1], Bin)
	    @variable(P, z[LZ,1], Bin)

	    # minset objective
	    @objective(P, Min, sum(data.c[j,1]*x[j,1] for j in PU) + meta.BLM*sum(data.SB[l,1]*x[data.SB[l,2],1] for l in LZ) - meta.BLM*sum(data.SB[l,1]*z[l,1]  for l in LZ) + meta.BLM*sum(data.SEF[f,1]*x[data.SEF[f,2],1] for f in FI))

		# target constraints
	    @constraint(P, targets[i in CF],  sum(data.A[i,j]*x[j,1] for j in PU) >= data.t[i,1])

		# locked out/in constraints
	    @constraint(P, locked_out[j in meta.locked_out],  x[j,1] == 0)
	    @constraint(P, locked_in[j in meta.locked_in],  x[j,1] == 1)

		# linearization constraints
	    @constraint(P, linzi[l in LZ],  z[l,1] - x[data.SB[l,2],1] <= 0)
	    @constraint(P, linzk[l in LZ],  z[l,1] - x[data.SB[l,3],1] <= 0)
	    @constraint(P, linzik[l in LZ],  z[l,1] - x[data.SB[l,2],1] - x[data.SB[l,3],1] >= -1)


		optimize!(P);
		xhat = value.(P[:x]).data
		zhat = objective_value(P)
		X[:,1] = xhat

		# add objetive gap constraint
		@constraint(P, sum(data.c[j,1]*x[j,1] for j in PU) + meta.BLM*sum(data.SB[l,1]*x[data.SB[l,2],1] for l in LZ) - meta.BLM*sum(data.SB[l,1]*z[l,1]  for l in LZ) + meta.BLM*sum(data.SEF[f,1]*x[data.SEF[f,2],1] for f in FI) >= (1+meta.gap[1])*zhat)
		@constraint(P, sum(data.c[j,1]*x[j,1] for j in PU) + meta.BLM*sum(data.SB[l,1]*x[data.SB[l,2],1] for l in LZ) - meta.BLM*sum(data.SB[l,1]*z[l,1]  for l in LZ) + meta.BLM*sum(data.SEF[f,1]*x[data.SEF[f,2],1] for f in FI) <= (1+meta.gap[2])*zhat)

		# recursive algo to cut known solutions
		k = 1
		while (termination_status(P) != MOI.INFEASIBLE_OR_UNBOUNDED) & (k<meta.nsol)
			@constraint(P, sum(xhat[j,1]*(1-x[j,1])+x[j,1]*(1-xhat[j,1]) for j in PU) >= 1)
			optimize!(P);
			#if (termination_status(P) != MOI.INFEASIBLE)
			if (termination_status(P) != MOI.INFEASIBLE_OR_UNBOUNDED)
				k = k+1
				xhat = value.(P[:x]).data
				@printf("iteration %d : %.2f <= %.2f <= %.2f \n",k,(1+meta.gap[1])*zhat,objective_value(P),(1+meta.gap[2])*zhat)
				X[:,k] = xhat
			end
		end

		return X[:,1:k]
	end


	## Algo 2 ------------------------------------------------------------------
	function minset_flex_algo2(data,meta)

		# solutions collection
		X = zeros(data.N,meta.nsol)

		# model declaration
		P = Model(Gurobi.Optimizer)

		# ranges
		PU = 1:data.N
		CF = 1:data.P
		LZ = 1:data.M
		FI = 1:data.F

		# decision variable
		@variable(P, x[PU,1], Bin)
		@variable(P, z[LZ,1], Bin)

		# minset objective
		@objective(P, Min, sum(data.c[j,1]*x[j,1] for j in PU) + meta.BLM*sum(data.SB[l,1]*x[data.SB[l,2],1] for l in LZ) - meta.BLM*sum(data.SB[l,1]*z[l,1]  for l in LZ) + meta.BLM*sum(data.SEF[f,1]*x[data.SEF[f,2],1] for f in FI))

		# target constraints
		@constraint(P, targets[i in CF],  sum(data.A[i,j]*x[j,1] for j in PU) >= data.t[i,1])

		# locked out/in constraints
		@constraint(P, locked_out[j in meta.locked_out],  x[j,1] == 0)
		@constraint(P, locked_in[j in meta.locked_in],  x[j,1] == 1)

		# linearization constraints
		@constraint(P, linzi[l in LZ],  z[l,1] - x[data.SB[l,2],1] <= 0)
		@constraint(P, linzk[l in LZ],  z[l,1] - x[data.SB[l,3],1] <= 0)
		@constraint(P, linzik[l in LZ],  z[l,1] - x[data.SB[l,2],1] - x[data.SB[l,3],1] >= -1)


		optimize!(P);
		xhat = value.(P[:x]).data
		zhat = objective_value(P)
		X[:,1] = xhat

		# recursive algo to cut known solutions
		k = 1
		while (termination_status(P) != MOI.INFEASIBLE_OR_UNBOUNDED) & (k<meta.nsol)
			@constraint(P, sum(X[j,k]*(1-x[j,1]) for j in PU) >= meta.dpu)
			optimize!(P);

			if (termination_status(P) != MOI.INFEASIBLE_OR_UNBOUNDED)
				k = k+1
				X[:,k] = value.(P[:x]).data
				@printf("iteration %d : z=%.2f \n",k,objective_value(P))
			end
		end

		return X[:,1:k]
	end


	## Algo 3 ------------------------------------------------------------------
	function minset_flex_algo3(data,meta)

		# solutions collection
		X = zeros(data.N,meta.nsol)

		# model declaration
		P = Model(Gurobi.Optimizer)

		# ranges
		PU = 1:data.N
		CF = 1:data.P
		LZ = 1:data.M
		FI = 1:data.F

		# decision variable
		@variable(P, x[PU,1], Bin)
		@variable(P, z[LZ,1], Bin)

		# minset objective
		@objective(P, Min, sum(data.c[j,1]*x[j,1] for j in PU) + meta.BLM*sum(data.SB[l,1]*x[data.SB[l,2],1] for l in LZ) - meta.BLM*sum(data.SB[l,1]*z[l,1]  for l in LZ) + meta.BLM*sum(data.SEF[f,1]*x[data.SEF[f,2],1] for f in FI))

		# target constraints
		@constraint(P, targets[i in CF],  sum(data.A[i,j]*x[j,1] for j in PU) >= data.t[i,1])

		# locked out/in constraints
		@constraint(P, locked_out[j in meta.locked_out],  x[j,1] == 0)
		@constraint(P, locked_in[j in meta.locked_in],  x[j,1] == 1)

		# linearization constraints
		@constraint(P, linzi[l in LZ],  z[l,1] - x[data.SB[l,2],1] <= 0)
		@constraint(P, linzk[l in LZ],  z[l,1] - x[data.SB[l,3],1] <= 0)
		@constraint(P, linzik[l in LZ],  z[l,1] - x[data.SB[l,2],1] - x[data.SB[l,3],1] >= -1)


		optimize!(P);
		xhat = value.(P[:x]).data
		zhat = objective_value(P)
		X[:,1] = xhat


		# recursive algo to cut known solutions
		k = 1
		@variable(P, delta)
		@objective(P, Max, delta)
		@constraint(P, budget, sum(data.c[j,1]*x[j,1] for j in PU) + meta.BLM*sum(data.SB[l,1]*x[data.SB[l,2],1] for l in LZ) - meta.BLM*sum(data.SB[l,1]*z[l,1]  for l in LZ) + meta.BLM*sum(data.SEF[f,1]*x[data.SEF[f,2],1] for f in FI) <= (1+meta.gap[2])*zhat)
		while (termination_status(P) != MOI.INFEASIBLE_OR_UNBOUNDED) & (k<meta.nsol)
			@constraint(P, sum(xhat[j,1]*(1-x[j,1]) for j in PU) >= delta)
			optimize!(P);
			if (termination_status(P) != MOI.INFEASIBLE_OR_UNBOUNDED)
				k = k+1
				xhat = value.(P[:x]).data
				zhat = objective_value(P)

				xhat = value.(P[:x]).data
				X[:,k] = xhat
				for tmp in 1:(k-1)
					@printf("d(x^%d,x)=%d\n",tmp-1,PseudoDistance(X[:,tmp],xhat))
				end
			end
		end

		return X[:,1:k]
	end
