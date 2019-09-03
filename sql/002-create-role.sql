begin;

insert into idm.roles (rolname) values ('test_role_001_without_options');
insert into idm.roles (rolname, rolsuper) values ('test_role_002_with_superuser', true);
insert into idm.roles (rolname, rolcreatedb) values ('test_role_003_with_createdb', true);
insert into idm.roles (rolname, rolinherit) values ('test_role_004_with_inherit', true);
insert into idm.roles (rolname, rolcanlogin) values ('test_role_005_with_login', true);
insert into idm.roles (rolname, rolreplication) values ('test_role_006_with_replication', true);
insert into idm.roles (rolname, rolconnlimit) values ('test_role_007_with_connlimit', 1);
insert into idm.roles (rolname, rolvaliduntil) values ('test_role_008_with_validuntil', to_timestamp('2000-01-01', 'YYYY-MM-DD'));
insert into idm.roles (rolname, rolbypassrls) values ('test_role_009_with_bypassrls', true);
insert into idm.roles (rolname, rolsuper, rolcanlogin, rolconnlimit) values ('test_role_010_with_mixed', true, true, 10);
insert into idm.roles (rolname, rolcanlogin, rolpassword) values ('test_role_011_with_plain_password', true, '1234');
insert into idm.roles (rolname, rolcanlogin, rolpassword)
values ('test_role_012_with_encrypted_password', true, ('md5' || md5('1234' || 'test_role_012_with_encrypted_password')));

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

select usename, passwd, ('md5' || md5('1234' || usename)) as manually_encrypted
from pg_shadow
where usename like 'test_role_%_password'
order by usename;

with w_inserted as (
    insert into idm.roles (rolname, rolsuper, rolcanlogin, rolconnlimit)
    values ('test_role_011_returning', true, true, 10)
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
from w_inserted;

rollback;
