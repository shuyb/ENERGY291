using CSV, JuMP, Clp, DataFrames, Plots, Cbc
include("abbr.jl")
include("load.jl")
include("generation.jl")
include("solar.jl")
include("rescale.jl")
include("offset.jl")
include("transmission.jl")
include("opt.jl")
include("max_penetration.jl")
include("balance.jl")

abbreviation = loadabbr("abbr.csv")
loadProfiles = loadload("2018", abbreviation)
countrylist = sort(collect(keys(loadProfiles)))
generationProfiles = loadgeneration("generation", abbreviation)
offset_status = 2 #0 standard #1:offset all but solar #2:offset only solar #offset all
if offset_status == 0
    solarProfiles = loadsolar("2015EuropeSolarHourlyMW_GMT1.csv", countrylist)
    for each in countrylist
        generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, true)
    end
elseif offset_status == 1
    solarProfiles = loadsolar("2015EuropeSolarHourlyMW_GMT1.csv", countrylist)
    offset!(loadProfiles, generationProfiles, "peakadjusment.csv")
    for each in countrylist
        generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, true)
    end
elseif offset_status == 2
    solarProfiles = loadsolar("2015EuropeSolarHourlyMW_Hypo.csv", countrylist)
    for each in countrylist
        generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, true)
    end
elseif offset_status == 3
    solarProfiles = loadsolar("2015EuropeSolarHourlyMW_Hypo.csv", countrylist)
    offset!(loadProfiles, generationProfiles, "peakadjusment.csv")
    for each in countrylist
        generationProfiles[each] = rescale_generation(generationProfiles, solarProfiles, each, true)
    end
end

transmission_matrix = loadtransmission("transmission.csv", countrylist)
loadRescaled = rescale_load(loadProfiles,countrylist,generationProfiles)

nStep = 8760
#charge, discharge, storage, peaker, cost,transmission = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep)
charge, discharge, storage, peaker, cost,transmission = optimize(loadRescaled, generationProfiles, transmission_matrix, nStep)

pyplot()
x = 1:nStep
for i = 1:length(countrylist)
    plot(size = (800,200))
    println("plotting")
    plot!(x, charge[i,:], label = "charge", title = "$(countrylist[i])")
    plot!(x, discharge[i,:], label = "discharge")
    plot!(x, storage[i,:], label = "storage")
    plot!(x, peaker[i,:], label = "peaker")
    xlabel!("Time in a day (h)")
    xticks!(1:24:288)
    savefig("2018standard/$(countrylist[i]).png")
end
