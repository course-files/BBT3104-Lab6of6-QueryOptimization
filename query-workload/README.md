# Query Workload

The query workload stored in [query_log.csv](/query-workload/query_log.csv) includes:

- A unique autoincrement ID
- The query itself in text form
- The Query Execution Plan (QEP) in YAML (YAML to preserve the hierarchical nature of the nodes). Each node shows the actual cardinality and the estimated cardinality.
- The overall actual cardinality retrieved by the query
- The query optimizer's overall estimated cardinality
- The timestamp of when the QEP was obtained

The dataset is retrieved by executing ```EXPLAIN ANALYZE``` using [log_queries.py](/query-workload/log_queries.py). This is done for each Join Order Benchmark (JOB) query available [here](/Join-Order-Benchmark-queries/). The JOB queries in the query_log dataset are (sorted by timestamp in ascending order):

- Line 1-113: [JOB-original-113.sql](/Join-Order-Benchmark-queries/JOB-original-113.sql)
- **_Work-in-Progress_**: Line 114-184: [JOB-light-70.sql](/Join-Order-Benchmark-queries/JOB-light-70.sql)
- **_Work-in-Progress_**: Line 185-685: [JOB-scale-500.sql](/Join-Order-Benchmark-queries/JOB-scale-500.sql)
- **_Work-in-Progress_**: Line 686-5,686: [JOB-synthetic-5000.sql](/Join-Order-Benchmark-queries/JOB-synthetic-5000.sql)

The alternative to having a manual list of queries is to track executed queries and their statistics as they are executed. The following lines would be added to [postgresql.conf](/container-volumes/postgresql/postgresql.conf) for this automatic tracking.

```conf
shared_preload_libraries = 'pg_stat_statements'
pg_stat_statements.max = 10000
pg_stat_statements.track = all
```
