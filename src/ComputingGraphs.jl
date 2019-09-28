module ComputingGraphs

# using StructureGraphs
# import StructureGraphs:create_node,create_edge,add_edge!,addattributes!
import LightGraphs
import DataStructures
import Base:isless,step,==,show,print,string,getindex

export AbstractSignal,SerialExecutor,

#State Manager objects
StateManager,SignalQueue,State,Signal,Transition,TransitionAction,

addstate!,addsignal!,addtransition!,setstate,setaction,

getvalidsignals,getstates,getstate,getcurrentstate,gettransitions,gettransition,getaction,

step,debug_step,advance,execute!,queuesignal!,


#Computing Graph Objects
ComputingGraph, ComputeNode, CommunicationEdge,NodeAttribute,

#Computing Graph functions
getqueue,stop_graph,

#NodeTask
addnodetask!,getnodetask,getnodetasks,setcomputetime,getnoderesult,

#Compute Attributes
addcomputeattribute!,getcomputeattribute,getcomputeattributes,getlocalvalue,getglobalvalue,getvalue,setvalue,

#Compute Nodes
add_node!,addtasktrigger!,setattribute,addattributes!,

#Communication Edges
addedge!,setdelay,getdelay,iscommunicating,connect!,

#  Time access
now,getcurrenttime,getnexttime,getnextsignaltime,getlocaltime,

# Exported signal shortcuts
signal_error,signal_inactive,signal_schedule,signal_execute,signal_finalize,signal_back_to_idle,
signal_communicate,signal_all_received,signal_updated,signal_received,signal_sent,signal_receive,

state_idle,state_any,state_inactive

abstract type AbstractComputingGraph end #<: AbstractPlasmoGraph end
abstract type AbstractComputeNode end #<: AbstractPlasmoNode end
abstract type AbstractCommunicationEdge  end # <: AbstractPlasmoEdge end

abstract type AbstractAttribute end
abstract type AbstractSignalEvent end
abstract type AbstractSignal end
abstract type AbstractStateManager end
abstract type AbstractSignalQueue end

const SignalTarget = Union{AbstractStateManager,AbstractComputeNode,AbstractCommunicationEdge}   #A node can be a target

#State Manager Backend
include("state_manager/states_signals.jl")
include("state_manager/signal_event.jl")
include("state_manager/state_manager.jl")
include("state_manager/signal_queue.jl")
include("state_manager/signal_executor.jl")
include("state_manager/print.jl")

#Computing Graph Interface

include("multigraph/multigraph.jl")

#Node Tasks
include("node_tasks.jl")

#Compute Attributes
include("attributes.jl")

#Signal shortcuts
include("implemented_states_signals.jl")

#Transition Actions
include("actions.jl")

#The Computing Graph
include("computing_graph.jl")

#Communication Edges
include("communication_edge.jl")

#Compute Nodes
include("compute_node.jl")

#Execution
include("graph_executor.jl")

end # module
