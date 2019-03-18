for each in countrylist
       a = loadProfiles[each] - generationProfiles[each][:,17]
       plt = plot(a[1970:1993,1],label = "Net load")
       b = loadProfiles[each]
       plt = plot!(b[1970:1993,1],label = "Total load")
       title!(each)
       savefig(plt, "Net load curve/$(each).png")
end
