using JuMP, GLPK, LinearAlgebra

include("Task3_MP_remake.jl")

# dual variables from master problem:
# it 1:
# piVal = [12.0 7.0 12.0]
# kappa = [0.0 0.0 0.0]

#it 2
# piVal = [10.0 7.0 12.0]
# kappa = [2.0 0.0 0.0]
#it 3
# piVal = [11.0 7.0 11.0]
# kappa = [1.0 0.0 1.0]

for k = 1:K
    sub = Model(GLPK.Optimizer)

    @variable(sub, x[1:length(V[k])]>=0 )
    set_binary(x[4])
    set_binary(x[5])
    set_binary(x[6])
    @objective(sub, Min, dot(CV[k],x) -dot(piVal * A0_V[k], x)- kappa[k])
    @constraint(sub, dot(A_V[k][1,1:end],x) .== b_sub[k][1:1] )
    @constraint(sub, A_V[k][2:end,1:end]*x .<= 0 )

    optimize!(sub)

    if termination_status(sub) == MOI.OPTIMAL
        println("--- Result from sub-problem $k: ---")
        println("Objective value: ", JuMP.objective_value(sub))
        println("x: ", JuMP.value.(x))
    else
        println("Optimize was not succesful. Return code: ", termination_status(sub))
    end
end


