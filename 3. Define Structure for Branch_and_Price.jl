using LinearAlgebra

# include data
# cost per unit sent from Source i to  Terminal j
c = [
        1.5  5.8  2.3  1.0  6.2
        8.9  4.9  9.5  8.2  6.3
        8.2  3.4  8.7  7.9  4.7
        5.0  8.9  5.7  3.0  9.7
        4.2  2.2  4.5  4.5  2.9
    ]

# Supply for sources
supply = [
    2
    4
    5
    8
    10]

# Demand
demand = [3
    9
    3
    6
    8]

# fixed cost of connecting customer from Source i to Terminal j
f = [
    11.0  12.0  14.0  20.0  14.0
    17.0  15.0  15.0  12.0  13.0
    11.0  16.0  17.0  14.0  10.0
    11.0  13.0  17.0  18.0  11.0
    11.0  12.0  15.0  18.0  11.0]


m = [min(ai, bj) for ai in supply, bj in demand]  # Calculate mij as min{ai, bj}

# Initialize the matrix A with zeros
# For 5 sources and 5 terminals, we have 5*5=25 xij and yij variables each
# Additionally, there are 5 supply constraints, 5 demand constraints, and 25 xij-yij constraints
# So, the matrix A will have 5+5+25 rows and 25+25 columns for xij and yij
A = zeros(5 + 5 + 25, 25 + 25)

# Populate the matrix for supply constraints
for i in 1:5
    A[i, (i-1)*5+1:i*5] .= 1  # Set 1 for xij variables corresponding to supply ai
end

# Populate the matrix for demand constraints
for j in 1:5
    A[5+j, j:5:end] .= 1  # Set 1 for xij variables corresponding to demand bj
end

# Populate the matrix for xij - mij*yij <= 0 constraints
for i in 1:5, j in 1:5
    row_index = 10 + (i-1)*5 + j  # Starting from row 10, for each xij-yij constraint
    A[row_index, (i-1)*5 + j] = 1             # Set 1 for xij
    A[row_index, 25 + (i-1)*5 + j] = -m[i, j]  # Set -mij for yij
end

# Since RHS is not part of the matrix A, we create it separately
RHS = [supply; demand; zeros(25)]  # RHS for supply, demand, and xij-yij constraints

A, RHS
#*************************************************************************

cols_order = [1, 2, 3, 4, 5, 26, 27, 28, 29, 30,
                6, 7, 8, 9, 10, 31, 32, 33, 34, 35,
                11, 12, 13, 14, 15, 36, 37, 38, 39, 40,
                16, 17, 18, 19, 20, 41, 42, 43, 44, 45,
                21, 22, 23, 24, 25, 46, 47, 48, 49, 50]

# # Create a copy of A to reorder
A_reordered = copy(A)
b_reordered = copy(RHS)

# # Reorder columns
# where each block corresponds to the constraints for one source
A = A_reordered[:, cols_order]

rows_order = [6,7,8,9,10,1,11,12,13,14,15,2,16,17,18,19,20,3,21,22,23,24,25,4,26,27,28,29,30,5,31,32,33,34,35]
A_reorder_row = copy(A)
A = A_reorder_row[rows_order,:]

b = b_reordered[rows_order]

# Concatenate each row into a column vector
cost_vector = reshape(c', 25, 1)
fixed_vector = reshape(f',25,1)

c_titled = vcat(cost_vector,fixed_vector)
c_temp = copy(c_titled)
c_titled = c_temp[cols_order]'

