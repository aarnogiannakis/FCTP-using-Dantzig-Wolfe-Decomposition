using LinearAlgebra

# Given supply and demand values for sources (a, b, c) and destinations (d, e, f)
a = [1, 2, 1]  # Supply values for sources a, b, c
b = [1, 2, 1]  # Demand values for destinations d, e, f

# Calculate the minimum of supply and demand for each route (m_ij values)
mij = [min(ai, bj) for ai in a for bj in b]
mij_matrix = reshape(mij, (length(a), length(b)))

# Number of sources and destinations
num_sources = length(a)
num_destinations = length(b)

# Initialize the matrix A with zeros
# It will have a row for each supply constraint, each demand constraint,
# and each route usage constraint, which is num_sources * num_destinations
num_constraints = num_sources + num_destinations + num_sources * num_destinations
num_variables = 2 * num_sources * num_destinations  # For x_ij and y_ij variables
A = zeros(num_constraints, num_variables)

# Populate the supply constraints
for i in 1:num_sources
    A[i, (i - 1) * num_destinations + 1 : i * num_destinations] .= 1
end

# Populate the demand constraintsB
for j in 1:num_destinations
    A[num_sources + j, j:num_destinations:num_sources*num_destinations] .= 1
end

# Populate the route usage constraints x_ij - mij*y_ij <= 0
for i in 1:num_sources
    for j in 1:num_destinations
        constraint_index = num_sources + num_destinations + (i - 1) * num_destinations + j
        x_index = (i - 1) * num_destinations + j
        y_index = num_sources * num_destinations + (i - 1) * num_destinations + j
        A[constraint_index, x_index] = 1  # Coefficient for x_ij
        A[constraint_index, y_index] = -mij_matrix[i, j]  # Coefficient for -m_ij*y_ij
    end
end

# Define the right-hand side (RHS) vector
RHS = [a; b; zeros(num_sources * num_destinations)]

# Display the matrix A and RHS
(A, RHS)

#*************************** Task 2 ************************************************

cols_order = [1, 2, 3, 10, 11, 12, 4, 5, 6, 13, 14, 15, 7, 8, 9, 16, 17, 18]
rows_order = [4, 5, 6, 1, 7, 8, 9, 2, 10, 11, 12, 3, 13, 14 , 15]
# # Create a copy of A to reorder
A_reordered = copy(A)
b_reordered = copy(RHS)

# # Reorder columns
# where each block corresponds to the constraints for one source
A = A_reordered[:, cols_order]
A_new = copy(A)

A = A_new[rows_order,:]
b = b_reordered[rows_order]


#*********************** Task 3 ***************************************
# c_titled
C = [2 1 2 10 10 10 1 2 1 10 10 10 2 1 2 10 10 10]

# Rows of Constraint Matrix A belonging in the Master Problem
masterRows = [1, 2, 3]

# rows of Constraint Matrix A belonging in the sub-problems
subBlocks=[[4],[8],[12]]

# #number of sub-problems
K=length(subBlocks)

# # v[k] is a vector of the variables in subproblem k
V = Vector{Vector{Int64}}(undef,K)

# 3 x-variables and 3 y_variables per problem 
V[1] = [1, 2, 3, 4, 5, 6]; 
V[2] = [7, 8, 9, 10, 11, 12]; 
V[3] = [13, 14, 15, 16, 17, 18];

A0 = A[masterRows,:]
b0 = b[masterRows,:]

CV = Vector{Array{Float64,2}}(undef,K)
A_V = Vector{Array{Float64,2}}(undef,K)
A0_V = Vector{Array{Float64,2}}(undef,K)
b_sub = Vector{Array{Float64,2}}(undef,K)

for k=1:K
    # submatrix of cost with the columns given by indices V_k
    CV[k] = C[:,V[k]]
    A0_V[k] = A0[:,V[k]]
    A_V[k] = A[[subBlocks[k][1], subBlocks[k][1] + 1,subBlocks[k][1] + 2, subBlocks[k][1] + 3] ,V[k]]
    b_sub[k] = b[subBlocks[k],:]

    
end

