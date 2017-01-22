# Bio.Coalescence
# ===============
#
# Module for coalescence.
#
# This file is a part of BioJulia.
# License is MIT: https://github.com/BioJulia/Bio.jl/blob/master/LICENSE.md

module Coalescence

using HDF5

export CoalescenceRecord,
    CRecord,
    CoalescenceRecordTable,
    CTable,
    TreeSequence

include("records.jl")
include("tree_seqs.jl")
include("algorithm_t.jl")


end
