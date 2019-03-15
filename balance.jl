flowProfiles = Dict()
for each in readdir(loadpath)
    println("working on $each")
    # original file
    temp = CSV.read(joinpath(loadpath, each), type = [String, Int, Int])
    flowProfiles[each[1:4]] = temp
end
flowProfiles["ESMA"] = generationProfiles["Spain"] - loadProfiles["Spain"] - flowProfiles["ESFR"][:,3] - flowProfiles["ESPT"][:,3]

ESMA
FIRU
NORU//
EERU
LVRU
LTRU
LTBY
PLUA
SKUA
HUUA
ROUA
BGTR
GRTR
GRAL
RSAL
MEAL
SIHR
BAHR
RSHR
HUHR
