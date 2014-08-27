module Phylo

using Base.Intrinsics

import Base: getindex, length, start, next, done, isempty

import DataStructures: Queue, enqueue!, dequeue!, Stack, Queue, Deque
## Exported Methods and Types
export PhyNode, getname, getbranchlength, isleaf, haschildren, 
parentisself, hasparent, getchildren, getsiblings, getparent, 
isroot, isnode, setname!, setbranchlength!, ispreterminal, issemipreterminal,
getdescendents, getterminaldescendents, countchildren, isintree, PhyExtension,  Phylogeny, 
isrooted, isrerootable, root!, setrerootable!,
graft!, prune!, pruneregraft!, search, searchall, generateindex, PhylogenyIterator, 
DepthFirst, BreadthFirst, Tip2Root, getmrca, hasextensions, getroot, pathbetween 

## Load Package Files
include("typedefs.jl")
include("iteration.jl")
end
