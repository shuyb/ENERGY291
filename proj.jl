# go to param.jl to change parameters

using CSV, JuMP, LinearAlgebra, DataFrames, Plots, Cbc
include("param.jl")
include("abbr.jl")
include("load.jl")
include("planstorage.jl")
include("generation.jl")
include("balance.jl")
include("solar.jl")
include("rescale.jl")
include("offset.jl")
include("transmission.jl")
include("opt.jl")

abbreviation, abbreviation_reverse = loadabbr(abbreviation_path)
loadProfiles = loadload(load_path, abbreviation)
countrylist = sort(collect(keys(loadProfiles)))
nBattery = planstorage(loadProfiles, peakloadpercentage, powercapacity, duration)
generationProfiles = loadgeneration(generation_path, abbreviation)
loadbalance!(loadProfiles, generationProfiles, flow_path, injection_path, abbreviation_reverse)
solarProfiles = loadsolar(solar_path, countrylist)
offset!(loadProfiles, generationProfiles, peakadjusment_path, offset_switch)
for each in countrylist
    generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, true)
end
transmission_matrix = loadtransmission(transmission_path, countrylist)

charge, discharge, storage, peaker, cost = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep, nBattery, powercapacity, duration)

pyplot()
x = 1:nStep
for i = 1:length(countrylist)
    plot(size = (20000,300))
    println("plotting")
    plot!(x, charge[i,:], label = "charge", title = "$(countrylist[i])")
    plot!(x, discharge[i,:], label = "discharge")
    plot!(x, storage[i,:], label = "storage")
    plot!(x, peaker[i,:], label = "peaker")
    xlabel!("Time in a day (h)")
    xticks!(1:24:nStep)
    savefig("testrun/$(countrylist[i]).png")
end
