using CSV
using JuMP
using Clp
using DataFrames
using Plots

loadProfiles = Dict()
for each in readdir("Total Load/")
    # original file
    temp = CSV.read("./Total Load/$(each)")
    # stores hourly actual load
    loadProfiles[each] = temp
end

for (k,v) in loadProfiles
    for r = 1:nrow(v)
        for i = 3
            if ismissing(v[r,i])
                println("($r,$i) in $k")
            end
        end
    end
end
