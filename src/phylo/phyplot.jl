function compose_segments(x1::Vector{Float64}, y1::Vector{Float64}, x2::Vector{Float64}, y2::Vector{Float64})
    [[(x1[i], y1[i]), (x2[i], y2[i])] for i in 1:length(x1)]
end

function phyplot(phy::Phylogeny; line_width = 0.2, font_size = 1, show_tips = 50)
    x, y, parx, descy, tip = findxy(phy)

    horizontal_lines = compose_segments(x, y, parx, y)
    vertical_lines = compose_segments(x, descy[:,1], x, descy[:,2])

    spec = [name(tip) for tip in termdec(phy)]
    spec = spec[length(spec):-1:1]

    specspace = maximum(y) > show_tips ? div(Int(maximum(y)), show_tips) : 1
    showspecs = specspace:specspace:Int(maximum(y))
    xtext = x[tip][showspecs] .* 1.03
    ytext = y[tip][showspecs]
    spec = spec[showspecs]

    compose(context(units = UnitBox(-0.02*maximum(x),-3.,maximum(x)*1.3, maximum(y)*1.1)), line(horizontal_lines), line(vertical_lines), text(xtext, ytext, spec), fontsize(font_size), stroke(colorant"black"), linewidth(line_width))

end

function compose_segments(x1::Float64, y1::Float64, x2::Float64, y2::Float64)
    [(x1[i], y1[i]), (x2[i], y2[i])]
end

function phyplot2(phy::Phylogeny; line_width = 0.2, font_size = 2, show_tips = 30)
    x, y = findxy2(phy)
    horizontal_lines = [compose_segments(x[node], y[node], x[parent(node)], y[node]) for node in keys(x)]
    vertical_lines = [compose_segments(x[node], y[children(node)[1]], x[node], y[children(node)[end]]) for node in keys(x)]

    specspace = maximum(y) > show_tips ? div(Int(maximum(y)), show_tips) : 1
    showspecs = termdec(phy)[specspace:specspace:Int(maximum(y))]

    spec = map(showspecs) do sp
        x[sp], y[sp], name(sp)
    end

    compose(context(units = UnitBox(-0.02*maximum(x),-3.,maximum(x)*1.3, maximum(y)*1.1)), line(horizontal_lines), line(vertical_lines), text(spec), fontsize(font_size), stroke(colorant"black"), linewidth(linewidth))
    x, y
end


function findxy2(phy::Phylogeny)
    height = [tip => i for (i, tip) in enumerate(termdec(phy))]

    function loc2(clade::PhyNode)
        if !in(clade, height)
            for subclade in children(clade)
                loc2(subclade)
            end
        end
        ch_heigths = [heights[child] for child in children(clade)]
        height[clade] = (maximum(ch_heigths) + minimum(ch_heights)) / 2.
    end

    loc2(phy.root)

    depth = Dict(phy.root => 0)
    for(clade in DepthFirst(phy))
        if !parentisself
            depth[clade] = depth[parent(clade)] + branchlength(clade)
        end
    end

    depth, height
end


function findxy(phy::Phylogeny)
    seen_tips = Vector{Int}(0)
    is_tip = Vector{Bool}(0)
    y_position = Vector{Float64}(0)
    x_position = Vector{Float64}(0)
    parent_xpos = Vector{Float64}(0)
    nodenum = (i = 0; for j in DepthFirst(phy) i += 1 end; i)
    desc_ypos = zeros(nodenum, 2) #replace magic number!

    function _loc(node::PhyNode, parentx::Float64)
        xpos =  parentx + branchlength(node, 0.)
        if isleaf(node)
            ypos = sum(seen_tips)
            push!(seen_tips, 1)
            desc_y = [0, 0]
        else
            ys = []
            for daughter in children(node)
                push!(ys, _loc(daughter, xpos))
            end
            desc_y = [ys[1]; ys[end]]
            ypos = mean(desc_y)
        end
        push!(x_position, xpos)
        push!(is_tip, isleaf(node))
        push!(y_position, ypos)
        push!(parent_xpos, parentx)
        desc_ypos[length(y_position), :] = desc_y
        ypos
    end

    _loc(phy.root, 0.)
    x_position, y_position, parent_xpos, desc_ypos, is_tip
end

function termdec(phy::Phylogeny)
    termdec(phy.root)
end

function termdec(node::PhyNode) #replacements for terminaldescendents which isn't working
    ret = Array{PhyNode, 1}(0)
    for i in DepthFirst(node)
        if isleaf(i)
            push!(ret, i)
        end
    end
    ret
end
