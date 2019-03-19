loadpath = "flow"
for each in readdir(loadpath)
    println("working on $each")
    temp = CSV.read(joinpath(loadpath, each), type = [String, Int, Int])
    deleterows!(temp, 1994)
    temp = convert(Matrix, temp[:,2:3])
    flowProfiles[each[1:4]] = temp
    plot(size = (20000,1000), titlefont = 90, tickfont = 30, legendfont = 70, xrotation = 90, guidefont = 50)
    plot!(x, flowProfiles[each[1:4]][:,1], label = "from", width = 3)
    plot!(x, flowProfiles[each[1:4]][:,2], label = "to", width = 3)
    xlabel!("Time in a day (h)")
    xticks!(vcat(collect(0:72:8760),8760))
    xlabel!("Hour")
    ylabel!("MW")
    title!("Physical flow between $(abbreviation[each[1:2]]) and $(abbreviation[each[3:4]])")
    savefig("flowplot/$(each).png")
end
