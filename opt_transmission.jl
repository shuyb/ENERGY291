function optimize(loadProfiles, generationProfiles, transmission_matrix, nStep, nBattery, powercapacity, duration)
    countrylist = sort(collect(keys(loadProfiles)))
    nBus = length(countrylist)
    # capacity for 1% of peakload
    chargeLimit = Array{Int, 1}()
    dischargeLimit = Array{Int, 1}()
    capacity = Array{Int, 1}()
    for (i,each) in enumerate(countrylist)
        push!(chargeLimit, powercapacity * nBattery[i])
        push!(dischargeLimit, powercapacity * nBattery[i])
        push!(capacity, powercapacity * duration * nBattery[i])
        println("$each has $(powercapacity * duration * nBattery[i])MW of storage")
    end

    # Utility-scale battery storage installations in PJM tend to have relatively large power capacities,
    # averaging 12 MW, and short discharge durations, averaging 45 minutes.
    # https://www.lazard.com/media/450774/lazards-levelized-cost-of-storage-version-40-vfinal.pdf
    LCOS = 120 # $/MWh
    # https://www.lazard.com/media/450784/lazards-levelized-cost-of-energy-version-120-vfinal.pdf
    peakerrate = 180 # $/MWh


    m = Model(solver = CbcSolver())

    @variable(m, discharge[1:nBus, 1:nStep] >= 0)
    @variable(m, charge[1:nBus, 1:nStep] >= 0)
    @variable(m, storage[1:nBus, 1:nStep] >= 0)
    @variable(m, peaker[1:nBus, 1:nStep] >= 0)
    @variable(m, transmission[1:nBus, 1:nBus, 1:nStep] >= 0)

    @constraint(m, [t = 1:nStep, b = 1:nBus], discharge[b, t] <= dischargeLimit[b])
    @constraint(m, [t = 1:nStep, b = 1:nBus], charge[b, t] <= chargeLimit[b])
    @constraint(m, [t = 1:nStep, b = 1:nBus], storage[b, t] <= capacity[b])
    @constraint(m, [b = 1:nBus], storage[b, 1] == 0)
    @constraint(m, [b = 1:nBus], discharge[b, 1] == 0)
    @constraint(m, [t = 2:nStep, b = 1:nBus], storage[b, t] == storage[b, t - 1] + charge[b, t] - discharge[b, t]) #+ sum(transmission[:,b,t] .* transmission_matrix[:,b]) - sum(transmission[b,:,t] .* transmission_matrix[b,:]))
    @constraint(m, [t = 1:nStep, b = 1:nBus], discharge[b, t] + sum(generationProfiles[countrylist[b]][t,:]) + peaker[b, t] + sum(transmission[:,b,t] .* transmission_matrix[:,b]) >= charge[b, t] + loadProfiles[countrylist[b]][t] + sum(transmission[b,:,t] .* transmission_matrix[b,:]))

    @objective(m, Min, sum(sum(discharge[b,t] * LCOS + peaker[b,t] * peakerrate for b = 1:nBus) for t = 1:nStep) + sum(transmission))
    println("Optimizing...")
    solve(m)
    println("Optimization finished.")

    charge = getvalue(charge)
    discharge = getvalue(discharge)
    storage = getvalue(storage)
    peaker = getvalue(peaker)
    cost = getobjectivevalue(m)
    transmission = sum(getvalue(transmission), dims = 3)

    return charge, discharge, storage, peaker, cost, transmission
end
