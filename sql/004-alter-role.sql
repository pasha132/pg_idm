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
    rolpassword,
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
    rolpassword,
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
    rolpassword,
    to_char(rolvaliduntil, 'YYYY-MM-DD') as rolvaliduntil,
    rolbypassrls
from idm.roles
where rolname like 'test_role_%'
order by rolname;

-- set plain password
update idm.roles
set
    rolcanlogin = true,
    rolpassword = '1234'
where rolname = 'test_role_002';

select usename, passwd, ('md5' || md5('1234' || usename)) as manually_encrypted from pg_shadow where usename = 'test_role_002';

-- set encrypted password
update idm.roles
set
    rolcanlogin = true,
    rolpassword = ('md5' || md5('123456' || 'test_role_002'))
where rolname = 'test_role_002';

select usename, passwd, ('md5' || md5('123456' || usename)) as manually_encrypted from pg_shadow where usename = 'test_role_002';

-- reset password
update idm.roles
set
    rolcanlogin = true,
    rolpassword = null
where rolname = 'test_role_002';

select usename, passwd, null::text as manually_encrypted from pg_shadow where usename = 'test_role_002';

rollback;