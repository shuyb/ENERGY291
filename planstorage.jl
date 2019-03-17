function planstorage(loadProfiles, perc, powercapacity, duration)
    countrylist = sort(collect(keys(loadProfiles)))
    nBattery = Array{Int, 1}()
    # capacity for 1% of peakload
    for each in countrylist
        peakload = maximum(loadProfiles[each])
        push!(nBattery, max(1, trunc(Int, peakload * perc / (powercapacity * duration))))
    end
    return nBattery
end
