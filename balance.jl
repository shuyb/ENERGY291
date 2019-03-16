loadpath = "flow"
flowProfiles = Dict()
for each in readdir(loadpath)
    println("working on $each")
    # original file
    temp = CSV.read(joinpath(loadpath, each), type = [String, Int, Int])
    deleterows!(temp, 1994)
    temp = convert(Matrix, temp[:,2:3])
    flowProfiles[each[1:4]] = temp
end

injection = Dict()
open("injectionsites.txt") do f
    for ln in eachline(f)
        if ln[1] != '0'
            linelength = length(ln)
            inside = ln[4:5]
            outside = Array{String, 1}()
            for i = 8:4:linelength
                push!(outside, ln[i:i+1])
            end
            injection[inside] = zeros(8760)
            for each in outside
                injection[inside] = injection[inside] + flowProfiles[inside * each][:,1] - flowProfiles[inside * each][:,2]
            end
        end
    end
end

# EUload = zeros(8760)
# EUgen = zeros(8760)
# for i = 1:length(countrylist)
#     global EUload = EUload + loadProfiles[countrylist[i]]
#     global EUgen = EUgen + sum(generationProfiles[countrylist[i]], dims = 2)
# end
#
# println(EUgen - EUload - flowProfiles["ESMA"] - flowProfiles["FIRU"][:,2] - flowProfiles["EERU"][:,2] - flowProfiles["LVRU"][:,2] - flowProfiles["LTRU"][:,2] - flowProfiles["LTBY"][:,2] - flowProfiles["PLUA"][:,2] - flowProfiles["SKUA"][:,2] - flowProfiles["HUUA"][:,2] - flowProfiles["ROUA"][:,2] - flowProfiles["BGTR"][:,2] - flowProfiles["GRTR"][:,2] - flowProfiles["GRAL"][:,2] - flowProfiles["RSAL"][:,2] - flowProfiles["MEAL"][:,2] - flowProfiles["SIHR"][:,2] - flowProfiles["BAHR"][:,2] - flowProfiles["RSHR"][:,2] - flowProfiles["HSHR"][:,2] + flowProfiles["FIRU"][:,1] + flowProfiles["EERU"][:,1] + flowProfiles["LVRU"][:,1] + flowProfiles["LTRU"][:,1] + flowProfiles["LTBY"][:,1] + flowProfiles["PLUA"][:,1] + flowProfiles["SKUA"][:,1] + flowProfiles["HUUA"][:,1] + flowProfiles["ROUA"][:,1] + flowProfiles["BGTR"][:,1] + flowProfiles["GRTR"][:,1] + flowProfiles["GRAL"][:,1] + flowProfiles["RSAL"][:,1] + flowProfiles["MEAL"][:,1] + flowProfiles["SIHR"][:,1] + flowProfiles["BAHR"][:,1] + flowProfiles["RSHR"][:,1] + flowProfiles["HSHR"][:,1])

# ESMA
# FIRU
# NORU
# EERU
# LVRU
# LTRU
# LTBY
# PLUA
# SKUA
# HUUA
# ROUA
# BGTR
# GRTR
# GRAL
# RSAL
# MEAL
# SIHR
# BAHR
# RSHR
# HUHR
