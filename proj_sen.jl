# go to param.jl to change parameters
# This is a variation for proj.jl to perform sensitivity analysis
# check proj.jl for comments

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
# pyplot()

apeakloadpercentage = 0.01:0.01:0.10
ascale_solar = 0.1:0.1:1

cost1 = zeros(10,10)
cost2 = zeros(10,10)
cost3 = zeros(10,10)

for i = 1:10, j = 1:10

    peakloadpercentage = apeakloadpercentage[i]
    scale_solar = ascale_solar[j]

    # Scenario 1: normal solar, normal load and generation
    peak_switch = false
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
        generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, true, scale_solar)
    end
    transmission_matrix = loadtransmission(transmission_path, countrylist)

    charge, discharge, storage, peaker, cost = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep, nBattery, powercapacity, duration, transmissionloss)
    cost1[i,j] = cost
    println("sce1($i,$j)=$cost")
    f = open("cost_sen.txt","a")
    write(f,"sce1($i,$j)=$cost\n")
    close(f)

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
        generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, true, scale_solar)
    end
    transmission_matrix = loadtransmission(transmission_path, countrylist)

    charge, discharge, storage, peaker, cost = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep, nBattery, powercapacity, duration, transmissionloss)
    cost2[i,j] = cost
    println("sce2($i,$j)=$cost")
    f = open("cost_sen.txt","a")
    write(f,"sce2($i,$j)=$cost\n")
    close(f)

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
        generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, true, scale_solar)
    end
    transmission_matrix = loadtransmission(transmission_path, countrylist)

    charge, discharge, storage, peaker, cost = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep, nBattery, powercapacity, duration, transmissionloss)
    cost3[i,j] = cost
    println("sce3($i,$j)=$cost")
    f = open("cost_sen.txt","a")
    write(f,"sce3($i,$j)=$cost\n")
    close(f)

end

writedlm("cost1.txt", cost1, ",")
writedlm("cost2.txt", cost2, ",")
writedlm("cost3.txt", cost3, ",")
