begin;

insert into idm.roles (rolname) values ('test_role_001');
update idm.roles set rolname = 'test_role_002' where rolname = 'test_role_001';

select
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin,
    rolreplication,
    rolconnlimit,
    to_char(rolvaliduntil, 'YYYY-MM-DD') as rolvaliduntil,
    rolbypassrls
from idm.roles
where rolname like 'test_role_%'
order by rolname;

update idm.roles
set
    rolsuper = true,
    rolinherit = false,
    rolcreaterole = true,
    rolcreatedb = true,
    rolcanlogin = true,
    rolreplication = true,
    rolconnlimit = 10,
    rolvaliduntil = to_timestamp('2000-01-01', 'YYYY-MM-DD'),
    rolbypassrls = true
where rolname = 'test_role_002';

select
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin,
    rolreplication,
    rolconnlimit,
    to_char(rolvaliduntil, 'YYYY-MM-DD') as rolvaliduntil,
    rolbypassrls
from idm.roles
where rolname like 'test_role_%'
order by rolname;

update idm.roles
set
    rolconnlimit = -1,
    rolvaliduntil = null
where rolname = 'test_role_002';

select
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin,
    rolreplication,
    rolconnlimit,
    to_char(rolvaliduntil, 'YYYY-MM-DD') as rolvaliduntil,
    rolbypassrls
from idm.roles
where rolname like 'test_role_%'
order by rolname;

rollback;