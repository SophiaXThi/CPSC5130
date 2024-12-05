# CPSC5130

# Hospital Database Query Executor

This is a Java-based application that allows users to execute predefined SQL queries on a hospital database. The queries cover various aspects of hospital operations, including patient admissions, treatments, doctor-patient assignments, and more. The application provides an interactive menu where users can select queries to run and view the results.

## Features
- Display a list of SQL queries to choose from Checkpoint3.sql
- Execute a query by selecting a corresponding number.
- Option to run another query or exit the application after each execution.
- Provides descriptive information for each query to help users understand what the query does.

## Prerequisites
- Java 11 or higher.
- MySQL database setup with the relevant tables (e.g., `Room`, `Patient`, `Doctor`, etc.). from Checkpoint2.sql 
- MySQL JDBC Connector (included in the project dependencies).

## Setup
- Download this on local computer

## How it works
- Run the main class and it will display a simple menu that ask the user which query they would like to run.
- The user will enter in a number corresponding to the query
- It will return the results to the console
- It will ask the user if they want to run another query
- If the user types in yes, it will display the menu and ask the user to select which query.
- If the user types in no, it will close the application until the user opts to run it again. 
