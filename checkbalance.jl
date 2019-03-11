for i = 1:length(countrylist)
    plot(size = (20000,1000))
    plot!(x, loadProfiles[countrylist[i]][x], label = "load", title = "$(countrylist[i])")
    plot!(x, sum(generationProfiles[countrylist[i]][x,:], dims = 2), label = "generation")
    xlabel!("Time in a day (h)")
    xticks!(1:72:8760)
    savefig("checkbalance/$(countrylist[i]).png")
end

EUload = zeros(8760)
EUgen = zeros(8760)
for i = 1:length(countrylist)
    global EUload = EUload + loadProfiles[countrylist[i]]
    global EUgen = EUgen + sum(generationProfiles[countrylist[i]], dims = 2)
end
plot(size = (20000,1000))
plot!(x, EUload[x], label = "load", title = "EU")
plot!(x, EUgen[x], label = "generation")
xlabel!("Time in a day (h)")
xticks!(1:72:8760)
savefig("checkbalance/EU.png")
