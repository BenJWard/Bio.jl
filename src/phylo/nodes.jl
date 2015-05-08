@Docile.doc """
PhyNode represents a node in a phylogenetic tree.

A node can have:

- `name`
- `branchlength`
- a reference to its `parent` PhyNode
- reference to one or more `children`

""" ->
type PhyNode
  name::String
  branchlength::Float64
  confidence::Float64
  children::Vector{PhyNode}
  parent::PhyNode

"""
Create a PhyNode.

PhyNodes represent nodes in a phylogenetic tree. All arguments are optional 
when creating PhyNodes:

**Example:**

    one = PhyNode()
    two = PhyNode(name = "two",
      branchlength = 1.0,
      parent = one)

**Parameters:**

* `name`:         The name of the node (optional). Defaults to an empty string, indicating
                  the node has no name.

* `branchlength`: The branch length of the node from its parent (optional).
                  Defaults to `-1.0`, indicating an unknown branch length.

* `ext`:          An array of zero or more PhyExtensions (optional). Defaults to an empty
                  array, i.e. `[]`, indicating there are no extensions.

* `parent`:       The parent node (optional). Defaults to a self-reference, indicating
                  the node has no parent.
"""
  function PhyNode(name::String = "", branchlength::Float64 = -1.0, confidence::Float64 = -1.0, children::Vector{PhyNode} = PhyNode[], parent = nothing)
    x = new()
    name!(x, name)
    branchlength!(x, branchlength)
    confidence!(x, confidence)
    if parent != nothing
      graft!(parent, x)
    else
      x.parent = x
    end
    x.children = PhyNode[]
    for child in children
      graft!(x, child)
    end
    return x
  end
end

function Base.show(io::IO, n::PhyNode)
  if isempty(n.children)
    print(io, n.name)
  else
    print(io, "(")
    print(io, join(map(string, n.children), ","))
    print(io, ")")
  end
end

@Docile.doc """
Test whether the branchlength in the node is known (i.e. is not -1.0).

**Parameters:**

* `x`:  The PhyNode to test.
""" ->
function blisknown(x::PhyNode)
  return !x.branchlength == -1.0
end

@Docile.doc """

    func_name(args...) -> (Bool,)

Test whether the confidence in the node is known (i.e. is not -1.0).

**Parameters:**

* `x`:  The PhyNode to test.
""" ->
function confisknown(x::PhyNode)
  return x.confidence != -1.0
end

@Docile.doc """

    func_name(args...) -> (Float64,)

Get the confidence of the node.

**Parameters:**

* `x`:  The PhyNode to return the confidence of.
""" ->
function confidence(x::PhyNode)
  return x.confidence
end

@Docile.doc """
Set the confidence of the node.

**Parameters:**

* `x`:    The PhyNode to set the confidence of.

* `conf`: The value of the confidence to be set.
""" ->
function confidence!(x::PhyNode, conf::Float64)
  x.confidence = conf
end

@Docile.doc """
Set the confidence of the node.

**Parameters:**

* `x`:    The PhyNode to set the confidence of.

* `conf`: The value of the confidence to be set.


""" ->
function confidence!(x::PhyNode, conf::Nothing)
  x.confidence = -1.0
end

@Docile.doc """
Test whether a node is empty.

**Parameters:**

* `x`: The PhyNode to test.
""" ->
function isempty(x::PhyNode)
  return x.name == "" && !blisknown(x) && !hasextensions(x) && !haschildren(x) && parentisself(x) && !confisknown(x)
end

@Docile.doc """
Get the name of a PhyNode.

**Parameters:**

* `x`: The PhyNode to get the name of.
""" ->
function name(x::PhyNode)
  return x.name
end

@Docile.doc """
Get the branch length of a PhyNode.

**Parameters:**

* `x`: The PhyNode to get the branch length of.
""" ->
function branchlength(x::PhyNode)
  return x.branchlength
end

