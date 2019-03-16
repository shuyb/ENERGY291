loadpath = "flow"
for each in readdir(loadpath)
    println("working on $each")
    temp = CSV.read(joinpath(loadpath, each), type = [String, Int, Int])
    deleterows!(temp, 1994)
    temp = convert(Matrix, temp[:,2:3])
    flowProfiles[each[1:4]] = temp
    plot(size = (20000,1000))
    plot!(x, flowProfiles[each[1:4]][:,1], label = "from", title = "$(each)", width = 3)
    plot!(x, flowProfiles[each[1:4]][:,2], label = "to", width = 3)
    xlabel!("Time in a day (h)")
    xticks!(1:24:8760)
    savefig("flowplot/$(each).png")

end
