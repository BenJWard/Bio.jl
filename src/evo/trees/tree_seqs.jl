# coalescence/tree_seqs.jl
# ========================
#
# Types representing records of coalescence events and collections of them.
#
# This file is a part of BioJulia.
# License is MIT: https://github.com/BioJulia/Bio.jl/blob/master/LICENSE.md

immutable TreeSequence
    records::CTable
    I::Vector{UInt}
    O::Vector{UInt}
end
