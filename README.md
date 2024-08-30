# Solving_FCTP_using_DW

**Project Overview**
This project explores the Fixed Charge Transportation Problem (FCTP), an extension of the classical transportation problem. The FCTP considers both fixed and variable costs associated with transporting goods from a set of supply nodes to a set of demand nodes. The goal of the project is to model the problem mathematically and explore solution techniques such as Dantzig-Wolfe decomposition. The project is inspired by course 42136 Large Scale Optimization using Decomposition taught by Stefan Røpke, Richard Martin Lusby, Thomas Jacob Riis Stidsen at DTU.

The FCTP can be formulated as follows:

\[
\text{minimize} \quad \sum_{i \in S} \sum_{j \in T} (c_{ij} x_{ij} + f_{ij} y_{ij})
\]

Subject to:

\[
\sum_{j \in T} x_{ij} = a_i \quad \forall i \in S
\]

\[
\sum_{i \in S} x_{ij} = b_j \quad \forall j \in T
\]

\[
x_{ij} \leq m_{ij} y_{ij} \quad \forall i \in S, j \in T
\]

\[
x_{ij} \geq 0 \quad \forall i \in S, j \in T
\]

\[
y_{ij} \in \{0, 1\} \quad \forall i \in S, j \in T
\]
