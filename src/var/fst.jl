

@inline function _withinpopcount(pop::Vector{Int}, counts::PairwiseListMatrix)
    popcount = 0
    N = length(pop)
    @inbounds for i in 1:N, j in (i + 1):N
        withincount += counts[pop[i], pop[j]]
    end
end

function fst{N}(pop1::Vector{Int}, pop2::Vector{Int}, seqs::Vararg{BioSequence,N})
    counts = count_pairwise(Mutated, seqs...)
    withincount = 0
    for pop in (pop1, pop2)


    end

end
