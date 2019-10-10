#####################################################
# Computing Graph
#####################################################
mutable struct ComputingGraph <: AbstractComputingGraph
    multigraph::MultiGraph
    compute_nodes::Dict{Int64,AbstractComputeNode}
    comm_edges::Dict{MultiEdge,AbstractCommunicationEdge}
    signalqueue::SignalQueue
    history_on::Bool
end
function ComputingGraph()
    #signal_priority_order =[signal_finalize(),signal_back_to_idle(),signal_receive(),signal_updated(),signal_sent(),signal_received(),signal_communicate(),signal_execute()]

    multigraph = MultiGraph()
    compute_nodes = Dict{Int64,AbstractComputeNode}()
    comm_edges = Dict{MultiEdge,AbstractCommunicationEdge}()
    signal_priority_order =[signal_finalize(),signal_updated(),signal_back_to_idle(),signal_sent(),signal_received(),signal_communicate(),signal_receive(),signal_execute()]
    signalqueue = SignalQueue()
    signalqueue.signal_priority_order = signal_priority_order
    return ComputingGraph(multigraph,compute_nodes,comm_edges,signalqueue,true)
end


#####################################################
# Compute Nodes
#####################################################


#####################################################
# Communication Edges
#####################################################
# function getlinkedge(graph::ModelGraph,hyperedge::HyperEdge)
#     # d = merge(graph.linkedges,graph.sublinkedges)
#     # return d[hyperedge]
#     return graph.linkedges[hyperedge]
# end
#
# function getlinkedge(graph::ModelGraph,index::Int64)
#     hyperedge = gethyperedge(gethypergraph(graph),index)
#     return getlinkedge(graph,hyperedge)
# end
#
# function getlinkedge(graph::ModelGraph,vertices::Int...)
#     hyperedge = gethyperedge(graph.hypergraph,vertices...)
#     return getlinkedge(graph,hyperedge)
# end

#####################################################
# Signal Queue
#####################################################

getsignalqueue(graph::AbstractComputingGraph) = graph.signalqueue
getqueue(graph::AbstractComputingGraph) = getqueue(graph.signalqueue)
stop_graph() = stop_queue()
getcurrenttime(graph::AbstractComputingGraph) = getcurrenttime(graph.signalqueue)
now(graph::AbstractComputingGraph) = now(graph.signalqueue)

function getnexttime(graph::ComputingGraph)
    queue = getqueue(graph)
    times = unique(sort([val.time for val in values(queue)]))
    # if length(times) == 1
    #     next_time = times[1]
    # else
    #     next_time = times[2]    #this will be the next time currently in the queue
    # end
    next_time = times[1]
    return next_time
end

function getnextsignaltime(graph::ComputingGraph)
    queue = getqueue(graph)
    times = unique(sort([val.time for val in values(queue)]))
    next_time = times[1]
    return next_time
end

call!(graph::ComputingGraph,signal_event::SignalEvent) = call!(graph.signal_queue,signal_event)

#Queue Signal methods for computing graph
queuesignal!(graph::ComputingGraph,signal::AbstractSignal,target::SignalTarget,time::Number;source = nothing) =
                    queuesignal!(getsignalqueue(graph),signal,target,time,source = source,priority = getlocaltime(target))

#getstring(node::ComputeNode) = "Compute Node: $node.index"
function string(graph::ComputingGraph)
    """
    Computing Graph
    Compute Nodes: $(length(graph.compute_nodes))
    Communication Edges: $(length(graph.comm_edges))
    """
end
print(io::IO, graph::ComputingGraph) = print(io, string(graph))
show(io::IO,graph::ComputingGraph) = print(io,graph)




#queuesignal!(graph::ComputingGraph,signal::Signal,source::ComputeNode,target::ComputeNode,time::Number) = queuesignal!(getsignalqueue(graph),signal,source,target,time,priority = getlocaltime(target))
