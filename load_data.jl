using HDF5

#=

=#

function to_dict(hd5, key)
    list = read(hd5, key)
    Dict(d => i for (i, d) in enumerate(list))
end



struct Data
    file
    day_key
    stat_key
end

function load_data(file_name)
    file = h5open(file_name)
    day_keys = to_dict(file, "day-order")
    stat_keys = to_dict(file, "stat-order")
    Data(file, day_keys, stat_keys)
end

function get_data(data::Data, line, day, stat)
    d_i = data.day_key[day]
    s_i = data.stat_key[stat]
    mat = read(data.file, "traffic/$line")
    mat[:, d_i, s_i]
end

function close_data(data::Data)
    close(data.file)
end


