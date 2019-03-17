function offset!(loadProfiles, generationProfiles, filename, switch)
    if switch
        countrylist = sort(collect(keys(loadProfiles)))
        df = CSV.read(filename)
        offset = Dict()
        for i = 1:size(df,1)
            if df[i,1] in countrylist
                offset[df[i,1]] = df[i,4]
            end
        end
        for (k, v) in offset
            loadProfiles[k] = circshift(loadProfiles[k], v)
            generationProfiles[k] = circshift(generationProfiles[k], (v,0))
        end
    end
end
