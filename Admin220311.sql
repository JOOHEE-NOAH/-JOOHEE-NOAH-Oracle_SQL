
-----------------------------------------------
---   Admin ����� ���� /���� �ο�
------------------------------------------------
-- 1-1. USER ����
drop user usertest01;
create user usertest01 IDENTIFIED BY tiger;

--2-1. session ���Ѻο�
grant create session to usertest01;

grant create session , create table, create view to usertest01;

-- 2-2. ���忡�� DBA��  ������ ���� �ο�
grant connect, resource to usertest01;

--Ÿ ���� ��ȸ����
select * from scott.emp;

--usertest01 SELECT ���� �ο�
GRANT SELECT on scott.emp TO usertest01;
GRANT update on scott.emp TO usertest01;

-----------  ����    -----------------
--1. usertest02 ����
create user usertest02 IDENTIFIED BY tiger;
grant create session to usertest02;
--2. ������ �־��  scott�� dept Table������ �ָ� ����( �� ���� �ǰ� , �ѹ��� �� �ǰ�)
grant create table, create view to usertest02;
grant connect, resource to usertest02;
select * from scott.dept;
--3. Insert / Update /Select /Delete
