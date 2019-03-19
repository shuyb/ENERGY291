# go to param.jl to change parameters

using CSV, JuMP, LinearAlgebra, DataFrames, Plots, Cbc, DelimitedFiles
# stores parameters
include("param.jl")
# reads in country abbreviation and full name
include("abbr.jl")
# reads in country load profiles
include("load.jl")
# sizes battery storage given load profiles and parameters
include("planstorage.jl")
# reads in country generation profiles
include("generation.jl")
# balances EU-level load and generation with import/export data
include("balance.jl")
# reads in solar profile
include("solar.jl")
# rescales generation under given solar ultilization rate
include("rescale.jl")
# offset load/generation/solar
include("offset.jl")
# reads in transmission connectivity
include("transmission.jl")
# network optimization
include("opt.jl")
pyplot()

# the ratio of battery storage to peak load
peakloadpercentage = 0.01
# if solar utilization rate will be adjusted
scale_switch = true
# the fraction of all solar potential to be deployed
scale_solar = 0.1

# Scenario 1: normal solar, normal load and generation
peak_switch = false
solar_switch = false

# reads in country name abbreviation
abbreviation, abbreviation_reverse = loadabbr(abbreviation_path)
# reads in country load profiles
loadProfiles = loadload(load_path, abbreviation)
# generate a sorted list of countries to be studied
countrylist = sort(collect(keys(loadProfiles)))
# sizes battery storage given load profiles and parameters
nBattery = planstorage(loadProfiles, peakloadpercentage, powercapacity, duration)
# reads in country generation profiles
generationProfiles = loadgeneration(generation_path, abbreviation)
# balances EU-level load and generation with import/export data
loadbalance!(loadProfiles, generationProfiles, flow_path, injection_path, abbreviation_reverse)
# reads in solar profile
solarProfiles = loadsolar(solar_path, countrylist)
# offset load/generation/solar
offset!(loadProfiles, generationProfiles, peakadjusment_path, solaradjustment_path, peak_switch, solar_switch)
# rescales generation under given solar ultilization rate
for each in countrylist
    generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, scale_switch, scale_solar)
end
# reads in transmission connectivity
transmission_matrix = loadtransmission(transmission_path, countrylist)

charge1, discharge1, storage1, peaker1, cost1 = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep, nBattery, powercapacity, duration, transmissionloss)
x = 1:nStep
for i = 1:length(countrylist)
    plot(size = (20000,300))
    println("plotting")
    plot!(x, charge1[i,:], label = "charge", title = "$(countrylist[i])")
    plot!(x, discharge1[i,:], label = "discharge")
    plot!(x, storage1[i,:], label = "storage")
    plt = twinx()
    plot!(plt, peaker1[i,:], label = "peaker", color = :pink)
    xlabel!("Time in a day (h)")
    xticks!(1:24:nStep)
    savefig("sce1/$(countrylist[i]).png")
end

# Scenario 2: normal solar, unified load and generation
peak_switch = true
solar_switch = false

abbreviation, abbreviation_reverse = loadabbr(abbreviation_path)
loadProfiles = loadload(load_path, abbreviation)
countrylist = sort(collect(keys(loadProfiles)))
nBattery = planstorage(loadProfiles, peakloadpercentage, powercapacity, duration)
generationProfiles = loadgeneration(generation_path, abbreviation)
loadbalance!(loadProfiles, generationProfiles, flow_path, injection_path, abbreviation_reverse)
solarProfiles = loadsolar(solar_path, countrylist)
offset!(loadProfiles, generationProfiles, peakadjusment_path, solaradjustment_path, peak_switch, solar_switch)
for each in countrylist
    generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, scale_switch, scale_solar)
end
transmission_matrix = loadtransmission(transmission_path, countrylist)

charge2, discharge2, storage2, peaker2, cost2 = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep, nBattery, powercapacity, duration, transmissionloss)
x = 1:nStep
for i = 1:length(countrylist)
    plot(size = (20000,300))
    println("plotting")
    plot!(x, charge2[i,:], label = "charge", title = "$(countrylist[i])")
    plot!(x, discharge2[i,:], label = "discharge")
    plot!(x, storage2[i,:], label = "storage")
    plt = twinx()
    plot!(plt, peaker2[i,:], label = "peaker", color = :pink)
    xlabel!("Time in a day (h)")
    xticks!(1:24:nStep)
    savefig("sce2/$(countrylist[i]).png")
end

# Scenario 3: unified solar, unified load and generation
peak_switch = true
solar_switch = true

abbreviation, abbreviation_reverse = loadabbr(abbreviation_path)
loadProfiles = loadload(load_path, abbreviation)
countrylist = sort(collect(keys(loadProfiles)))
nBattery = planstorage(loadProfiles, peakloadpercentage, powercapacity, duration)
generationProfiles = loadgeneration(generation_path, abbreviation)
loadbalance!(loadProfiles, generationProfiles, flow_path, injection_path, abbreviation_reverse)
solarProfiles = loadsolar(solar_path, countrylist)
offset!(loadProfiles, generationProfiles, peakadjusment_path, solaradjustment_path, peak_switch, solar_switch)
for each in countrylist
    generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, scale_switch, scale_solar)
end
transmission_matrix = loadtransmission(transmission_path, countrylist)

charge3, discharge3, storage3, peaker3, cost3 = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep, nBattery, powercapacity, duration, transmissionloss)
x = 1:nStep
for i = 1:length(countrylist)
    plot(size = (20000,300))
    println("plotting")
    plot!(x, charge3[i,:], label = "charge", title = "$(countrylist[i])")
    plot!(x, discharge3[i,:], label = "discharge")
    plot!(x, storage3[i,:], label = "storage")
    plt = twinx()
    plot!(plt, peaker3[i,:], label = "peaker", color = :pink)
    xlabel!("Time in a day (h)")
    xticks!(1:24:nStep)
    savefig("sce3/$(countrylist[i]).png")
end
