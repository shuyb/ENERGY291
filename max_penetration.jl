function max_pen(generationProfiles,solarProfiles,countrylist,scale_solar = 1)
    maxpenProfiles = Dict()
    for each in countrylist
        maxpenProfiles[each] = sum(solarProfiles[each])/sum(generationProfiles[each])
    end
    feasibility = Dict()
    for each in countrylist
        added_solar = sum(solarProfiles[each]) * scale_solar - sum(generationProfiles[each][:,17])
        fossil_scalable = sum(generationProfiles[each][:,[2:8;15]])
        if fossil_scalable <= added_solar
            feasibility[each] = "infeasible"
        else
            feasibility[each] = "feasible"
        end
    end
    solarmismatch = Dict()
    for each in countrylist
        deployed = sum(generationProfiles[each][:,17])
        totalavailable = sum(solarProfiles[each])
        if deployed > totalavailable
            solarmismatch[each] = "mismatch"
        else
            solarmismatch[each] = "okay"
        end
    end
    return feasibility,maxpenProfiles,solarmismatch
end

function check_EU_balance(countrylist,loadProfiles,generationProfiles)
    ##Total volume check
    TOTload = 0
    for each in countrylist
        #global TOTload = 0
        TOTload += sum(loadProfiles[each])
    end
    TOTgen = 0
    for each in countrylist
        #global TOTgen = 0
        TOTgen += sum(generationProfiles[each])
    end
    println("Load - Gen (GWh) = ",(TOTload - TOTgen)/1000)
    rescale_ratio = TOTload / TOTgen
    return rescale_ratio
end

function rescale_load(loadProfiles,countrylist,generationProfiles)
    loadRescaled = Dict()
    rescale_ratio = check_EU_balance(countrylist,loadProfiles,generationProfiles)
    for each in countrylist
        loadRescaled[each] = loadProfiles[each]/rescale_ratio
    end
    return loadRescaled
end
