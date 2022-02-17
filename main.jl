using Plots
using YAML
using Configurations

include("gen_clients.jl")
include("load_data.jl")
include("save_results.jl")

@option struct Config 
    map_size::Int64
    line_id::String
    day_id::String
    stat_id::String
    min_var::Float64
    max_var::Float64
    scale::Int64
    data_file::String
    result_file::String
    result_key::String
    plot::Bool
end

function main(config::Config) 
    
    data = load_data(config.data_file)

    counts = get_data(
        data, config.line_id, config.day_id, config.stat_id)
    clients = generate_clients(
        counts, config.map_size, config.min_var,
        config.max_var, config.scale)

    close_data(data)

    save_results(config.result_file, config.result_key, clients)
    if config.plot
        contour(1:config.map_size, 1:config.map_size, clients)
    end
end

conf_dict = YAML.load_file("config.yml"; dicttype=Dict{String, Any})
config = from_dict(Config, conf_dict)
main(config)
