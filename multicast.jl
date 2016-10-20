# Adding 10 processes (workers)
rmprocs(procs())
addprocs(10)

@everywhere received = Any[]

@everywhere g = workers()

@everywhere function B_deliver(R_deliver, m)
    if(!(m in received))
        push!(received,m)
        sync_B_multicast(g,m,R_deliver)
        R_deliver(m)
    end
end

@everywhere function B_multicast(g,m,R_deliver)
    for p in g
        remotecall(B_deliver,p,R_deliver,m)
    end
end

function R_multicast(g,m,R_deliver)
    # starting multicast
    B_multicast(g,m,R_deliver)
end

# Multicasting "oi!" message to group `g`
times_r1 = Any[]
for i in 1:51
    tic()
    R_multicast(g, "oi!", println)
    push!(times_r1,toc())
    @everywhere empty!(received)
end

println(times_r1)
