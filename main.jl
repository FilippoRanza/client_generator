using Plots
using YAML
using Configurations

include("gen_clients.jl")
include("load_data.jl")
include("save_results.jl")
include("build_instance.jl")

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
    csr_mean::Float64
    csr_var::Float64
    client_mean::Float64
    client_var::Float64
end

function get_log_normal_params(μ, σ)
    x = log(μ^2 / √(μ^2 + σ^2))
    y = log(1 + σ^2 / μ^2)
    x, y
end

function log_normal_factory(μ, σ)
    x, y = get_log_normal_params(μ, σ)
    LogNormal(x, y)
end

function factory_distributions(config::Config)
    d₁ = log_normal_factory(config.csr_mean, config.csr_var)
    d₂ = log_normal_factory(config.client_mean, config.client_var)
    d₁, d₂
end

function main(config::Config) 
    
    data = load_data(config.data_file)

    counts = get_data(
        data, config.line_id, config.day_id, config.stat_id)
    clients = generate_clients(
        counts, config.map_size, config.min_var,
        config.max_var, config.scale)

    close_data(data)

    d₁, d₂ = factory_distributions(config)
    instance = build_instance(clients, d₁, d₂)
    save_results(config.result_file, config.result_key, instance)
    if config.plot
        x, y = size(clients)
        contour(1:x, 1:y, clients)
    end
end

conf_dict = YAML.load_file("config.yml"; dicttype=Dict{String, Any})
config = from_dict(Config, conf_dict)
main(config)