@Docile.doc """
Test whether a node is a leaf.

**Parameters:**

* `x`: The PhyNode to test.
""" ->
function isleaf(x::PhyNode)
  return hasparent(x) && !haschildren(x)
end

@Docile.doc """
Test whether a node has children.

**Parameters:**

* `x`: The PhyNode to test.
""" ->
function haschildren(x::PhyNode)
  return length(x.children) > 0
end

@Docile.doc """
Test whether a node is the parent of another specific node.

**Parameters:**

* `parent`: The potential parent PhyNode to test.

* `child`:  The potential child PhyNode to test.
""" ->
function haschild(parent::PhyNode, child::PhyNode)
  return in(child, parent.children)
end

@Docile.doc """
Test whether a node is its own parent. See PhyNode().

**Parameters:**

* `x`: The PhyNode to test.
""" ->
function parentisself(x::PhyNode)
  return x.parent === x
end

@Docile.doc """
Test whether a node has a parent.

**Parameters:**

* `x`: The PhyNode to test.
""" ->
function hasparent(x::PhyNode)
  return !parentisself(x)
end

@Docile.doc """
Get the children of a node.

**Parameters:**

* `x`: The PhyNode to get children for.
""" ->
function children(x::PhyNode)
  return x.children
end

@Docile.doc """
Get the siblings of a node. Included in output is the input node.

**Parameters:**

* `x`: The PhyNode to get siblings for.
""" ->
function siblings(x::PhyNode)
  if hasparent(x)
    return children(x.parent)
  end
end

@Docile.doc """
Get the parent of a node.

**Parameters:**

* `x`: The PhyNode to get the parent of.
""" ->
function parent(x::PhyNode)
  if parentisself(x)
    println("Node does not have a parent. It is self referential.")
  end
  return x.parent
end

@Docile.doc """
Test whether a node is the root node.

**Parameters:**

* `x`: The PhyNode to test.
""" ->
function isroot(x::PhyNode)
  return parentisself(x) && haschildren(x)
end

@Docile.doc """
Test whether a node is unlinked, i.e. has no children and no parent.

**Parameters:**

* `x`: The PhyNode to test.
""" ->
function isunlinked(x::PhyNode)
  return parentisself(x) && !haschildren(x)
end

@Docile.doc """
Test whether a node is linked, i.e. has one or more children and/or a parent.
**Parameters:**

* `x`: The PhyNode to test.
""" ->
function islinked(x::PhyNode)
  return hasparent(x) || haschildren(x)
end

@Docile.doc """
Test whether a node is internal, i.e. has a parent and one or more children.

**Parameters:**

* `x`: The PhyNode to test.
""" ->
function isinternal(x::PhyNode)
  return hasparent(x) && haschildren(x)
end

@Docile.doc """
Test whether a node is preterminal i.e. It's children are all leaves.

**Parameters:**

* `x`: The PhyNode to test.
""" ->
function ispreterminal(x::PhyNode)
  if isleaf(x)
    return false
  end
  return all([isleaf(i) for i in x.children])
end

@Docile.doc """
Test whether a node is semi-preterminal i.e. Some of it's children are leaves, but not all are.

**Parameters:**

* `x`: The PhyNode to test.
""" ->
function issemipreterminal(x::PhyNode)
  areleaves = [isleaf(i) for i in x.children]
  return any(areleaves) && !all(areleaves)
end

@Docile.doc """
Count the number of children of a node.

**Parameters:**

* `x`: The PhyNode to count the children of.
""" ->
function countchildren(x::PhyNode)
  return length(x.children)
end

@Docile.doc """
Get the descendents of a node.

**Parameters:**

* `x`: The PhyNode to get the descendents of.

""" ->
function descendents(x::PhyNode)
  return collect(PhyNode, DepthFirst(x))
end

@Docile.doc """
Get the terminal descendents of a node. i.e. Nodes that are leaves, which have the input node as an ancestor.

**Parameters:**

* `x`: The PhyNode to get ther terminal descendents of.
""" ->
function terminaldescendents(x::PhyNode)
  return searchall(DepthFirst(x), isleaf)
