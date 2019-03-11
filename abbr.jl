# load country abbreviation
function loadabbr(filename)
    abbr = CSV.read(filename, header = 0)
    abbreviation = Dict()

    for i = 1:size(abbr)[1]
        abbreviation[abbr[i,1]] = abbr[i,2]
    end
    return abbreviation
end
