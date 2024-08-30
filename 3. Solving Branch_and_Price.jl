include("ColGenGeneric.jl")
using Gurobi, JuMP
using .DW_ColGen

function FCTP_MIP(c,f,mij,supply,demand)
    # 5x5 set of variables
    (m,n) = size(mij)

    myModel = Model(Gurobi.Optimizer)  # Change to Gurobi.Optimizer if you are actually using Gurobi
    @variable(myModel, 0 <= x[i=1:m,j=1:n] <= mij[i,j], Int)
    @variable(myModel, y[1:m,1:n], Bin)

    @objective(myModel, Min, sum(c[i,j]*x[i,j] + f[i,j]*y[i,j] for i=1:m for j=1:n))

    # Demand constraints
    @constraint(myModel, [j=1:n], sum(x[i,j] for i=1:m) == demand[j])

    # Supply constraints
    @constraint(myModel, SupplyCons[i=1:m], sum(x[i,j] for j=1:n) == supply[i])
    # Route constraints
    @constraint(myModel, routeCons[i=1:m, j=1:n], x[i,j] <= mij[i,j]*y[i,j])
    
    # Strategy - branch of least fractional variable --> no branch on the biggest values, using DFS    
    # Depth First Search strategy: select among the active nodes one of those that are the deepest down in the tree. 
    # @constraint(myModel, branch1, x[2,2] <= 0)
    @constraint(myModel, branch1, x[2,2] >= 1)
    @constraint(myModel, branch2, x[5,5] >= 1)

    @constraint(myModel, branch3, x[3,5] <= 0)

    @constraint(myModel, branch4, y[5,1] <= 0)

    @constraint(myModel, branch5, y[1,3] >= 1)

    @constraint(myModel, branch6, y[4,1] >= 1)


    @constraint(myModel, branch7, y[1,5] >= 1)
    @constraint(myModel, branch8, y[1,1] >= 1)

    # Define blocks (Each block becomes a sub-problem)
    # we have two constraints in the sub
    blocks = Vector{Vector{ConstraintRef}}(undef, m)
    for i in 1:m
        blocks[i] = Vector{ConstraintRef}()  # Initialize as an empty vector
        push!(blocks[i], SupplyCons[i])
        for j in 1:n
            push!(blocks[i],routeCons[i,j])
        end
    end     
    push!(blocks[2], branch1)
    push!(blocks[5], branch2)
    push!(blocks[3], branch3)
    push!(blocks[5], branch4)
    push!(blocks[1], branch5)
    push!(blocks[4], branch6)
    push!(blocks[1], branch7)
    push!(blocks[1], branch8)
    return myModel, blocks
end


function main()
    # Builds matrix A from data
    include("Task5_Build_matrix_A.jl")
    FCTP_Model, blocks = FCTP_MIP(c,f,m,supply,demand)
    DW_ColGen.DWColGenEasy(FCTP_Model, blocks)
end

main()

