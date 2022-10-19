- [Part 1. Local MySQL database](#part-1-local-mysql-database)
- [Part 2. Backup, RDS AWS](#part-2-backup-rds-aws)
  * [Backup](#backup)
  * [RDS AWS](#rds-aws)
- [Part 3. MongoDB](#part-3-mongodb)

## Part 1. Local MySQL database

All queries from this part are also stored in [queries.sql](./queries.sql).

Database schema:

![alt text](./images/schema.png)

Create database:

![alt text](./images/1.png)

Create tables:

![alt text](./images/2.png)

Fill in tables:

![alt text](./images/3.png)

`SELECT` operator with `WHERE`, `GROUP BY` and `ORDER BY`:

![alt text](./images/4.png)

Other queries. `ALTER` and `CREATE` are Data Definition Language queries that change the structure of the database. `UPDATE` is a Data Manipulation Language query that changes data in the database. `GRANT` is a Data Control Language query that grants privileges to database users.

![alt text](./images/5.png)

Create users `ro` and `scores`. `ro` user can only read the database data, and `scores	` user can also update students' scores.

![alt text](./images/6.png)

Connected as `ro` user:

![alt text](./images/7.png)

Connected as `scores` user:

![alt text](./images/8.png)

A selection from `db` table of `mysql` database:

![alt text](./images/9.png)

## Part 2. Backup, RDS AWS

### Backup

Create [a backup](./uni.sql) of the database:

![alt text](./images/10.png)

Drop a table and restore the database:

![alt text](./images/11.png)

Check if the `scores` table is fine:

![alt text](./images/12.png)

### RDS AWS

A database on RDS AWS:

![alt text](./images/13.png)

Create `uni` database on RDS AWS and transfer the database there:

![alt text](./images/14.png)

A query similar to the previous part, but in RDS AWS:

![alt text](./images/15.png)

[A dump](./uni2.sql) of the database from RDS AWS:

![alt text](./images/16.png)

## Part 3. MongoDB

This task is quite easy and can be done in one screenshot:

![alt text](./images/mongodb.png)

- `use uni` - switches to the `uni` database;
- `db.createCollection('students')` - creates database `uni` since it wasn't created before; creates a new collection in the `uni` database;
- `show dbs` and `show collections` - shows databases and collections in the current database;
- `db.students.insertMany()` - adds new documents to the `students` collection;
- `db.students.find().pretty()` - shows documents in the `students` collection that match the filter (could also omit the filter to show all documents) and formats output for readability.
