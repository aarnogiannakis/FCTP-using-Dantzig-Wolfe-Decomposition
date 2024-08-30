# Solving_FCTP_using_DW

**Project Overview**
This project explores the Fixed Charge Transportation Problem (FCTP), an extension of the classical transportation problem. The FCTP considers both fixed and variable costs associated with transporting goods from a set of supply nodes to a set of demand nodes. The goal of the project is to model the problem mathematically and explore solution techniques such as Dantzig-Wolfe decomposition. The project is inspired by course 42136 Large Scale Optimization using Decomposition taught by Stefan Røpke, Richard Martin Lusby, Thomas Jacob Riis Stidsen at DTU.

In the FCTP, we are given a set of supply nodes (S) and a set of demand nodes (T). The problem is to determine the most cost-effective way to transport goods from the supply nodes to the demand nodes, considering two types of costs. The fixed cost incurred to open a connection between supply node 𝑖 and demand node j, and the variable cost per unit of goods transported from 𝑖 to 𝑗.

Each supply node 𝑖 has a certain amount of goods 𝑎_𝑖 available, and each demand node j requires a specific amount of goods 𝑏_𝑗. The total supply equals the total demand, ensuring a balanced transportation problem.

1. In the first part we consider a system with 3 supply nodes and 3 demand nodes.
2. In the second part (Branch_and_price) we consider a 5x5 system 
