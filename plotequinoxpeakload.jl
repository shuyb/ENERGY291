x = 1:48
for (k,v) in loadProfiles
    plt = plot(x, v[1946:1993], label = "$(k)", width = 2)
    plt = vline!([24], label = "24 hrs")
    # plt = scatter!(argmax(v[1946:1969]) - 1946, maximum(v[1946:1969]), markersize = 3, markercolor = :red)
    plt = scatter!([argmax(v[1962:1969])+4+12], [maximum(v[1962:1969])], label = "Day1, $(argmax(v[1962:1969])+4+12)")
    plt = scatter!([argmax(v[1986:1993])+4+12 + 24], [maximum(v[1986:1993])], label = "Day2, $(argmax(v[1986:1993])+4+12)")
    xlabel!("Time on equinox (h)")
    xticks!(1:1:48)
    savefig(plt, "loadProfiles/$(k).png")
end

for each in sort(collect(keys(generationProfiles)))
    println(each)
end
