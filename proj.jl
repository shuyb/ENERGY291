# go to param.jl to change parameters

using CSV, JuMP, LinearAlgebra, DataFrames, Plots, Cbc, DelimitedFiles
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
pyplot()


peakloadpercentage = 0.01
scale_solar = 1

# Scenario 1: normal solar, normal load and generation
offset_switch = false
solar_path = "2015EuropeSolarHourlyMW_GMT1.csv"

abbreviation, abbreviation_reverse = loadabbr(abbreviation_path)
loadProfiles = loadload(load_path, abbreviation)
countrylist = sort(collect(keys(loadProfiles)))
nBattery = planstorage(loadProfiles, peakloadpercentage, powercapacity, duration)
generationProfiles = loadgeneration(generation_path, abbreviation)
loadbalance!(loadProfiles, generationProfiles, flow_path, injection_path, abbreviation_reverse)
solarProfiles = loadsolar(solar_path, countrylist)
offset!(loadProfiles, generationProfiles, peakadjusment_path, offset_switch)
for each in countrylist
    generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, true, scale_solar)
end
transmission_matrix = loadtransmission(transmission_path, countrylist)

charge, discharge, storage, peaker, cost = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep, nBattery, powercapacity, duration)
cost1[i,j] = cost
println("sce1($i,$j)=$cost")
x = 1:nStep
# for i = 1:length(countrylist)
#     plot(size = (20000,300))
#     println("plotting")
#     plot!(x, charge[i,:], label = "charge", title = "$(countrylist[i])")
#     plot!(x, discharge[i,:], label = "discharge")
#     plot!(x, storage[i,:], label = "storage")
#     plot!(x, peaker[i,:], label = "peaker")
#     xlabel!("Time in a day (h)")
#     xticks!(1:24:nStep)
#     savefig("sce1/$(countrylist[i]).png")
# end

# Scenario 2: normal solar, unified load and generation
offset_switch = true
solar_path = "2015EuropeSolarHourlyMW_GMT1.csv"

abbreviation, abbreviation_reverse = loadabbr(abbreviation_path)
loadProfiles = loadload(load_path, abbreviation)
countrylist = sort(collect(keys(loadProfiles)))
nBattery = planstorage(loadProfiles, peakloadpercentage, powercapacity, duration)
generationProfiles = loadgeneration(generation_path, abbreviation)
loadbalance!(loadProfiles, generationProfiles, flow_path, injection_path, abbreviation_reverse)
solarProfiles = loadsolar(solar_path, countrylist)
offset!(loadProfiles, generationProfiles, peakadjusment_path, offset_switch)
for each in countrylist
    generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, true, scale_solar)
end
transmission_matrix = loadtransmission(transmission_path, countrylist)

charge, discharge, storage, peaker, cost = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep, nBattery, powercapacity, duration)
cost2[i,j] = cost
println("sce2($i,$j)=$cost")
x = 1:nStep
# for i = 1:length(countrylist)
#     plot(size = (20000,300))
#     println("plotting")
#     plot!(x, charge[i,:], label = "charge", title = "$(countrylist[i])")
#     plot!(x, discharge[i,:], label = "discharge")
#     plot!(x, storage[i,:], label = "storage")
#     plot!(x, peaker[i,:], label = "peaker")
#     xlabel!("Time in a day (h)")
#     xticks!(1:24:nStep)
#     savefig("sce2/$(countrylist[i]).png")
# end

# Scenario 3: unified solar, unified load and generation
offset_switch = true
solar_path = "2015EuropeSolarHourlyMW_Hypo.csv"

abbreviation, abbreviation_reverse = loadabbr(abbreviation_path)
loadProfiles = loadload(load_path, abbreviation)
countrylist = sort(collect(keys(loadProfiles)))
nBattery = planstorage(loadProfiles, peakloadpercentage, powercapacity, duration)
generationProfiles = loadgeneration(generation_path, abbreviation)
loadbalance!(loadProfiles, generationProfiles, flow_path, injection_path, abbreviation_reverse)
solarProfiles = loadsolar(solar_path, countrylist)
offset!(loadProfiles, generationProfiles, peakadjusment_path, offset_switch)
for each in countrylist
    generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, true, scale_solar)
end
transmission_matrix = loadtransmission(transmission_path, countrylist)

charge, discharge, storage, peaker, cost = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep, nBattery, powercapacity, duration)
cost3[i,j] = cost
println("sce3($i,$j)=$cost")
x = 1:nStep
# for i = 1:length(countrylist)
#     plot(size = (20000,300))
#     println("plotting")
#     plot!(x, charge[i,:], label = "charge", title = "$(countrylist[i])")
#     plot!(x, discharge[i,:], label = "discharge")
#     plot!(x, storage[i,:], label = "storage")
#     plot!(x, peaker[i,:], label = "peaker")
#     xlabel!("Time in a day (h)")
#     xticks!(1:24:nStep)
#     savefig("sce3/$(countrylist[i]).png")
# end
