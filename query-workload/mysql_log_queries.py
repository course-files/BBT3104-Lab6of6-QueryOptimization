import mysql.connector
from ruamel.yaml import YAML
import sys

def connect_to_database(conn_params):
    try:
        conn = mysql.connector.connect(**conn_params)
        return conn
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return None

def read_query_from_file(file_path):
    with open(file_path, 'r') as file:
        query = file.read().strip()
    return query

def execute_query(conn, query, output_file):
    cursor = None
    try:
        cursor = conn.cursor()
        cursor.execute("EXPLAIN ANALYZE " + query)
        analyze_results = cursor.fetchall()
        
        nodes = []
        for row in analyze_results:
            row_str = row[0]
            parts = row_str.split('->')
            for part in parts:
                node_info = part.strip().split()
                if len(node_info) > 0:
                    node = ' '.join(node_info)
                    actual_rows = None
                    estimated_rows = None
                    rows_count = 0
                    for info in node_info:
                        if info.startswith("rows="):
                            rows_count += 1
                            if rows_count == 1:
                                estimated_rows = float(info.split('=')[1].replace(')', ''))
                            elif rows_count == 2:
                                actual_rows = float(info.split('=')[1].replace(')', ''))
                                break
                    q_error = None
                    if actual_rows and estimated_rows:
                        q_error = max(estimated_rows / actual_rows, actual_rows / estimated_rows)
                    nodes.append({'node': node, 'actual_rows': actual_rows, 'estimated_rows': estimated_rows, 'q_error': q_error})
        
        result = {
            'query': query,
            'qep': nodes
        }
        
        yaml = YAML()
        yaml.default_flow_style = False
        
        # Output to console
        yaml.dump([result], sys.stdout)
        
        # Write to file
        with open(output_file, 'w') as file:
            yaml.dump([result], file)
    except Exception as e:
        print(f"Error executing query: {e}")
    finally:
        if cursor:
            cursor.close()

def main():
    # Database connection parameters
    conn_params = {
        'database': 'imdb_schema',
        'user': 'jkirui',
        'password': '*****',
        'host': 'localhost',
        'port': '3306'
    }

    # Connect to the MySQL database
    conn = connect_to_database(conn_params)
    if not conn:
        return

    try:
        # Read query from file
        file_path = 'Join-Order-Benchmark-queries/JOB-light-3.sql'
        query = read_query_from_file(file_path)

        # Execute query and print EXPLAIN ANALYZE output
        output_file = 'query-workload/mysql_query_workload_results.yaml'
        execute_query(conn, query, output_file)
    finally:
        conn.close()

if __name__ == "__main__":
    main()