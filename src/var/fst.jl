

@inline function _withinpopcount(pop::Vector{Int}, counts::PairwiseListMatrix)
    c = 0
    N = length(pop)
    @inbounds for i in 1:N, j in (i + 1):N
        c += counts[pop[i], pop[j]][1]
    end
    return c
end

"""

Compute fst for a set of biological sequences.

`popa` and `popb` are two integer vectors which indicate which of the
sequences are sampled from population A and which of the sequences are
sampled from population B respectively.
"""
function fst{N}(popa::Vector{Int}, popb::Vector{Int}, seqs::Vararg{BioSequence,N})
    # Count mutations between all pairs of sequences, pairwise.
    nmutations = count_pairwise(Mutated, seqs...)

    # Sum the number of pairwise mutations from all the same-population
    # sequence pairs.
    wthncnt = 0
    for pop in (popa, popb)
        wthncnt += _withinpopcount(pop, nmutations)
    end

    # Sum the number of pairwise mutations from all the between-population
    # sequence pairs.
    btwncnt = 0
    @inbounds for i in popa, j in popb
        btwncnt += nmutations[i, j][1]
    end

    # Compute the between population and within population averages.
    la = length(popa)
    lb = length(popb)
    pibtwn = btwncnt / (la * lb)
    piwthn = wthncnt / (Seq.npairs(la) + Seq.npairs(lb))

    # Plug the averages into the Fst formula.
    return (pibtwn - piwthn) / pibtwn
end
