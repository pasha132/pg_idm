begin;

insert into idm.roles (rolname) values ('test_role_001');
insert into idm.roles (rolname) values ('test_role_002');

select
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin,
    rolreplication,
    rolconnlimit,
    rolpassword,
    to_char(rolvaliduntil, 'YYYY-MM-DD') as rolvaliduntil,
    rolbypassrls
from idm.roles
where rolname like 'test_role_%'
order by rolname;

delete from idm.roles where rolname = 'test_role_001';

select
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin,
    rolreplication,
    rolconnlimit,
    rolpassword,
    to_char(rolvaliduntil, 'YYYY-MM-DD') as rolvaliduntil,
    rolbypassrls
from idm.roles
where rolname like 'test_role_%'
order by rolname;

with w_deleted as (
    delete from idm.roles where rolname = 'test_role_002'
    returning *
)
select
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin,
    rolreplication,
    rolconnlimit,
    rolpassword,
    to_char(rolvaliduntil, 'YYYY-MM-DD') as rolvaliduntil,
    rolbypassrls
from w_deleted;

delete from idm.roles where rolname = 'test_role_002';

rollback;
