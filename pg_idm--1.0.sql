-- complain if script is sourced in psql, rather than via create extension
\echo Use "create extension pg_idm" to load this file. \quit

create view @extschema@.roles as
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


create function @extschema@.create_role()
    returns trigger security invoker language plpgsql  as
$function$
declare
    options text := '';
    created_role_rec record;
begin
    if new.rolsuper is not null then
        options := format('%s %s', options, case when new.rolsuper then 'superuser' else 'nosuperuser' end);
    end if;
    if new.rolinherit is not null then
        options := format('%s %s', options, case when new.rolinherit then 'inherit' else 'noinherit' end);
    end if;
    if new.rolcreaterole is not null then
        options := format('%s %s', options, case when new.rolcreaterole then 'createrole' else 'nocreaterole' end);
    end if;
    if new.rolcreatedb is not null then
        options := format('%s %s', options, case when new.rolcreatedb then 'createdb' else 'nocreatedb' end);
    end if;
    if new.rolcanlogin is not null then
        options := format('%s %s', options, case when new.rolcanlogin then 'login' else 'nologin' end);
    end if;
    if new.rolreplication is not null then
        options := format('%s %s', options, case when new.rolreplication then 'replication' else 'noreplication' end);
    end if;
    if new.rolconnlimit is not null then
        options := format('%s connection limit %s', options, new.rolconnlimit);
    end if;
    if new.rolvaliduntil is not null then
        options := format('%s valid until %L', options, new.rolvaliduntil);
    end if;
    if new.rolbypassrls is not null then
        options := format('%s %s', options, case when new.rolbypassrls then 'bypassrls' else 'nobypassrls' end);
    end if;

    execute format('create role %I with %s', new.rolname, options);

    select * into created_role_rec from @extschema@.roles r where r.rolname = NEW.rolname;
    return created_role_rec;
end;
$function$;


create trigger create_role_trg instead of insert on @extschema@.roles
    for each row execute procedure @extschema@.create_role();


create function @extschema@.drop_role()
    returns trigger security invoker language plpgsql as
$function$
declare 
    role_rec record;
begin
    select * into role_rec from @extschema@.roles r where r.rolname = OLD.rolname;
    if role_rec.rolname is not null then
        execute format('drop role %I', role_rec.rolname);
        return role_rec;
    else 
        return null;
    end if;
end;
$function$;


create trigger drop_role_trg instead of delete on @extschema@.roles
    for each row execute procedure @extschema@.drop_role();