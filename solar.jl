# load solar profiles
function loadsolar(filename, countrylist)
    solarProfiles = Dict()
    temp = CSV.read(filename)
    for each in countrylist
        solarProfiles[each] = convert(Array{Float64}, temp[Symbol(each)])
    end
    return solarProfiles
end
