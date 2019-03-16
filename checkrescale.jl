function check_rescale(generationProfiles,backup_generation,source_index,country,source)
    original = backup_generation
    index = source_index[source]
    plot(generationProfiles[country][:,index],label = "NEW")
    plot!(original[country][:,index],label="OLD")
    title!(source)
end
