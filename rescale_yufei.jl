#input actual generation one country
function rescale_generation(generationProfiles, solarProfiles, country, switch = true, scale_solar = 1)
    if switch
        println("Working on: ",country)
        generation = generationProfiles[country]
        generation = broadcast(abs,generation) #convert all value to positive
        generation = convert(Array{Float64},generation)
        solar = solarProfiles[country]
        Total_generation = sum(generation)
        max_penetration = sum(solar)/sum(generation)
        generation_mix = ["Biomass","Brown coal","Coal derived gas","Gas","Hard coal","Oil","Oil shale","Peat","Geothermal","Hydro","Hydro river","Hydro reservoir","Marine","Nuclear","Other","Other renewable","Solar","Waste","Wind onshore","Wind offshore"]
        #Scale = float([1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1])
        #Scale_changeable = [0 1 1 1 1 1 1 1 0 0 0 0 0 0 1 0 0 0 0 0]
        #default_scale_solar = sum(generation[:,17])/sum(solar)
        #scale_solar = min(scale_solar,1)
        #scale_solar = max(scale_solar,default_scale_solar)
        current_solar = sum(generationProfiles[country][:,17])
        max_solar = sum(solarProfiles[country])
        if max_solar > current_solar
            generation[:,17] = solar
        end
        generation = transpose(generation) #transpose matrix

        m = Model(solver = ClpSolver())
        @variable(m, 0 <= scale[i=1:20] <= 1)
        @constraint(m, [i=[1;9:14;16;18:20]], scale[i] == 1)
        @constraint(m, scale[17] == scale_solar)
        @expression(m, scaled_generation, sum(transpose(scale) * generation))
        @constraint(m, scaled_generation >= Total_generation)

        @objective(m, Min, -Total_generation + scaled_generation)

        solve(m)
        # println("Error:", getobjectivevalue(m))
        # println("Scale:", getvalue(scale))
        scale_factor = getvalue(scale)
        NEW_generation = scale_factor .* generation
        gen_curve = sum(NEW_generation, dims=1)
        plot1 = plot(transpose(gen_curve))
        plot2 = plot(transpose(sum(generation, dims=1)))
        return transpose(NEW_generation)
    else
        return generationProfiles[country]
    end
end
