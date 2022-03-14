
-----------------------------------------------
---   Admin 사용자 생성 /권한 부여
------------------------------------------------
-- 1-1. USER 생성
drop user usertest01;
create user usertest01 IDENTIFIED BY tiger;

--2-1. session 권한부여
grant create session to usertest01;

grant create session , create table, create view to usertest01;

-- 2-2. 현장에서 DBA가  개발자 권한 부여
grant connect, resource to usertest01;

--타 계정 조회가능
select * from scott.emp;

--usertest01 SELECT 권한 부여
GRANT SELECT on scott.emp TO usertest01;
GRANT update on scott.emp TO usertest01;

-----------  과제    -----------------
--1. usertest02 생성
drop user usertest02;
create user usertest02 IDENTIFIED BY tiger;
grant create session to usertest02;

--2. 권한을 주어가며  scott의 dept Table권한을 주며 수행( 한 번은 되고 , 한번은 안 되게)
grant create table, create view to usertest02;
--실제로는 권한을 이렇게 줌. ★★★★★ 현장에서 DBA가 개발자 권한 부여, Resource -> RBAC의 Role임. 
grant connect, resource to usertest02;

--3. Insert / Update /Select /Delete
grant insert on scott.dept to usertest02;

grant update on scott.dept to usertest02;

grant select on scott.dept to usertest02;

grant delete on scott.dept to usertest02;