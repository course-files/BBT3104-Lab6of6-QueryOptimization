import psycopg2
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
from sklearn.model_selection import train_test_split
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.preprocessing.text import Tokenizer
import tensorflow as tf
from tensorflow.keras.layers import Input, Embedding, Conv1D, GlobalMaxPooling1D, Dense

# Parameters
max_sequence_length = 100
num_words = 10000
embedding_dim = 50

def connect_to_db():
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
    cursor = conn.cursor()

    # Set the schema
    cursor.execute("SET search_path TO imdb_schema;")
    return conn

def capture_query_workload(conn):
    queries = []
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT query_text, actual_rows FROM query_log;")
        for query_text, actual_rows in cursor.fetchall():
            queries.append((query_text, actual_rows))
    except Exception as e:
        print(f"Error capturing query workload: {e}")
    finally:
        if cursor:
            cursor.close()
    return queries

def preprocess_query_data(queries):
    query_texts = [query[0] for query in queries]
    row_counts = [query[1] for query in queries]

    # Tokenize query texts
    tokenizer = Tokenizer(num_words=num_words, oov_token="<OOV>")
    tokenizer.fit_on_texts(query_texts)
    sequences = tokenizer.texts_to_sequences(query_texts)
    padded_sequences = pad_sequences(sequences, maxlen=max_sequence_length, padding='post')

    return padded_sequences, row_counts, tokenizer

def build_mscn_model(input_length, num_words, embedding_dim):
    input_query_text = Input(shape=(input_length,))
    embedded_query_text = Embedding(input_dim=num_words, output_dim=embedding_dim)(input_query_text)
    conv_layer = Conv1D(filters=128, kernel_size=5, activation='relu')(embedded_query_text)
    pooled_layer = GlobalMaxPooling1D()(conv_layer)
    output_layer = Dense(1, activation='linear')(pooled_layer)
    
    model = tf.keras.Model(inputs=input_query_text, outputs=output_layer)
    model.compile(optimizer='adam', loss='mean_squared_error', metrics=['mae'])
    
    return model


def main():
    conn = connect_to_db()
    queries = capture_query_workload(conn)
    # print(queries)
    X, y, tokenizer = preprocess_query_data(queries)
    print("\n***PADDED SEQUENCES:***\n", X)
    print("\n***ROW COUNTS:***\n", y)
    print("\n***TOKENIZER:***\n", tokenizer)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    mscn_model = build_mscn_model(max_sequence_length, num_words, embedding_dim)
    history = mscn_model.fit(X_train, y_train, epochs=10, batch_size=32, validation_split=0.2)
    
    loss, mae = mscn_model.evaluate(X_test, y_test)
    print(f"Test Loss: {loss}, Test MAE: {mae}")

if __name__ == "__main__":
    main()