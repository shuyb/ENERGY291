function loadbalance!(loadProfiles, generationProfiles, loadpath, inject, abbreviation)
    flowProfiles = Dict()
    for each in readdir(loadpath)
        temp = CSV.read(joinpath(loadpath, each), type = [String, Int, Int])
        deleterows!(temp, 1994)
        temp = convert(Matrix, temp[:,2:3])
        flowProfiles[each[1:4]] = temp
    end

    inflow = Dict()
    outflow = Dict()
    sumofinflow = 0
    sumofoutflow = 0
    open(inject) do f
        for ln in eachline(f)
            if ln[1] != '0'
                linelength = length(ln)
                inside = ln[4:5]
                outside = Array{String, 1}()
                for i = 8:4:linelength
                    push!(outside, ln[i:i+1])
                end
                inflow[inside] = zeros(8760)
                outflow[inside] = zeros(8760)
                for each in outside
                    inflow[inside] = inflow[inside] + flowProfiles[inside * each][:,1]
                    outflow[inside] = outflow[inside] + flowProfiles[inside * each][:,2]
                end
                inflow[inside] = sum(inflow[inside])
                outflow[inside] = sum(outflow[inside])
                sumofinflow += inflow[inside]
                sumofoutflow += outflow[inside]
            end
        end
    end

    EUload = zeros(8760)
    EUgen = zeros(8760)
    for i = 1:length(countrylist)
        EUload = EUload + loadProfiles[countrylist[i]]
        EUgen = EUgen + sum(generationProfiles[countrylist[i]], dims = 2)
    end

    scale = (EUload - EUgen) / (sumofoutflow - sumofinflow)

    for (k,v) in loadProfiles
        if haskey(inflow, abbreviation[k])
            println("Tweaking the load profile of $(k)")
            loadProfiles[k] += scale * inflow[abbreviation[k]] - scale * outflow[abbreviation[k]]
        end
    end

    EUload = zeros(8760)
    for i = 1:length(countrylist)
        EUload = EUload + loadProfiles[countrylist[i]]
    end
    println("The load-generation difference is $(sum(EUload - EUgen))")
end
