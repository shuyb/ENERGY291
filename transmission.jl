function loadtransmission(filename, countrylist)
    temp = CSV.read(filename)
    transmission_matrix = Array{Int, 2}(undef, length(countrylist), length(countrylist))
    toremove = Array{Int,1}()
    for i = 1:size(temp, 2)
        if  !(string(names(temp)[i]) in countrylist)
            push!(toremove, i)
        end
    end

    deletecols!(temp, toremove)
    deleterows!(temp, toremove)

    for i = 1:length(countrylist)
        transmission_matrix[:,i] = temp[Symbol(countrylist[i])]
    end
    return transmission_matrix
end
