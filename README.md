# pg_idm

Lightweight PostgreSQL extension for DML-like role management. PostgreSQL 9.6+

## Usage

### Create role

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
