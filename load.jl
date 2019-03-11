# load load profiles
function loadload(loadpath, abbreviation)
    loadProfiles = Dict()
    for each in readdir(loadpath)
        # original file
        temp = CSV.read(joinpath(loadpath, each), type = [String, String, Int])
        temp[:,3] = convert(Array{Int64,1}, temp[:,3])
        # stores hourly actual load
        temp2 = Array{Int,1}()
        # convert 15 min interval to hourly
        if temp[1,1][31:35] == "00:15"
            summ = 0
            for i = 1:size(temp)[1]
                if i % 4 != 0
                    if isa(temp[i, 3], Int)
                        summ += temp[i, 3]
                    else
                        # abnormal type detected, report type and treat it as zero
                        println(each, " ", i, " ", typeof(temp[i, 3]))
                    end
                else
                    if isa(temp[i, 3], Int)
                        summ += temp[i, 3]
                    else
                        # abnormal type detected, report type and treat it as zero
                        println(each, " ", i, " ", typeof(temp[i, 3]))
                    end
                    push!(temp2, div(summ, 4))
                    summ = 0
                end
            end
        # convert 30 min interval to hourly
        elseif temp[1,1][31:35] == "00:30"
            summ = 0
            for i = 1:size(temp)[1]
                if i % 2 != 0
                    if isa(temp[i, 3], Int)
                        summ += temp[i, 3]
                    else
                        # abnormal type detected, report type and treat it as zero
                        println(each, " ", i, " ", typeof(temp[i, 3]))
                    end
                else
                    if isa(temp[i, 3], Int)
                        summ += temp[i, 3]
                    else
                        # abnormal type detected, report type and treat it as zero
                        println(each, " ", i, " ", typeof(temp[i, 3]))
                    end
                    push!(temp2, div(summ, 2))
                    summ = 0
                end
            end
        # no need to convert
        else
            for i = 1:size(temp)[1]
                if isa(temp[i, 3], Int)
                    push!(temp2, temp[i, 3])
                else
                    # abnormal type detected, report type and treat it as zero
                    println(each, " ", i, " ", typeof(temp[i, 3]))
                    push!(temp2, 0)
                end
            end
        end
        loadProfiles[abbreviation[each[1:2]]] = temp2
    end
    return loadProfiles
end
