
function trees(input_file)

    fid = h5open(input_file, "r")
    records = fid["trees/records"]
    left = read(records["left"])
    right = read(records["right"])
    node = read(records["node"])
    children = read(records["children"])
    num_children = read(records["num_children"])

    indexes = fid["trees/indexes"]
    I = read(indexes["insertion_order"]) + 1
    O = read(indexes["removal_order"]) + 1

    max_nodes = maximum(node)
    M = size(left)[1]
    # Assume we have a binary tree sequence to make our lives a bit easier
    # In general we'll have to take this flat array and make it into a ragged
    # 2D one.
    assert(num_children == (2 * ones(M)))
    parents = Dict{UInt32, UInt32}()

    j = 1
    k = 1
    while j <= M
        x = left[I[j]]
        while right[O[k]] == x
            h = O[k]
            delete!(parents, children[2 * h - 1])
            delete!(parents, children[2 * h])
            k += 1
        end
        while j <= M && left[I[j]] == x
            h = I[j]
            parents[children[2 * h - 1]] = node[h]
            parents[children[2 * h]] = node[h]
            j += 1
        end
        produce(parents)
    end
end


input_file = ARGS[1]

num_trees = 0
for tree in @task trees(input_file)
    #= println(tree) =#
    num_trees += 1
end
println("num_trees = ", num_trees)
