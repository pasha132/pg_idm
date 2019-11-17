begin;

create role test_group;
create role test_role;

insert into idm.auth_members (roleid, member)
values ('test_group'::regrole, 'test_role'::regrole);

select roleid::regrole::text, member::regrole::text, admin_option
from idm.auth_members where member = 'test_role'::regrole;

insert into idm.auth_members (roleid, member, admin_option)
values ('test_group'::regrole, 'test_role'::regrole, true);

select roleid::regrole::text, member::regrole::text, admin_option
from idm.auth_members where member = 'test_role'::regrole;

rollback;