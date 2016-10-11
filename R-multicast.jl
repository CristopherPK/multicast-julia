rmprocs(procs())
addprocs(10)

# Array keeping a message history.
@everywhere received = Any[]

# My group is composed by all workers
g = workers()

# Function for delivering message and assuring everyone in the group will receive.
function B_deliver(func, message)
    # Checking if the process received the actual message.
    if !(message in received)
        print("invalid message")
        throw(ArgumentError("invalid message"))
    else
        func(message)
    end
end

function sync_B_multicast(g,message,func)
    for p in g
        print(p)
        rr = RemoteChannel(p)
        wait(put!(rr,B_deliver(func,message)))
    end
end

function sync_R_multicast(g,m, R_deliver)
    #message = Dict("message" => m, "pid" => myid(), "flag" => true)
    push!(received,m)
    sync_B_multicast(g,m,R_deliver)
end

# Multicasting "oi!" message to group `g` by assuming `println` as B_deliver function.
sync_R_multicast(g,"oi!",println)
