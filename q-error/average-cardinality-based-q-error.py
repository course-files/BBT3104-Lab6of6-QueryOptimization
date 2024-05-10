# Limitation: Calculates the q-error based on the final row estimate only.
import psycopg2
import pandas as pd

# Database connection parameters
conn_params = {
    'database': 'imdb',
    'user': 'postgres',
    'password': '5trathm0re',
    'host': 'localhost',
    'port': '5432'
}

# Connect to the PostgreSQL database
conn = psycopg2.connect(**conn_params)
cur = conn.cursor()

# Set the schema
cur.execute("SET search_path TO imdb_schema;")

def execute_query_and_calculate_qerror(query):
    # Execute the query with EXPLAIN ANALYZE
    cur.execute("EXPLAIN (ANALYZE, BUFFERS, VERBOSE) " + query)
    analyze_results = cur.fetchall()
    
    # Execute the query with EXPLAIN (without ANALYZE) to get the planner's estimation
    cur.execute("EXPLAIN " + query)
    explain_results = cur.fetchall()

    # Extract actual rows from analyze results
    actual_rows_list = []
    for line in analyze_results:
        if "rows=" in line[0] and "loops=" in line[0]:
            parts = line[0].split()
            for part in parts:
                if "rows=" in part:
                    actual_rows = int(part.split("=")[1])
                    actual_rows_list.append(actual_rows)

    # Extract estimated rows from explain results
    estimated_rows_list = []
    for line in explain_results:
        if "rows=" in line[0]:
            estimated_rows = int(line[0].split("rows=")[1].split(" ")[0])
            estimated_rows_list.append(estimated_rows)

    # Calculate q-error for each node
    q_errors = []
    for actual_rows, estimated_rows in zip(actual_rows_list, estimated_rows_list):
        if actual_rows > 0:  # Ensure no division by zero
            q_error = max(estimated_rows / actual_rows, actual_rows / estimated_rows)
            q_errors.append(q_error)
        else:
            q_errors.append(float('inf'))  # Handle division by zero or missing data

    return q_errors

# Example usage
query = "SELECT COUNT(*) FROM movie_companies mc, title t, movie_info_idx mi_idx WHERE t.id=mc.movie_id AND t.id=mi_idx.movie_id AND mi_idx.info_type_id=112 AND mc.company_type_id=2;"
q_errors = execute_query_and_calculate_qerror(query)
print("Q-Errors for each node:", q_errors)

print("\nInterpretation:")
print(
    "* Q-error = 1 -> A perfect estimation.",
    "\n* Q-error > 1 indicates how many times the estimate was off",
    "compared to the actual execution.")

# Close the database connection
cur.close()
conn.close()
