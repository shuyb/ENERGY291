# for each in countrylist
#        a = loadProfiles[each] - generationProfiles[each][:,17]
#        plt = plot(a[1970:1993,1],label = "Net load")
#        b = loadProfiles[each]
#        plt = plot!(b[1970:1993,1],label = "Total load")
#        title!(each)
#        savefig(plt, "netload/$(each).png")
# end

for each in countrylist
		shift = 3
		a = loadProfiles[each] - generationProfiles[each][:,17]
		plt = plot(2 * a[1970:1993+shift,1],label = "2 * Netload", width = 3)
		couple = a + circshift(a,shift)
		plt = plot!(couple[1970:1993+shift,1], label = "2 * Netload with $(shift)hrs shift", width = 3)
		plt = hline!([minimum(couple[1970+11:1993+shift-6,1])], ls = :dot, width = 3, color = :black, label = "")
		plt = hline!([maximum(couple[1970+6:1993+shift,1])], ls = :dot, width = 3, color = :black, label = "")
		xticks!(1:1:24+shift)
		ylabel!("MW")
		xlabel!("Hour")
		title!("Offset effect with $(each)")
		savefig(plt, "duck/$(each).png")
end
