create user dragon identified by ftn
	default tablespace USERS temporary tablespace TEMP;


	grant connect, resource to dragon;

	grant create table to dragon;

	grant create view to dragon;

	grant create procedure to dragon;

	grant create synonym to dragon;

	grant create sequence to dragon;

	grant select on dba_rollback_segs to dragon;

	grant select on dba_segments to dragon;

	grant unlimited tablespace to dragon;