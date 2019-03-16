# load country abbreviation
function loadabbr(filename)
    abbr = CSV.read(filename, header = 0)
    abbreviation = Dict()
    revabbr = Dict()

    for i = 1:size(abbr)[1]
        abbreviation[abbr[i,1]] = abbr[i,2]
        revabbr[abbr[i,2]] = abbr[i,1]
    end
    return abbreviation, revabbr
end
