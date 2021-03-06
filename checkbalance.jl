# run proj.jl first to check balance
pyplot()
for i = 1:length(countrylist)
    plot(size = (20000,1000), titlefont = 90, tickfont = 30, legendfont = 70, xrotation = 90, guidefont = 50)
    plot!(x, loadProfiles[countrylist[i]][x], label = "load", title = "$(countrylist[i])", width = 3)
    plot!(x, sum(generationProfiles[countrylist[i]][x,:], dims = 2), label = "generation", width = 3)
    xlabel!("Hour")
    ylabel!("MW")
    xticks!(1:24:8760)
    savefig("checkbalance/$(countrylist[i]).png")
end

EUload = zeros(8760)
EUgen = zeros(8760)
for i = 1:length(countrylist)
    global EUload = EUload + loadProfiles[countrylist[i]]
    global EUgen = EUgen + sum(generationProfiles[countrylist[i]], dims = 2)
end
plot(size = (20000,1000), titlefont = 90, tickfont = 30, legendfont = 70, xrotation = 90, guidefont = 50)
plot!(x, EUload[x], label = "load", title = "EU", width = 3)
plot!(x, EUgen[x], label = "generation", width = 3)
xlabel!("Hour")
ylabel!("MW")
xticks!(1:72:8760)
savefig("checkbalance/EU.png")
