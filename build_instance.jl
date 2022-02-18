
function build_instance(M, d₁, d₂)
    output = init_output(M, d₁, d₂)
    for (i, (x, y, v)) in enumerate(make_index_iterator(M))
        output[i, 1:3] = [x y v] 
    end
    output
end

function init_output(M, d₁, d₂)
    non_zero = count(>(0), M)
    output = zeros(non_zero, 5)
    p₁ = rand(d₁, non_zero)
    p₂ = rand(d₂, non_zero)
    output[:, 4] = p₁'
    output[:, 5] = p₂'
    output
end


function make_index_iterator(M)
    x, y = size(M)
    ((i, j, M[i, j]) for i ∈ 1:x, j ∈ 1:y if M[i, j] > 0)
end



