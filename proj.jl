using CSV, JuMP, Clp, DataFrames, Plots, Cbc
include("abbr.jl")
include("load.jl")
include("generation.jl")
include("solar.jl")
include("rescale.jl")
include("offset.jl")
include("transmission.jl")
include("opt.jl")

abbreviation = loadabbr("abbr.csv")
loadProfiles = loadload("2018", abbreviation)
countrylist = sort(collect(keys(loadProfiles)))
generationProfiles = loadgeneration("generation", abbreviation)
solarProfiles = loadsolar("2015EuropeSolarHourlyMW_GMT1.csv", countrylist)
# offset!(loadProfiles, generationProfiles, "peakadjusment.csv")
# for each in countrylist
#     generationProfiles[each], ratio = rescale_generation(generationProfiles, solarProfiles, each, true)
# end
transmission_matrix = loadtransmission("transmission.csv", countrylist)

nStep = 288
charge, discharge, storage, peaker, cost = optimize(loadProfiles, generationProfiles, transmission_matrix, nStep)

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
    savefig("testrun/$(countrylist[i]).png")
end
