import mysql.connector
import yaml
from ruamel.yaml import YAML, scalarstring

# Database connection parameters
conn_params = {
    'database': 'imdb_schema',
    'user': 'jkirui',
    'password': '5trathm0re',
    'host': 'localhost',
    'port': '3306'
}

# Connect to the MySQL database
conn = mysql.connector.connect(**conn_params)
cur = conn.cursor()

# Set the schema
cur.execute("USE imdb_schema;")

def execute_query_and_calculate_qerror(query):
    # Get the EXPLAIN ANALYZE output in JSON format
    cur.execute("EXPLAIN ANALYZE " + query)
    analyze_results = cur.fetchall()
    analyze_data = yaml.safe_load(analyze_results[0][0])

    # Get the EXPLAIN output in JSON format
    cur.execute("EXPLAIN FORMAT=JSON " + query)
    explain_results = cur.fetchall()
    explain_data = yaml.safe_load(explain_results[0][0])

    # Process JSON data to extract actual and estimated rows and maintain node order
    def extract_rows(data, key_actual, key_estimated):
        q_error_results = []

        def recurse_nodes(node, path=""):
            node_type = node.get('type', 'Unknown')
            new_path = f"{path}/{node_type}" if path else node_type
            if 'plans' in node:
                for subnode in node['plans']:
                    recurse_nodes(subnode, new_path)

            actual_rows = node.get(key_actual, 0)
            estimated_rows = node.get(key_estimated, 0)
            if actual_rows > 0:
                q_error = max(estimated_rows / actual_rows, actual_rows / estimated_rows)
            else:
                q_error = float('inf')  # Handle cases where actual rows are zero
            q_error_results.append((new_path, actual_rows, estimated_rows, q_error))

        recurse_nodes(data['query_block'])
        return q_error_results

    actual_key = 'rows_examined_per_scan'
    estimated_key = 'rows_produced_per_scan'
    q_error = extract_rows(analyze_data, actual_key, estimated_key)

    return q_error

def read_queries_from_file(file_path):
    with open(file_path, 'r') as file:
        # Assumption: Each query is separated by a semicolon
        queries = file.read().strip().split(';')
    # Removes any empty strings that may result from splitting
    queries = [query.strip() for query in queries if query.strip()]
    return queries

def main():
    yaml = YAML()
    yaml.indent(mapping=2, sequence=4, offset=2)

    # NOTE: Remember to specify the path as
    # '../Join-Order-Benchmark-queries/JOB-light-70.sql'
    # if you are running it from the 'q-error' directory.

    file_path = 'Join-Order-Benchmark-queries/1a.sql'
    # file_path = 'Join-Order-Benchmark-queries/JOB-light-70.sql'
    # file_path = 'Join-Order-Benchmark-queries/JOB-light-70-pending.sql'
    # file_path = 'Join-Order-Benchmark-queries/JOB-scale-500.sql'
    # file_path = 'Join-Order-Benchmark-queries/JOB-scale-500-pending.sql'
    # file_path = 'Join-Order-Benchmark-queries/JOB-synthetic-5000.sql'
    # file_path = 'Join-Order-Benchmark-queries/JOB-synthetic-5000-pending.sql'
    
    queries = read_queries_from_file(file_path)
    results = []  # Prepare a list to store results for each query
    
    for query in queries:
        q_error = execute_query_and_calculate_qerror(query)
        print("\n\n--------------------------------------------------")
        print("\nQuery:")
        print(query)
        print("\nCalculation:")
        print("Q-Error = max(Estimated Rows / Actual Rows, Actual Rows / Estimated Rows)\n")
        print("\nInterpretation:")
        print(
            "* Q-error = 1 implies a perfect estimation.",
            "\n* Q-error > 1 indicates how many times the estimate was off",
            "compared to the actual execution.\n")
        print("\nResults:")
        for node, actual, estimated, error in q_error:
            print(f"Node: {node}, Actual Rows: {actual}, Estimated Rows: {estimated}, Q-Error: {error}")
        
        # Prepare output to be stored in a YAML file        
        query_result = {
            "query": scalarstring.PreservedScalarString(query),  # Use PreservedScalarString for the query
            "calculation": "Q-Error = max(Estimated Rows / Actual Rows, Actual Rows / Estimated Rows)",
            "interpretation": [
                "Q-error = 1 implies a perfect estimation.",
                "Q-error > 1 indicates how many times the estimate was off compared to the actual execution."
            ],
            "results": [{"node": node, "actual_rows": actual, "estimated_rows": estimated, "q_error": error} for node, actual, estimated, error in q_error]
        }
        results.append(query_result)
    
    # Write results to a YAML file
    with open('q-error/q_error_results.yaml', 'w') as yaml_file:
        yaml.dump(results, yaml_file)

if __name__ == "__main__":
    main()
