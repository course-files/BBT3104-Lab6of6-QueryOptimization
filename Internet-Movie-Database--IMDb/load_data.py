import csv
import argparse

import mysql.connector

def insert_data_from_csv(csv_file_path, db_config):
    # Connect to MySQL database
    conn = mysql.connector.connect(
        host=db_config['host'],
        port=db_config.get('port', 3307),
        user=db_config['user'],
        password=db_config['password'],
        database=db_config['database']
    )
    cursor = conn.cursor()

    # Open the CSV file
    with open(csv_file_path, mode='r', encoding='utf-8') as csv_file:
        # Get the headers from the database DDL statement
        cursor.execute(f"DESCRIBE {db_config['table']}")
        headers = [row[0] for row in cursor.fetchall()]

        # Open the CSV file and read its content
        csv_reader = csv.reader(csv_file)

        try:
            csv_header = next(csv_reader)  # Read the first row (header)
        except csv.Error as e:
            print(f"Error reading CSV file: {e}")
            return

        # Skip the header row in the CSV file
        next(csv_reader, None)
        # Prepare the insert query
        insert_query = f"INSERT INTO {db_config['table']} ({', '.join(headers)}) VALUES ({', '.join(['%s'] * len(headers))})"

        # Insert each row into the database
        for row in csv_reader:
            if len(row) != len(headers):
                print(f"Row length {len(row)} does not match headers length {len(headers)}")
                print("Row:", row)
                continue  # Skip this row or handle the mismatch appropriately
            
            # Convert empty strings to None
            # row = [None if field == '' else field for field in row]
            
            # Debugging: Print the final query with values
            formatted_query = insert_query % tuple(row)
            print("**ROW** ", row)
            print("**INSERT** ", formatted_query)

            cursor.execute(insert_query, row)

    # Commit the transaction
    conn.commit()

    # Close the cursor and connection
    cursor.close()
    conn.close()

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Insert data from a CSV file into a MySQL database.')
    print("Usage: python load_data.py <csv_file_path> --host <host> --port <port> --user <user> --password <password> --database <database> --table <table>")

    # company_name
    # python Internet-Movie-Database--IMDb/load_data.py 'Internet-Movie-Database--IMDb/As Used in Leis et al. (2018)/imdb/company_name.csv' --host localhost --port 3307 --user root --password 5trathm0re --database imdb_schema --table company_name

    # company_type
    # python Internet-Movie-Database--IMDb/load_data.py 'Internet-Movie-Database--IMDb/As Used in Leis et al. (2018)/imdb/company_type.csv' --host localhost --port 3307 --user root --password 5trathm0re --database imdb_schema --table company_type

    parser.add_argument('csv_file_path', type=str, help='The path to the CSV file.')
    parser.add_argument('--host', type=str, default='localhost', help='The MySQL database host.')
    parser.add_argument('--port', type=int, default=3307, help='The MySQL database port.')
    parser.add_argument('--user', type=str, default='root', help='The MySQL database user.')
    parser.add_argument('--password', type=str, default='5trathm0re', help='The MySQL database password.')
    parser.add_argument('--database', type=str, default='imdb_schema', help='The MySQL database name.')
    parser.add_argument('--table', type=str, default='yourtable', help='The MySQL database table.')

    args = parser.parse_args()

    db_config = {
        'host': args.host,
        'port': args.port,
        'user': args.user,
        'password': args.password,
        'database': args.database,
        'table': args.table
    }

    insert_data_from_csv(args.csv_file_path, db_config)