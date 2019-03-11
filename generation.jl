# load load profiles
function loadgeneration(loadpath, abbreviation)
    generationProfiles = Dict()
    for each in readdir(loadpath)
        println("working on $each")
        # original file
        temp = CSV.read(joinpath(loadpath, each), type = [String, String, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int])
        temp = temp[:,1:23]
        # deletecols!(temp, 24)
        for i = 3:23
            temp[:,i] = convert(Array{Int64,1}, temp[:,i])
        end
        # stores hourly actual generation
        temp2 = Array{Int, 2}(undef, 8760,21)
        # convert 15 min interval to hourly
        if temp[1,2][31:35] == "00:15"
            sum = zeros(21,1)
            for cat = 3:ncol(temp)
                for i = 1:size(temp)[1]
                    if i % 4 != 0
                        if isa(temp[i, cat], Int)
                            sum[cat - 2] += temp[i, cat]
                        else
                            # abnormal type detected, report type and treat it as zero
                            println(each, " ", i, " ", typeof(temp[i, cat]))
                        end
                    else
                        if isa(temp[i, cat], Int)
                            sum[cat - 2] += temp[i, cat]
                        else
                            # abnormal type detected, report type and treat it as zero
                            println(each, " ", i, " ", typeof(temp[i, cat]))
                        end
                        temp2[div(i,4), cat - 2] = div(sum[cat - 2], 4)
                        sum[cat - 2] = 0
                    end
                end
            end
        # convert 30 min interval to hourly
        elseif temp[1,2][31:35] == "00:30"
            sum = zeros(21,1)
            for cat = 3:ncol(temp)
                for i = 1:size(temp)[1]
                    if i % 2 != 0
                        if isa(temp[i, cat], Int)
                            sum[cat - 2] += temp[i, cat]
                        else
                            # abnormal type detected, report type and treat it as zero
                            println(each, " ", i, " ", typeof(temp[i, cat]))
                        end
                    else
                        if isa(temp[i, cat], Int)
                            sum[cat - 2] += temp[i, cat]
                        else
                            # abnormal type detected, report type and treat it as zero
                            println(each, " ", i, " ", typeof(temp[i, cat]))
                        end
                        temp2[div(i,2), cat - 2] = div(sum[cat - 2], 2)
                        sum[cat - 2] = 0
                    end
                end
            end
        # no need to convert
        else
            for cat = 3:ncol(temp)
                for i = 1:size(temp)[1]
                    if isa(temp[i, cat], Int)
                        temp2[i, cat - 2] = temp[i, cat]
                    else
                        # abnormal type detected, report type and treat it as zero
                        println(each, " ", i, " ", typeof(temp[i, cat]))
                        temp2[i, cat - 2] = 0
                    end
                end
            end
        end
        generationProfiles[abbreviation[each[1:2]]] = temp2[:,[1:9;12:21]]
    end
    return generationProfiles
end
