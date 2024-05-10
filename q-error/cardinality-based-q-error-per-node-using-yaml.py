import psycopg2
import yaml

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
    # Get the EXPLAIN ANALYZE output in YAML format
    cur.execute("EXPLAIN (ANALYZE, BUFFERS, VERBOSE, FORMAT YAML) " + query)
    analyze_results = cur.fetchall()
    analyze_data = yaml.safe_load(analyze_results[0][0])

    # Get the EXPLAIN output in YAML format
    cur.execute("EXPLAIN (FORMAT YAML) " + query)
    explain_results = cur.fetchall()
    explain_data = yaml.safe_load(explain_results[0][0])

    # Process YAML data to extract actual and estimated rows and maintain node order
    def extract_rows(data, key_actual, key_estimated):
        q_error_results = []

        def recurse_nodes(node, path=""):
            node_type = node.get('Node Type', 'Unknown')
            new_path = f"{path}/{node_type}" if path else node_type
            if 'Plans' in node:
                for subnode in node['Plans']:
                    recurse_nodes(subnode, new_path)

            actual_rows = node.get(key_actual, 0)
            estimated_rows = node.get(key_estimated, 0)
            if actual_rows > 0:
                q_error = max(estimated_rows / actual_rows, actual_rows / estimated_rows)
            else:
                q_error = float('inf')  # Handle cases where actual rows are zero
            q_error_results.append((new_path, actual_rows, estimated_rows, q_error))

        recurse_nodes(data[0]['Plan'])
        return q_error_results

    actual_key = 'Actual Rows'
    estimated_key = 'Plan Rows'
    q_errors = extract_rows(analyze_data, actual_key, estimated_key)

    return q_errors

# Example usage
query = "SELECT COUNT(*) FROM movie_companies mc,title t,movie_info_idx mi_idx WHERE t.id=mc.movie_id AND t.id=mi_idx.movie_id AND mi_idx.info_type_id=112 AND mc.company_type_id=2;"
q_errors = execute_query_and_calculate_qerror(query)

print("\nCalculation:")
print("Q-Error = max(Estimated Rows / Actual Rows, Actual Rows / Estimated Rows)\n")
print("\nInterpretation:")
print(
    "* Q-error = 1 implies a perfect estimation.",
    "\n* Q-error > 1 indicates how many times the estimate was off",
    "compared to the actual execution.\n")
print("\nResults:")
for node, actual, estimated, error in q_errors:
    print(f"Node: {node}, Actual Rows: {actual}, Estimated Rows: {estimated}, Q-Error: {error}")