end

@Docile.doc """
Test whether a node is ancesteral to one or more other nodes.

**Parameters:**

* `posanc`: The PhyNode to test.

* `nodes`: An array of `PhyNode`s that the test node must be ancestral to.
""" ->
function isancestral(posanc::PhyNode, nodes::Vector{PhyNode})
  desc = descendents(posanc)
  return all([in(node, desc) for node in nodes])
end

@Docile.doc """
Get the most recent common ancestor of an array of nodes.

**Parameters:**

* `nodes`:  An array of `PhyNode`s to find the most common ancestor of.
""" ->
function mrca(nodes::Vector{PhyNode})
  paths = [collect(Tip2Root(i)) for i in nodes]
  convergence = intersect(paths...)
  return convergence[1]
end

@Docile.doc """
Set the name of a PhyNode.

**Parameters:**

* `x`:    The PhyNode to set the name of.

* `name`: The name to give the PhyNode.
""" ->
function name!(x::PhyNode, name::String)
  x.name = name
end

@Docile.doc """
Set the branch length of a PhyNode.

**This method modifies the PhyNode.**

**Parameters:**

* `x`:  The PhyNode to set the branchlength of.

* `bl`: The branch length to give the PhyNode. Either a Float64 value or `nothing`.
""" ->
function branchlength!(x::PhyNode, bl::Float64)
  x.branchlength = bl
end

function branchlength!(x::PhyNode, bl::Nothing)
  x.branchlength = -1.0
end

@Docile.doc """
Remove the parent of a `PhyNode` (thus setting the parent property to be self-referential).

**Parameters:**

* `x`: The PhyNode to remove the parent of.
""" ->
function removeparent_unsafe!(x::PhyNode)
  parent_unsafe!(x, x)
end

@Docile.doc """
Set the parent of a node.

**Warning:** this method is considered unsafe because it does not build the two-way link between parent and child. If you want to add a child to a node, you should use `graft!()`, which does ensure the two-way link is built.

**Parameters:**

* `parent`:  The PhyNode to set as parent.

* `child`:   The PhyNode to set the parent of.
""" ->
function parent_unsafe!(parent::PhyNode, child::PhyNode)
  child.parent = parent
end

@Docile.doc """
Add a node to the `children` array of another node.

**Warning:** this method is considered unsafe because it does not build the two-way link between parent and child. If you want to add a child to a node, you should use `graft!()`, which does ensure the two-way link is built.

**Parameters:**

* `parent`: The PhyNode to add a child to.

* `child`:  The PhyNode to add as a child.

""" ->
function addchild_unsafe!(parent::PhyNode, child::PhyNode)
  if haschild(parent, child)
    error("The child node is already a child of the parent.")
  end
  push!(parent.children, child)
end

@Docile.doc """
Remove a node from the `children` array of another node.

**Warning:** this method is considered unsafe because it does not destroy any two-way link between parent and child. If you want to remove a child from a node, you should use `prune!()`, which does ensure the two-way link is destroyed.

**Parameters:**

* `parent`: 

* `child`:
""" ->
function removechild_unsafe!(parent::PhyNode, child::PhyNode)
  filter!(x -> !(x === child), parent.children)
end

@Docile.doc """
Graft a node onto another node, create a parent-child relationship between them.

**Parameters:**

* `parent`: The PhyNode to add a child to.

* `child`:  The PhyNode to add as a child.
""" ->
function graft!(parent::PhyNode, child::PhyNode)
  if hasparent(child)
    error("This node is already attached to a parent.")
  end
  parent_unsafe!(parent, child)
  addchild_unsafe!(parent, child)
end

@Docile.doc """
Graft a node onto another node, create a parent-child relationship between them, and associatiing a branch length with the relationship.

**Parameters:**

* `parent`:       The PhyNode to add a child to.

* `child`:        The PhyNode to add as a child.

* `branchlength`: The branch length between parent and child.

""" ->
function graft!(parent::PhyNode, child::PhyNode, branchlength::Float64)
    graft!(parent, child)
    branchlength!(child, branchlength)
