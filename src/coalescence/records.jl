# coalescence/records.jl
# ======================
#
# Types representing records of coalescence events and collections of them.
#
# This file is a part of BioJulia.
# License is MIT: https://github.com/BioJulia/Bio.jl/blob/master/LICENSE.md


# Types
#------

# So the basic idea here is to have a type representing a coalescence record,
# and a type representing a collection of such coalescence records.

immutable CoalescenceRecord
    l          # Left boundary
    r          # Right boundary
    w          # Parent node
    u          # Child node 1
    v          # Child node 2
    t          # Coalescence time
end

# An alternative implementation is to use the intervals from Bio.Intervals or
# IntervalTrees.jl.
# and attach coalescent specific metadata.
# A coalescent record then could either be a typealias of IntervalValue with
# specific metadata, or it can be an entirely different type inheriting from
# AbstractInterval.

immutable CoalescenceRecordTable
    l::Vector
    r::Vector
    w::Vector
    u::Vector
    v::Vector
    t::Vector
end



# Just for conveinience typing/reading!
typealias CRec CoalescenceRecord
typealias CTable CoalescenceRecordTable
