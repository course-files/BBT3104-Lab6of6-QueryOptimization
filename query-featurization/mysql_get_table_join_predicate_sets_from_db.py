import re
import mysql.connector

def connect_to_database(conn_params):
    try:
        conn = mysql.connector.connect(**conn_params)
        return conn
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return None

def set_schema(conn, schema):
    cursor = None
    try:
        cursor = conn.cursor()
        cursor.execute(f"USE {schema};")
        conn.commit()
    except Exception as e:
        print(f"Error setting schema: {e}")
    finally:
        if cursor:
            cursor.close()

def extract_components(query):
    query = query.replace('\n', ' ')  # Replace \n with a space
    # Extract table set
    table_set = re.findall(r'FROM\s+([\s\S]+?)\s+WHERE', query, re.IGNORECASE)
    if table_set:
        table_set = table_set[0].split(',')
        table_set = [table.strip().split(' AS ') for table in table_set]

        table_names = []
        table_aliases = []

        for table in table_set:
            if len(table) > 1:
                table_name, table_alias = table[0], table[1].strip()
            else:
                table_name, table_alias = table[0], None

            if ' ' in table_name:
                table_name, table_alias = table_name.split(' ', 1)

            table_names.append(table_name)
            table_aliases.append(table_alias.split()[-1] if table_alias else None)

    # Extract join set and predicate set
    where_clause = re.findall(r'WHERE\s+([\s\S]+)', query, re.IGNORECASE)
    join_set = []
    predicate_set = []
    if where_clause:
        # TODO: Improve the code to handle conditions that contain the AND keyword
        # For example: '...AND t.production_year BETWEEN 1980 AND 1995'
        # Notice the second AND

        # TODO: Improve the code to split the operators and values in the predicate set
        conditions = where_clause[0].split('AND')
        print("\n############################################")
        for condition in conditions:
            condition = condition.strip()
            if re.search(r'=\s*', condition):
                if re.search(r'(\w+)\s*=\s*(\w+)', condition):
                    # Remove all spaces for easier processing
                    condition = condition.replace(" ", "")
                    print("\n\nThe condition is ", condition)
                    left_side, right_side = re.search(r'(\w+\.\w+)\s*=\s*(\w+)', condition).groups()
                    left_side = left_side.split('.')[0]
                    right_side = right_side.split('.')[-1]
                    print("The left side is ", left_side)
                    print("The right side is ", right_side)
                    if (left_side in table_names or left_side in table_aliases) and (right_side in table_names or right_side in table_aliases):
                        print("Verdict: Included in the join set only")
                        join_set.append(condition)
                    else:
                        print("Verdict: Included in the predicate set only WITH the '=' operator")
                        predicate_set.append(condition)
            else:
                print("\n\nThe condition is ", condition)
                print("Verdict: Included in the predicate set only WITHOUT the '=' operator")
                # Captures the remaining predicates that do not have an '=' sign
                # For example, 'student_ID > 100'
                predicate_set.append(condition)

    return table_names, table_aliases, join_set, predicate_set

def update_query_log(conn):
    try:
        cursor = conn.cursor()
        set_schema(conn, 'imdb_schema')

        # Fetch the query from the query_log table
        cursor.execute("SELECT id, query_text FROM query_log")
        rows = cursor.fetchall()

        for row in rows:
            query_id = row[0]
            query_text = row[1]

            # Extract components from the query
            table_names, table_aliases, join_set, predicate_set = extract_components(query_text)

            # Update the query_log table with the extracted components
            cursor.execute("""
                UPDATE query_log
                SET table_set = %s, table_alias_set = %s, join_set = %s, predicate_set = %s
                WHERE id = %s
            """, (str(table_names), str(table_aliases), str(join_set), str(predicate_set), query_id))

            print("\n----------------------------------------")
            print(f"\nRow number: {query_id}\n")
            print("\nInitial Query\n: ",query_text)
            
            print("\nTable Set:\n", table_names)
            print("\nTable Alias Set:\n", table_aliases)
            print("\nJoin Set:\n", join_set)
            print("\nPredicate Set:\n", predicate_set)

            print("\nUpdate Query:\nUPDATE query_log",
                f" SET table_set = {table_names}, table_alias_set = {table_aliases}, join_set = {join_set},", f" predicate_set = {predicate_set}"
                f" WHERE id = {query_id}")

        # Commit the transaction
        conn.commit()

    except Exception as e:
        print(f"Error: {e}")
    finally:
        if conn:
            cursor.close()
            conn.close()

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
        # Set the schema
        set_schema(conn, 'imdb_schema')
        # Run the update function
        update_query_log(conn)
        
    finally:
        conn.close()

if __name__ == "__main__":
    main()