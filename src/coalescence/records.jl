# coalescence/records.jl
# ======================
#
# Types representing records of coalescence events and collections of them.
#
# This file is a part of BioJulia.
# License is MIT: https://github.com/BioJulia/Bio.jl/blob/master/LICENSE.md

# So the basic idea here is to have a type representing a coalescence record,
# and a type representing a collection of such coalescence records.

immutable CoalescenceRecord
    l::UInt          # Left boundary
    r::UInt          # Right boundary
    w::UInt          # Parent node
    u::UInt          # Child node 1
    v::UInt          # Child node 2
    t::Float64       # Coalescence time
end

# An alternative implementation is to use the intervals from Bio.Intervals or
# IntervalTrees.jl.
# and attach coalescent specific metadata.
# A coalescent record then could either be a typealias of IntervalValue with
# specific metadata, or it can be an entirely different type inheriting from
# AbstractInterval.

immutable CoalescenceRecordTable
    l::Vector{UInt}
    r::Vector{UInt}
    w::Vector{UInt}
    u::Vector{UInt}
    v::Vector{UInt}
    t::Vector{Float64}
end



# Just for conveinience typing/reading!
typealias CRecord CoalescenceRecord
typealias CTable CoalescenceRecordTable
