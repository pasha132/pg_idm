# pg_idm

Lightweight PostgreSQL extension for DML-like role management. PostgreSQL 9.6+

## Usage

First, you have to install the extension in the database:
```sql
create schema idm;
create extension pg_idm with schema idm;
```
We strongly recommend you to specify dedicated schema for extension in order to avoid name collisions 

### Examples

#### List existing roles
To review list of existing roles just type:
```sql
select * from idm.roles order by rolname asc;
 oid  |       rolname        | rolsuper | rolinherit | rolcreaterole | rolcreatedb | rolcanlogin | rolreplication | rolconnlimit | rolvaliduntil | rolbypassrls 
------+----------------------+----------+------------+---------------+-------------+-------------+----------------+--------------+---------------+--------------
 3373 | pg_monitor           | f        | t          | f             | f           | f           | f              |           -1 |               | f
 3374 | pg_read_all_settings | f        | t          | f             | f           | f           | f              |           -1 |               | f
 3375 | pg_read_all_stats    | f        | t          | f             | f           | f           | f              |           -1 |               | f
 4200 | pg_signal_backend    | f        | t          | f             | f           | f           | f              |           -1 |               | f
 3377 | pg_stat_scan_tables  | f        | t          | f             | f           | f           | f              |           -1 |               | f
   10 | postgres             | t        | t          | t             | t           | t           | t              |           -1 |               | t
(6 rows)
```

#### Create role
Adding new role is simple insert statement:
```sql
insert into idm.roles (rolname) values ('new_role') returning *;
  oid  | rolname  | rolsuper | rolinherit | rolcreaterole | rolcreatedb | rolcanlogin | rolreplication | rolconnlimit | rolvaliduntil | rolbypassrls 
-------+----------+----------+------------+---------------+-------------+-------------+----------------+--------------+---------------+--------------
 18526 | new_role | f        | t          | f             | f           | f           | f              |           -1 |               | f
(1 row)

INSERT 0 1
```
For omitted role attributes default value is used ([see documentation for more details](https://www.postgresql.org/docs/current/sql-createrole.html))

#### Drop role
To drop role use delete statement:
```sql
delete from idm.roles where rolname = 'new_role' returning *;
  oid  | rolname  | rolsuper | rolinherit | rolcreaterole | rolcreatedb | rolcanlogin | rolreplication | rolconnlimit | rolvaliduntil | rolbypassrls 
-------+----------+----------+------------+---------------+-------------+-------------+----------------+--------------+---------------+--------------
 18526 | new_role | f        | t          | f             | f           | f           | f              |           -1 |               | f
(1 row)

DELETE 1

select * from idm.roles order by rolname asc;
 oid  |       rolname        | rolsuper | rolinherit | rolcreaterole | rolcreatedb | rolcanlogin | rolreplication | rolconnlimit | rolvaliduntil | rolbypassrls 
------+----------------------+----------+------------+---------------+-------------+-------------+----------------+--------------+---------------+--------------
 3373 | pg_monitor           | f        | t          | f             | f           | f           | f              |           -1 |               | f
 3374 | pg_read_all_settings | f        | t          | f             | f           | f           | f              |           -1 |               | f
 3375 | pg_read_all_stats    | f        | t          | f             | f           | f           | f              |           -1 |               | f
 4200 | pg_signal_backend    | f        | t          | f             | f           | f           | f              |           -1 |               | f
 3377 | pg_stat_scan_tables  | f        | t          | f             | f           | f           | f              |           -1 |               | f
   10 | postgres             | t        | t          | t             | t           | t           | t              |           -1 |               | t
(6 rows)
```

#### Alter role
To alter role use update statement:
```sql
insert into idm.roles (rolname) values ('new_role') returning *;
  oid  | rolname  | rolsuper | rolinherit | rolcreaterole | rolcreatedb | rolcanlogin | rolreplication | rolconnlimit | rolvaliduntil | rolbypassrls 
-------+----------+----------+------------+---------------+-------------+-------------+----------------+--------------+---------------+--------------
 19582 | new_role | f        | t          | f             | f           | f           | f              |           -1 |               | f
(1 row)

INSERT 0 1
update idm.roles set rolconnlimit = 10, rolcanlogin = true where rolname = 'new_role' returning *;
  oid  | rolname  | rolsuper | rolinherit | rolcreaterole | rolcreatedb | rolcanlogin | rolreplication | rolconnlimit | rolvaliduntil | rolbypassrls 
-------+----------+----------+------------+---------------+-------------+-------------+----------------+--------------+---------------+--------------
 19582 | new_role | f        | t          | f             | f           | t           | f              |           10 |               | f
(1 row)

UPDATE 1
```

## Installation

Make sure the PostgreSQL extension building infrastructure is installed. If you installed PostgreSQL with installation packages, you usually need to install the "development"-Package.

Make sure that `pg_config` is on your `PATH`. Then type:
```shell script
make install
```

To verify installation run regression tests:
```shell script
make installcheck
```

Then connect to the database where you want to run `pg_idm` and use:
```sql
create schema idm;
create extension pg_idm with schema idm;
```
