using Plots

include("gen_clients.jl")


map_size = 150;
counts = [ 2022 886 137 265 1063 92 183 3230 5184]
clients = generate_clients(counts, map_size, .1, .5, 2)
println(sum(clients), " ", length(clients[clients .> 0]))
contour(1:map_size, 1:map_size, clients)
