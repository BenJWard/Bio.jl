# The Bio.Evo module
# ====================
#
# A super module for types and algorithms for Evolutionary/Population genetics
# and phylogenetics.
#
# Part of the Bio.Phylo module.
#
# This file is a part of BioJulia. License is MIT: https://github.com/BioJulia/Bio.jl/blob/master/LICENSE.md

module Evo

using HDF5

export CoalescenceRecord,
    CRecord,
    CoalescenceRecordTable,
    CTable,
    TreeSequence

include("coalescence/records.jl")

include("trees/trees.jl")
include("trees/tree_seqs.jl")

end
