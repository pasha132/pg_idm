begin;

insert into idm.roles (rolname) values ('test_role_001_without_options');
insert into idm.roles (rolname, rolsuper) values ('test_role_002_with_superuser', true);
insert into idm.roles (rolname, rolcreatedb) values ('test_role_003_with_createdb', true);

select
    rolname,
    rolsuper,
    rolinherit,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin,
    rolreplication,
    rolconnlimit,
    rolvaliduntil,
    rolbypassrls
from idm.roles
where rolname like 'test_role_%'
order by rolname;

rollback;
