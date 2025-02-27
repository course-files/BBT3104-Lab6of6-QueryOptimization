import mysql.connector
from ruamel.yaml import YAML
import sys
from decimal import Decimal
from datetime import datetime
from io import StringIO

def connect_to_database(conn_params):
    try:
        conn = mysql.connector.connect(**conn_params)
        return conn
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return None

def read_queries_from_file(file_path):
    with open(file_path, 'r') as file:
        queries = file.read().strip().split(';')
    queries = [query.strip() for query in queries if query.strip()]
    return queries

def execute_query(conn, query):
    cursor = None
    try:
        cursor = conn.cursor()
        cursor.execute("EXPLAIN ANALYZE " + query)
        analyze_results = cursor.fetchall()
        
        nodes = []
        total_actual_rows = 0
        total_estimated_rows = 0
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
                    if actual_rows and estimated_rows:
                        total_actual_rows += actual_rows
                        total_estimated_rows += estimated_rows
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
        
        # Convert result to YAML string for logging
        result_stream = StringIO()
        yaml.dump([result], result_stream)
        result_yaml = result_stream.getvalue()
        
        return result_yaml, total_actual_rows, total_estimated_rows, q_error
    except Exception as e:
        print(f"Error executing query: {e}")
        return None, None, None, None
    finally:
        if cursor:
            cursor.close()

def log_queries(conn, query, results, actual_rows, estimated_rows, q_error):
    cursor = None
    try:
        cursor = conn.cursor()
        try:
            if actual_rows is not None:
                cursor.execute("""
                    INSERT INTO query_log (query_text, qep, actual_rows, estimated_rows, q_error, timestamp) 
                    VALUES (%s, %s, %s, %s, %s, %s);
                """, (query, results, Decimal(actual_rows), Decimal(estimated_rows), Decimal(q_error), datetime.now()))

                print(f"\nLOGGED QUERY:\n"
                      f"INSERT INTO query_log (query_text, qep, actual_rows, estimated_rows, q_error, timestamp) "
                      f"VALUES ({query}, {results}, {actual_rows}, {estimated_rows}, {q_error}, {datetime.now()})")
            else:
                print(f"Could not determine actual rows for query: {query}")
        except Exception as e:
            print(f"Error logging query: {query}\nError: {e}")

        conn.commit()
    except Exception as e:
        print(f"Error logging SELECT statements: {e}")
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
        # Read queries from file
        file_path = 'Join-Order-Benchmark-queries/JOB-scale-500-pending-for-mysql.sql'
        queries = read_queries_from_file(file_path)

        all_results = []
        for query in queries:
            # Execute query and get QEP results
            result_yaml, total_actual_rows, total_estimated_rows, q_error = execute_query(conn, query)
            
            if result_yaml:
                all_results.append(result_yaml)
                # Log query results
                log_queries(conn, query, result_yaml, total_actual_rows, total_estimated_rows, q_error)

        # Write all results to the output file
        output_file = 'query-workload/mysql_query_workload_results.yaml'
        with open(output_file, 'w') as file:
            file.write('\n'.join(all_results))

    finally:
        conn.close()

if __name__ == "__main__":
    main()