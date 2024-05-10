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

# Function to execute a query and calculate q-error
def execute_query_and_calculate_qerror(query):
    # Execute the query with EXPLAIN ANALYZE
    cur.execute("EXPLAIN (ANALYZE, BUFFERS, VERBOSE) " + query)
    results = cur.fetchall()
    
    # Extract actual rows
    actual_rows = None
    for line in results:
        if " rows=" in line[0] and "loops=" in line[0]:  # Typically appears in this format
            actual_rows = int(line[0].split(" rows=")[1].split(" ")[0])
            break
    
    # Execute the query with EXPLAIN (without ANALYZE) to get the planner's estimation
    cur.execute("EXPLAIN (BUFFERS, VERBOSE) " + query)
    estimated_plan = cur.fetchall()

    # Initialize variable for estimated rows
    estimated_rows = 0

    # Extract the estimated number of rows
    for line in estimated_plan:
        if "rows=" in line[0]:
            estimated_rows = int(line[0].split("rows=")[1].split(" ")[0])
            break

    # Calculate the q-error
    if actual_rows is not None and estimated_rows is not None and actual_rows != 0:
        q_error = max(estimated_rows / actual_rows, actual_rows / estimated_rows)
    else:
        q_error = float('inf')  # Handling the case where actual rows might be zero or data isn't parsed correctly

    print("Estimated Rows = ", estimated_rows)
    print("Actual Rows = ", actual_rows)
    print("Q-error = max(Estimated Rows / Actual Rows, Actual Rows / Estimated Rows)\n")

    return q_error


# Example query
query = "SELECT COUNT(*) FROM movie_companies mc,title t,movie_info_idx mi_idx WHERE t.id=mc.movie_id AND t.id=mi_idx.movie_id AND mi_idx.info_type_id=113 AND mc.company_type_id=2 AND t.production_year>2005 AND t.production_year<2010;"
q_error = execute_query_and_calculate_qerror(query)
print("Q-Error = ", q_error)

print("\nInterpretation:")
print(
    "* Q-error = 1 -> A perfect estimation.",
    "\n* Q-error > 1 indicates how many times the estimate was off",
    "compared to the actual execution.")

# Close the database connection
cur.close()
conn.close()
