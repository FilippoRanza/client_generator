using Plots
using Distributions


function rand_hermitian(x_range, y_range, scale)
    a = rand(x_range)
    b = rand(y_range)
    m = min(a, b)
    diag_range = -m:scale:m
    c = rand(diag_range)
    [a c; c b]
end

function collapse(p, scale)
    p = round(p)
    i = convert(Int, p)
    i - i % scale
end


function generate_clients(counts, map_size, min_var=1, max_var=2, scale=10)
    x = 1:map_size;
    y = 1:map_size;
    
    var_inter = (x) -> min_var*x:.1:max_var*x;

    clients = zeros(map_size, map_size)
    centers = rand(1:map_size, (length(counts), 2)) 

    for (c, μ) in zip(counts, eachrow(centers))
        Σ = rand_hermitian(var_inter(c), var_inter(c),0.1)
        a = MvNormal(μ, Σ)
        points = collapse.(rand(a, c), scale)
        for (p1, p2) in eachcol(points)
            if p1 ∈ x && p2 ∈ y
                clients[p1, p2] += 1
            end
        end

    end
    
    clients
end


map_size = 150;
counts = [ 2022 886 137 265 1063 92 183 3230 5184]
clients = generate_clients(counts, map_size, .01, .1, 1)
println(sum(clients), " ", length(clients[clients .> 0]))
contour(1:map_size, 1:map_size, clients)
