# Query Workload

The query workload stored in [query_log.csv](/query-workload/query_log.csv) includes:

- A unique autoincrement ID
- The query itself in text form
- The Query Execution Plan (QEP) in YAML (YAML to preserve the hierarchical nature of the nodes). Each node shows the actual cardinality and the estimated cardinality.
- The overall actual cardinality retrieved by the query
- The query optimizer's overall estimated cardinality
- The timestamp of when the QEP was obtained

The dataset is retrieved by executing ```EXPLAIN``` and ```EXPLAIN ANALYZE``` using [log_queries.py](/query-workload/log_queries.py). This is done for each Join Order Benchmark (JOB) query available [here](/Join-Order-Benchmark-queries/). The JOB queries include:

- Line 1-70: [JOB-light-70.sql](/Join-Order-Benchmark-queries/JOB-light-70.sql)
- **Work-in-Progress**: Line 71-571: [JOB-scale-500.sql](/Join-Order-Benchmark-queries/JOB-scale-500.sql)
- **Work-in-Progress**: Line 572-5,572: [JOB-synthetic-5000.sql](/Join-Order-Benchmark-queries/JOB-synthetic-5000.sql)
- **Work-in-Progress**: Line 5,572-5,689: [1a.sql - 33c.sql](/Join-Order-Benchmark-queries/)
