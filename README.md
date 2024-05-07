# Query Optimization

These are course files (instructional materials) for both the **BBT3104: Advanced Database Systems** and the **MIT8107: Advanced Database Systems** courses.

| **Key**                                                               | Value                                                                                                                                                                              |
|---------------|---------------------------------------------------------|
| **Course Code**                                                       | BBT3104 and MIT8107                                                                                                                                                                            |
| **Course Name**                                                       | Advanced Database Systems _(same name for both courses)_                                                                                                                                                           |
| **URL**                                                               | <https://elearning.strathmore.edu/course/view.php?id=3932> and <https://elearning.strathmore.edu/course/view.php?id=3277> respectively                                                                                                                         |
| **Semester Duration**                                                 | _To be confirmed_                                                                                                                       |
| **Lecturer**                                                          | Allan Omondi                                                                                                                                                                       |
| **Contact**                                                           | aomondi_at_strathmore_dot_edu                                                                                                                                                      |

## Internet Movie Database (IMDb)

IMDb captures more than 2.5 million movie titles produced over 133 years by 234,997 different companies with over 4 million actors. It subsequently contains many **join-crossing correlations** thus making it challenging for cardinality estimators. This is unlike TPC-H and TPC-DS which are considered trivial for cardinality estimators.

![imdb_ERD](https://github.com/course-files/BBT3104-Lab6of6-QueryOptimization/assets/137632706/a7202d6e-c345-498e-9fa2-dd9d5a834a08)

* The version of IMDb used in Leis et al. (2018) can be downloaded from here: [http://homepages.cwi.nl/~boncz/job/imdb.tgz](http://homepages.cwi.nl/~boncz/job/imdb.tgz) **(Recommended)**

* The current version of IMDb can be
downloaded from here: [http://www.imdb.com/interfaces](http://www.imdb.com/interfaces)

## Data Import

1. Create the PostgreSQL Docker container using [Docker-Compose.yaml](/Docker-Compose.yaml)

2. Create the IMDb database in Postgres using [schema.sql](Internet-Movie-Database--IMBDb/schema.sql)

3. Download the `.tgz` file, decompress it, and import each `.csv` file into its respective table. You can use [DBeaver](https://dbeaver.io/) (recommended) or any other similar database tool when importing. A slightly similar video tutorial is available [here on YouTube](https://youtu.be/PKpzDL-yRPw?si=Y32Hqp3k0ZO9Kwm7).<br> Alternatively, you can use [cinemagoer](https://pypi.org/project/cinemagoer/), formerly [IMDbPy](https://pypi.org/project/IMDbPY/), to automate this step.

## Join Order Benchmark (JOB) queries

4. Proceed to execute the Join Order Benchmark (JOB) queries available [here](/Join-Order-Benchmark-queries) on the IMDb database in PostgreSQL.

## Acknowledgment

This code repository has been forked from **[join-order-benchmark](https://github.com/gregrahn/join-order-benchmark)** by [Greg Rahn](https://github.com/gregrahn), [Moritz Eyssen](https://github.com/mrzzzrm), [maahl](https://github.com/maahl), and [Max Halford](https://github.com/MaxHalford).

## Reference

Leis, V., Radke, B., Gubichev, A., Mirchev, A., Boncz, P., Kemper, A., & Neumann, T. (2018). Query optimization through the looking glass, and what we found running the Join Order Benchmark. _The VLDB Journal, 27_(5), 643–668. <https://doi.org/10.1007/s00778-017-0480-7>
