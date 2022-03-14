--------------------------------------------
------- Tablespace  --------------
--------------------------------------------
--1. TableSpace ���� : ����̺� C�� ���� ���� ������ ����
CREATE TABLESPACE user1 Datafile 'C:\tableSpace\user1.ora' SIZE 100M;
CREATE TABLESPACE user2 Datafile 'C:\tableSpace\user2.ora' SIZE 100M;
CREATE TABLESPACE user3 Datafile 'C:\tableSpace\user3.ora' SIZE 100M;
CREATE TABLESPACE user4 Datafile 'C:\tableSpace\user4.ora' SIZE 100M;

--2. usertest03 �����ϸ� TableSpace user1 Mapping

drop user usertest03;
CREATE USER usertest03 IDENTIFIED BY tiger
DEFAULT Tablespace user1;

grant dba to usertest03;


---------------------------------------------------
---  Backup ����
---------------------------------------------------
--1. Directory ����
create or replace directory mdBackup2 as 'C:\orabackup';


--2. Backup test ����
Drop User scott3;
CREATE USER scott3 IDENTIFIED BY tiger;
grant dba to scott3;

--3  scott3���� mdBackup2 Read,Write  ���� �㰡
grant read,write on directory mdBackup2 to scott3;

--cmd -> C:\Users\joohe>cd c:\orabackup -> c:\orabackup>dir ->
-- Oracle ��ü Backup  (scott3) -->c:\orabackup>EXPDP scott3/tiger Directory=mdbackup2 DUMPFILE=scott3.dmp
C:\orabackup>
EXPDP scott3/tiger Directory=mdBackup2 DUMPFILE=scott3.dmp

-- Oracle ��ü Restore  (scott3) --> ������ ���̺� �ٽ� ������Ŵ (�ش� ���̺��� ������ �� �� �����Ѱ� �������ѷ��� �ƿ� ���̺� �����ߴ� ��ü restore �ؾ���.)
C:\orabackup>
IMPDP scott3/tiger Directory=mdBackup2 DUMPFILE=scott3.dmp

--------------------------------------------------
---  Backup ���� ����
---------------------------------------------------
--1. Directory ����  -->mdBackup7 (��ġ :  c:\orabackup)
--2. USER              --> scott7(Create Table Emp_Dept����)
--3.Backup            --> DUMPFILE=SCOTT7.dmp
--4.���� TBL          -->2�� �̻� TBL ����
--5.���� ���� TBL ����


-- Oracle �κ� Backup��  �κ� Restore  (scott3) -->department �� �κ������� ���
C:\orabackup>
exp scott3/tiger file=department.dmp tables=department
exp: export ����

-- Oracle �κ� Restore  (scott3)
C:\orabackup>
imp scott3/tiger file=department.dmp tables=department
imp: import ����

-------------------------------------------------
-----   �κ� Backup ���� 2
--------------------------------------------------
-- 1. USER            ----> scott7(Create Table Emp_Dept����)
-- 2. Backup          ----> professor Table
-- 3. ���� TBL ����  ����
