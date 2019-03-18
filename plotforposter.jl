#Run this before loadbalance!
# Select country
country = "Austria"
# Get data for 23rd Mar 2018
x = 1:24
load = loadProfiles[country][1970:1993,1]
gen = generationProfiles[country][1970:1993,:]
gen_hydro = sum(gen[:,10:12],dims = 2)
gen_solar = gen[:,17]
gen_base = sum(gen[:,[1;2;5;6;7;8;14]],dims = 2)
gen_renewable = sum(gen[:,[9;13;15;16;17;18;19;20]],dims = 2)
gen_gas = sum(gen[:,3:4],dims = 2)
# Plot total load and net load
plt = plot(x,load,label = "Total Load", width = 3)
plt = plot!(x,load-gen_solar,label = "Net Load", width = 3)
xlabel!("Time in a day (hour)")
xticks!(1:1:24)
title!("Load of $country (MW), Mar-23-2018")
savefig(plt, "$(country)1.png")
# Plot generation by source
plt = plot(x,gen_base,label = "Base fossil", width = 3)
plt = plot!(x,gen_base+gen_renewable,label = "Plus renewable", width = 3)
plt = plot!(x,gen_base+gen_renewable+gen_hydro,label = "Plus hydro storage", width = 3)
plt = plot!(x,gen_base+gen_renewable+gen_hydro+gen_gas,label = "Plus gas peaker", width = 3)
xlabel!("Time in a day (hour)")
xticks!(1:1:24)
title!("Generation of $country (MW), Mar-23-2018")
savefig(plt, "$(country)2.png")
# Plus transmission
combo = ["ATCH" "ATCZ" "ATDE" "ATHU" "ATSI"]
plt = plot()
for each in combo
    temp = CSV.read(joinpath("flow", "$each.csv"), type = [String, Int, Int])
    deleterows!(temp, 1994)
    temp = convert(Matrix, temp[:,2:3])
    inflow = temp[1970:1993,1]
    outflow = temp[1970:1993,2]
    counterpart = abbreviation[each[3:4]]
    if sum(inflow) > 0
        plt = plot!(x,inflow,label = "Import from $counterpart", width = 3)
    end
    if sum(outflow) > 0
        plt = plot!(x,-outflow,label = "Export to $counterpart", width = 3)
    end
end
title!("Tranmission of $country (MW), Mar-23-2018")
xlabel!("Time in a day (hour)")
xticks!(1:1:24)
savefig(plt, "$(country)3.png")
