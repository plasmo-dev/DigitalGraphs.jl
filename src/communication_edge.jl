##########################
# Communication Edges
#########################
mutable struct CommunicationEdge <: AbstractCommunicationEdge
    #baseedge::BasePlasmoEdge

    multiedge::MultiEdge

    state_manager::StateManager
    from_attribute::Union{Nothing,NodeAttribute}
    to_attribute::Union{Nothing,NodeAttribute}
    attribute_pipeline::Vector{EdgeAttribute}
    send_triggers::Vector{Signal}
    delay::Float64                       #communication delay
    history::Vector{Tuple}
    local_time::Float64

    function CommunicationEdge(multiedge::MultiEdge)
        edge = new()

        edge.multiedge = multiedge

        edge.state_manager = StateManager()
        edge.from_attribute = nothing
        edge.to_attribute = nothing
        edge.attribute_pipeline = Vector{EdgeAttribute}()
        edge.send_triggers = Vector{Signal}()
        edge.delay = 0.0
        edge.local_time = 0.0
        edge.history = Vector{Tuple}()
        addstates!(edge,[state_idle(),state_communicating(),state_inactive(),state_all_received()])
        setstate(edge,state_idle())
        return edge
    end
end

#PlasmoGraphBase.create_edge(graph::ComputingGraph) = CommunicationEdge()   #PlasmoGraphBase edge construction

getstring(edge::AbstractCommunicationEdge) = "Edge "*string(collect(values(edge.baseedge.indices))[1].src)*" -> "*string(collect(values(edge.baseedge.indices))[1].dst)
getdelay(edge::AbstractCommunicationEdge) = edge.delay
getlocaltime(edge::AbstractCommunicationEdge) = edge.local_time
getstate(edge::AbstractCommunicationEdge) = getstate(edge.state_manager)
iscommunicating(edge::CommunicationEdge) = getstate(edge) == state_communicating()
getvalidsignals(edge::CommunicationEdge) = getvalidsignals(edge.state_manager)
getstatemanager(edge::AbstractCommunicationEdge) = edge.state_manager

getvalidstates(edge::AbstractCommunicationEdge) = getvalidstates(edge.state_manager)
gettransitions(edge::AbstractCommunicationEdge) = gettransitions(edge.state_manager)
#getcurrentstate(edge::AbstractCommunicationEdge) = getcurrentstate(edge.state_manager)

setdelay(edge::AbstractCommunicationEdge,delay::Float64) = edge.delay = delay


function add_edge!(graph::AbstractComputingGraph,attribute1::NodeAttribute,attribute2::NodeAttribute; delay::Number = 0.0,send_on::Union{Signal,Vector{Signal}} = Signal[],send_delay::Number = 0.0)

    if !isa(send_on,Vector)
        send_on = [send_on]
    end

    delay = Float64(delay)
    send_delay = Float64(send_delay)

    #Update the topology
    n1 = getnode(attribute1)
    n2 = getnode(attribute2)
    medge = add_edge!(graph.multigraph,n1.index,n2.index)
    comm_edge = CommunicationEdge(medge)
    graph.comm_edges[medge] = comm_edge

    #edge = add_edge!(graph,getnode(attribute1),getnode(attribute2))

    comm_edge.from_attribute = attribute1
    comm_edge.to_attribute = attribute2
    comm_edge.send_triggers = send_on
    comm_edge.delay = delay

    push!(attribute1.out_edges,comm_edge)
    push!(attribute2.in_edges,comm_edge)

    #TODO Correctly?
    #error
    addtransition!(comm_edge,state_any(),signal_error(),state_error())   #action --> cancel signals

    #inactive
    addtransition!(comm_edge,state_idle(),signal_inactive(),state_inactive())  #action --> cancel signals
    addtransition!(comm_edge,state_communicating(),signal_inactive(),state_inactive())
    addtransition!(comm_edge,state_all_received(),signal_inactive(),state_inactive())
    #####################################################

    #Notify attribute that it triggers this comm_edge
    for signal in comm_edge.send_triggers
        label = signal.label
        value = signal.value
        if isa(value,NodeAttribute)
            attribute = value
            push!(attribute.signal_triggers[label],comm_edge)
        end
    end

    #communication actions
    addtransition!(comm_edge,state_idle(), signal_communicate(), state_communicating(),action = action_communicate(graph,comm_edge))
    addtransition!(comm_edge,state_communicating(),signal_communicate(),state_communicating(),action = action_communicate(graph,comm_edge))
    addtransition!(comm_edge,state_communicating(),signal_all_received(),state_idle())

    #TODO Think of adding simpler self-transitions. addselftransition!
    #signal_receive(attribute)?
    addtransition!(comm_edge,state_any(),signal_receive(),nothing,action = action_receive_attribute(graph,comm_edge))

    #NOTE: Need to add schedule_communicate signal
    # addtransition!(comm_edge,state_idle(),signal_schedule_communicate(),state_communicating(),action = action_schedule_communicate(send_delay))
    # addtransition!(comm_edge,state_communicating(),signal,state_communicating(),action = action_schedule_communicate(send_delay))

    #schedule communication actions
    for signal in comm_edge.send_triggers
        addtransition!(comm_edge,state_idle(),signal,state_communicating(),action = action_schedule_communicate(graph,comm_edge,send_delay))
        addtransition!(comm_edge,state_communicating(),signal,state_communicating(),action = action_schedule_communicate(graph,comm_edge,send_delay))
    end

    return comm_edge
end

const connect! = add_edge!

function addcomputeattribute!(graph::AbstractComputingGraph,edge::CommunicationEdge,value::Any)
    attribute = EdgeAttribute(edge,value)
    push!(edge.attribute_pipeline,attribute)
    #addtransition!(edge,state_idle(),signal_receive(attribute),state_communicating(),action = action_receive_attribute(graph,edge,attribute))
    #addtransition!(edge,state_communicating(),signal_receive(attribute),state_communicating(),action = action_receive_attribute(graph,edge,attribute))
    return attribute
end

function removecomputeattribute!(edge::CommunicationEdge,attribute::EdgeAttribute)
    filter!(x->x != attribute,edge.attribute_pipeline)
end
