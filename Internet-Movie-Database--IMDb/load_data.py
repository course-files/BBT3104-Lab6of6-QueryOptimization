import csv
import argparse

import mysql.connector

def insert_data_from_csv(csv_file_path, db_config):
    # Connect to MySQL database
    conn = mysql.connector.connect(
        host=db_config['host'],
        user=db_config['user'],
        password=db_config['password'],
        database=db_config['database'],
        port=db_config.get('port', 3307)
    )
    cursor = conn.cursor()

    # Open the CSV file
    with open(csv_file_path, mode='r', encoding='utf-8-sig') as csv_file:
        # Get the headers from the database DDL statement
        cursor.execute(f"DESCRIBE {db_config['table']}")
        headers = [row[0] for row in cursor.fetchall()]

        # Open the CSV file and read its content
        csv_reader = csv.reader(csv_file)
        next(csv_reader)  # Skip the header row in the CSV file

        # Prepare the insert query
        insert_query = f"INSERT INTO {db_config['table']} ({', '.join(headers)}) VALUES ({', '.join(['%s'] * len(headers))})"

        # Insert each row into the database
        for row in csv_reader:
            cursor.execute(insert_query, row)

    # Commit the transaction
    conn.commit()

    # Close the cursor and connection
    cursor.close()
    conn.close()

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Insert data from a CSV file into a MySQL database.')
    print("Usage: python load_data.py <csv_file_path> --host <host> --user <user> --password <password> --database <database> --table <table> [--port <port>]")

    # python Internet-Movie-Database--IMDb/load_data.py 'Internet-Movie-Database--IMDb/As Used in Leis et al. (2018)/imdb/name.csv' --password 5trathm0re --database imdb_schema --table name

    parser.add_argument('csv_file_path', type=str, help='The path to the CSV file.')
    parser.add_argument('--host', type=str, default='localhost', help='The MySQL database host.')
    parser.add_argument('--user', type=str, default='root', help='The MySQL database user.')
    parser.add_argument('--password', type=str, default='yourpassword', help='The MySQL database password.')
    parser.add_argument('--database', type=str, default='imdb_schema', help='The MySQL database name.')
    parser.add_argument('--table', type=str, default='yourtable', help='The MySQL database table.')
    parser.add_argument('--port', type=int, default=3307, help='The MySQL database port.')

    args = parser.parse_args()

    db_config = {
        'host': args.host,
        'user': args.user,
        'password': args.password,
        'database': args.database,
        'table': args.table,
        'port': args.port
    }

    insert_data_from_csv(args.csv_file_path, db_config)