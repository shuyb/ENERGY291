for each in countrylist
       a = loadProfiles[each] - generationProfiles[each][:,17]
       plt = plot(a[1970:1993,1],label = "Net load")
       b = loadProfiles[each]
       plt = plot!(b[1970:1993,1],label = "Total load")
       title!(each)
       savefig(plt, "Net load curve/$(each).png")
end


standard = readtable("t1.txt",header=false)
standard = convert(Array,standard)
standard2 = reshape(standard,(30,30))
standard3 = transpose(standard2)
standard3 - standard2
