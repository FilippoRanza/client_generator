using Plots

include("gen_clients.jl")
include("load_data.jl")
include("save_results.jl")


data = load_data("lausanne-bus-data.hdf5")

map_size = 150;
counts = get_data(data, "13", "sw-mon", "avg")
clients = generate_clients(counts, map_size, .1, .5, 2)
println(sum(clients), " ", length(clients[clients .> 0]))
close_data(data)
save_results("clients.hdf5", "line-13", clients)
contour(1:map_size, 1:map_size, clients)