end

@Docile.doc """
Graft one or more nodes onto another node, create a parent-child relationship between each of the grafted nodes and the node they are grafted onto.

**Parameters:**

* `parent`:   The PhyNode to add a child to.

* `children`: The array of PhyNodes to add as a child.
""" ->
function graft!(parent::PhyNode, children::Vector{PhyNode})
  for i in children
    graft!(parent, i)
  end
end

@Docile.doc """
Destroy the relationship between a PhyNode `x` and its parent, returning the PhyNode.

This method cleanly removes the PhyNode `x` from its parent's `children` array, and removes the `parent` reference from the PhyNode `x`. All other fields of the `child` are left intact.

**Parameters:**

* `x`: The PhyNode prune from its parent.
""" ->
function prune!(x::PhyNode)
  if hasparent(x)
    removechild_unsafe!(x.parent, x)
    removeparent_unsafe!(x)
    return x
  else
    error("Can't prune from this node, it is either a single node without parents or children, or is a root of a tree / subtree.")
  end
end

@Docile.doc """
Prune a PhyNode from its parent and graft it to another parent.

**Parameters:**

* `prune`:    The PhyNode to remove from its parent.

* `graftto`:  The PhyNode to become the new parent of `prune`.
""" ->
function pruneregraft!(prune::PhyNode, graftto::PhyNode)
  x = prune!(prune)
  graft!(graftto, x)
end

@Docile.doc """
Prune a PhyNode from its parent and graft it to another parent, setting the branch length.

**Parameters:**

* `prune`:        The PhyNode to remove from its parent.

* `graftto`:      The PhyNode to become the new parent of `prune`.

* `branchlength`: The branch length.
""" ->
function pruneregraft!(prune::PhyNode, graftto::PhyNode, branchlength::Float64)
  x = prune!(prune)
  graft!(graftto, x, branchlength)
end

@Docile.doc """
Delete a node, destroying the relationships between it and its parent, and it and its children. The children of the node become the children of the node's former parent.

Returns the deleted node.

**Parameter:**

* `x`: The PhyNode to delete.
""" ->
function delete!(x::PhyNode)
  deleted = prune!(x)
  graft!(parent(deleted), children(deleted))
  return deleted
end

@Docile.doc """
Detach a subtree at a given node.

Returns a new Phylogeny with the detached node as root.

**Parameters:**

* `x`:          The PhyNode to detach.

* `name`:       The name of the new Phylogeny.

* `rooted`:     Whether the detached subtree is rooted.

* `rerootable`: Whether the detached subtree is rerootable.
""" ->
function detach!(x::PhyNode, name::String = "", rooted::Bool = true, rerootable::Bool = true)
  detached = prune!(x)
  return Phylogeny(name, detached, rooted, rerootable)
end

@Docile.doc """
Test whether two PhyNodes are equal. Specifically, test whether all three of `branchlength`, `name` and `extensions` are equal.

**Parameters:**

* `x`: The left PhyNode to compare.

* `y`: The right PhyNode to compare.
""" ->
function isequal(x::PhyNode, y::PhyNode)
  bl = x.branchlength == y.branchlength
  n = x.name == y.name
  return all([bl, n])
end

@Docile.doc """
Find the distance of a node from its parent. This is different from branch length, because it handles the situation where branch length is unknown. It is only used when the distances between nodes are calculated.

The method is necessary because unknown branch lengths are represented as -1.0.
If all branch lengths are unknown, the tree is a cladogram, and it is still useful to be able to compare relative distances. If individual branch lengths are unknown, they should not affect the calculation of path distances. To satisfy both of these cases, we use machine epsilon as the minimal distance.

**Parameters:**

* `x`: A PhyNode.

""" ->
function distanceof(x::PhyNode)
  bl = branchlength(x)
  return bl == -1.0 ? eps() : bl
end


