function offset!(loadProfiles, generationProfiles, peakadj, solaradj, pswitch, sswitch)
    if pswitch
        countrylist = sort(collect(keys(loadProfiles)))
        df = CSV.read(peakadj)
        offset = Dict()
        for i = 1:size(df,1)
            if df[i,1] in countrylist
                offset[df[i,1]] = df[i,4]
            end
        end
        for (k, v) in offset
            loadProfiles[k] = circshift(loadProfiles[k], v)
            generationProfiles[k][:,1:16] = circshift(generationProfiles[k][:,1:16], (v,0))
            generationProfiles[k][:,18:20] = circshift(generationProfiles[k][:,18:20], (v,0))
        end
    end

    if sswitch
        countrylist = sort(collect(keys(loadProfiles)))
        df = CSV.read(solaradj)
        offset = Dict()
        for i = 1:size(df,1)
            if df[i,1] in countrylist
                offset[df[i,1]] = df[i,4]
            end
        end
        for (k, v) in offset
            generationProfiles[k][:,17] = circshift(generationProfiles[k][:,17], (v,0))
        end
    end
end
