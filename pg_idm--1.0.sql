-- complain if script is sourced in psql, rather than via create extension
\echo Use "create extension pg_idm" to load this file. \quit

set local search_path to @extschema@;

create view roles as
select
    r.oid,
    r.rolname,
    r.rolsuper,
    r.rolinherit,
    r.rolcreaterole,
    r.rolcreatedb,
    r.rolcanlogin,
    r.rolreplication,
    r.rolconnlimit,
    r.rolvaliduntil,
    r.rolbypassrls
from pg_catalog.pg_roles r;


create function create_role()
    returns trigger security invoker language plpgsql  as
$function$
declare
    create_role_stmt text;
    created_role_rec record;
begin
    select 
        format('create role %I with ', new.rolname) || 
            string_agg(case when o.value then o.enabled when not o.value then o.disabled else o."default" end, ' ')
    into create_role_stmt
    from (
        values 
            ('superuser',  'nosuperuser', 'nosuperuser',  new.rolsuper),
            ('createdb',   'nocreatedb',  'nocreatedb',   new.rolcreatedb),
            ('createrole', 'nocreaterole', 'nocreaterole', new.rolcreaterole)
    ) o (enabled, disabled, "default", value);

    execute create_role_stmt;

    select * into created_role_rec from @extschema@.roles r where r.rolname = NEW.rolname;

    return created_role_rec;
end;
$function$;


create trigger create_role_trg instead of insert on roles
    for each row execute procedure create_role();

