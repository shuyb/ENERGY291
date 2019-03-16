function sourceindex()
    generation_mix = ["Biomass", "Brown coal", "Coal derived gas", "Gas", "Hard coal", "Oil", "Oil shale", "Peat", "Geothermal", "Hydro", "Hydro river", "Hydro reservoir", "Marine", "Nuclear", "Other", "Other renewable", "Solar", "Waste", "Wind onshore", "Wind offshore"]
    source_index = Dict()
    i = 1
    for each in generation_mix
        source_index[each] = i
        i += 1
    end
    return source_index
end
