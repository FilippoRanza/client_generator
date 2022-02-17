using HDF5

function save_results(file_name, key, data, overwrite=false)
    mode = overwrite ? "w" : "cw"
    h5open(file_name, mode) do file
        id = update_current_count(file, key)
        file["clients/$key/$id"] = data
    end
end


function update_current_count(file, key)
    key = "counters/$key"
    if haskey(file, key)
        tmp = read(file, key) + 1
        write(file[key], tmp)
        tmp
    else
        file[key] = 0
    end    
end
