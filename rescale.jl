#input actual generation one country
function rescale_generation(generationProfiles, solarProfiles, country, switch = true, scale_solar = 1)
    if switch
        generation = generationProfiles[country]
        generation = broadcast(abs,generation) #convert all value to positive
        generation = convert(Array{Float64},generation)
        solar = solarProfiles[country]
        Total_generation = sum(generation)
        max_penetration = sum(solar)/sum(generation)
        generation_mix = ["Biomass","Brown coal","Coal derived gas","Gas","Hard coal","Oil","Oil shale","Peat","Geothermal","Hydro river","Hydro reservoir","Marine","Nuclear","Other","Other renewable","Solar","Waste","Wind onshore","Wind offshore"]
        #Scale = float([1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1])
        #Scale_changeable = [0 1 1 1 1 1 1 1 0 0 0 0 0 1 0 0 0 0 0]
        default_scale_solar = sum(generation[:,16])/sum(solar)
        scale_solar = max(1, scale_solar)
        generation[:,16] = solar
        generation = transpose(generation) #transpose matrix

        m = Model(solver = CbcSolver())
        @variable(m, 0 <= scale[i=1:19] <= 1)
        @constraint(m, [i=[1;9:13;15;17:19]], scale[i] == 1)
        @constraint(m, scale[16] == scale_solar)
        @expression(m, scaled_generation, sum(transpose(scale) * generation))
        @constraint(m, scaled_generation <= Total_generation)

        @objective(m, Min, Total_generation - scaled_generation)

        solve(m)
        # println("Error:", getobjectivevalue(m))
        # println("Scale:", getvalue(scale))
        scale_factor = getvalue(scale)
        NEW_generation = scale_factor .* generation
        gen_curve = sum(NEW_generation, dims=1)
        plot1 = plot(transpose(gen_curve))
        plot2 = plot(transpose(sum(generation, dims=1)))
        return NEW_generation, scale_solar / default_scale_solar
    else
        return generationProfiles[country], 0
    end
end
