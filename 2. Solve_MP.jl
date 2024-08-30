using JuMP, GLPK, LinearAlgebra

include("Task1_Remake.jl")

# X[k] Extreme points for polyhedron k
X = Vector{Array{Int64,2}}(undef,K)

# # Initial extreme point
# X[1] = [1 0 0 1 0 0]' # send from A to D
# X[2] = [0 2 0 0 1 0]' # send from B to E
# X[3] = [0 0 1 0 0 1]' # send from C to F

# # P[k] number of extreme points for polyhedron k
# P = [1,1,1]

# Extreme point after first call to the sub
# X[1] = [1 0 0 1 0 0]'  
# X[2] = [0 2 0 0 1 0; 1 0 1 1 0 1]'  
# X[3] = [0 0 1 0 0 1]'

# # P[k] number of extreme points for polyhedron k
# P = [1, 2, 1]

# Extreme point after second call to the sub
X[1] = [1 0 0 1 0 0; 0 0 1 0 0 1]'  
X[2] = [0 2 0 0 1 0; 1 0 1 1 0 1]'  
X[3] = [0 0 1 0 0 1]'

# P[k] number of extreme points for polyhedron k
P = [2, 2, 1]

# after iter3
# --- Result from sub-problem 1: ---
# Objective value: 0.0
# x: [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]
# --- Result from sub-problem 2: ---
# Objective value: 0.0
# x: [1.0, 0.0, 1.0, 1.0, 0.0, 1.0]
# --- Result from sub-problem 3: ---
# Objective value: 0.0
# x: [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]



master = Model(GLPK.Optimizer)

# Create a vector that contain vectors of decision variables
@variable(master, lambda1[1:P[1]] >= 0 )
@variable(master, lambda2[1:P[2]] >= 0 )
@variable(master, lambda3[1:P[3]] >= 0 )
lambda = [lambda1, lambda2, lambda3]

@objective(master, Min, sum(dot(CV[k]* X[k], lambda[k]) for k=1:K))

@constraint(master, cons, sum(A0_V[k]*X[k]*lambda[k] for k=1:K ) .== b0 )
@constraint(master, convexityCons[k=1:K], sum(lambda[k][j] for j=1:P[k]) == 1)

optimize!(master)

if termination_status(master) == MOI.OPTIMAL
    println("Objective value: ", JuMP.objective_value(master))
    lambdaVal = [JuMP.value.(lambda[k]) for k=1:K]
    println("lambda: ", lambdaVal)
    # REMOVE - from constraint, its a minimization
    println("piVal = ", dual.(cons))
    println("kappa = ", dual.(convexityCons))
else
    println("Optimize was not succesful. Return code: ", termination_status(master))
end


