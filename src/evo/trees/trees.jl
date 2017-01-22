# evo/trees/trees.jl
# ==================
#
# Types and methods for representing evolutionary trees.
#
# Part of the Bio.Evo module.
#
# This file is a part of BioJulia.
# License is MIT: https://github.com/BioJulia/Bio.jl/blob/master/LICENSE.md

abstract AbstractTree

immutable SparseTree
    data::Vector{UInt}
end
