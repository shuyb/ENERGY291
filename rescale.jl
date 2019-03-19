# input actual generation one country
function rescale_generation(generationProfiles, solarProfiles, country, switch = true, scale_solar = 1)
    if switch
        println("Deploying $(scale_solar*100)% of all potential solar generation in $country.")
        generation = convert(Array{Float64}, abs.(generationProfiles[country]))
        solar = solarProfiles[country]
        Total_generation = sum(generation)
        generation_mix = ["Biomass", "Brown coal", "Coal derived gas", "Gas", "Hard coal", "Oil", "Oil shale", "Peat", "Geothermal", "Hydro", "Hydro river", "Hydro reservoir", "Marine", "Nuclear", "Other", "Other renewable", "Solar", "Waste", "Wind onshore", "Wind offshore"]
        #                  1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20
        # NotChangeable = [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1]
        # Changeable =    [0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        # Scalable =      [1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0]
        # coeff_condition = hcat(generation_mix, NotChangeable, Changeable, Scalable)
		ori_generation = copy(generation)

		current_scale = sum(generation[:,17]) / sum(solar)
		scale_solar = min(1, max(scale_solar, current_scale))
		if current_scale < 1
			generation[:,17] = solar
		else
			println("Cannot deploy more solar generation in $country.")
            return generationProfiles[country]
		end

        generation = float(generation)
        generation[:,[4;10:12]] = generation[:,[4;10:12]] .+ 0.0001

        c_var_s = 0.5/1000 # $/MWh
        c_var_w = 0.5/1000 # $/MWh
        c_var_gas = 41500/1000 # $/MWh
        c_var_nuc = 7025/1000 # $/MWh
        c_var_coal = 23000/1000 # $/MWh
        c_var_oil =  50000 / 1000 #$/MWh
        c_var_hydro = 0.85/100*1000 #$/MWh
        c_var_bio = 47 # $/MWh
        c_var_geo = 0 #cost doesn't matter for non-changeable resource
        c_var_mar = 0 #cost doesn't matter for non-changeable resource
        c_var_oth = 0 #cost doesn't matter for non-changeable resource

        cost = [c_var_bio, c_var_coal, c_var_gas, c_var_gas, c_var_coal, c_var_oil, c_var_oil, c_var_oil, c_var_geo, c_var_hydro, c_var_hydro, c_var_hydro, c_var_mar, c_var_nuc, c_var_oth, c_var_oth, c_var_s, c_var_oth, c_var_w, c_var_w]

        m = Model(solver = CbcSolver())

        @variable(m, coef[1:8760, 1:20] >= 0)
        # renewable sources are non-changeable nor scalable, excluding solar
        @constraint(m, [j = [9;13;15;16;18;19;20], i = 1:8760], coef[i,j] == 1)
        @constraint(m, [j = [1;2;5;6;7;8;14], i = 1:8759], coef[i,j] == coef[i,j+1]) # base load sources are scalable, but curve not changeable
        @constraint(m, [j = 10:12, i = 1:8760], coef[i,j]*generation[i,j] <= maximum(generation[:,j])) # hydro capacity limit
		@constraint(m, [j = 17, i = 1:8760], coef[i,j] == scale_solar) # solar is defined

        @expression(m, scaled_generation, coef .* generation)
        @constraint(m, [i=1:8760], sum(scaled_generation[i,:]) >= sum(ori_generation[i,:])) # > is fine, only happen when solar is more than total generation, solar will be stored in main model in this case

        @objective(m, Min, dot(sum(scaled_generation, dims = 1), cost))

        solve(m)
        # println("Error:", getobjectivevalue(m))
        # println("Scale:", getvalue(scale))
        coef = getvalue(coef)
        NEW_generation = abs.(getvalue(scaled_generation))
        # plot(transpose(sum(NEW_generation, dims=1)),label = "NEW")
        # plot!(transpose(sum(ori_generation, dims=1)),label = "OLD")
        return NEW_generation
    else
        return generationProfiles[country]
    end
end
