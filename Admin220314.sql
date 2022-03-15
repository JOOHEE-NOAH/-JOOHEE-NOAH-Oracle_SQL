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

-- 1. Directory ����   ---> mdBackup7 (��ġ : c:\orabackup )
CREATE OR Replace Directory mdBackup7 as 'c:\orabackup';
-- 2. USER            ----> scott7(Create Table Emp_Dept����)
 CREATE USER scott7 Identified By tiger;
 Grant DBA TO scott7;
-- 3. Backup          ----> DUMPFILE=scott7.dmp
--3-1  scott7���� mdBackup2 Read,Write  ���� �㰡 
GRANT Read,Write On Directory mdBackup7 To scott7;
-- Oracle ��ü Backup  (scott7) Console
C:\orabackup> 
EXPDP scott7/tiger Directory=mdBackup7 DUMPFILE=scott7.dmp
-- 4. ���� TBL         ----> 2�� �̻� TBL ����
-- 5. ���� ���� TBL ���� 

-- Oracle ��ü Restore  (scott7)
C:\orabackup> 
IMPDP scott7/tiger Directory=mdBackup7 DUMPFILE=scott7.dmp

-------------------------------------------------
-----   �κ� Backup ���� 2
--------------------------------------------------
-- 1. USER            ----> scott7(Create Table Emp_Dept����)
-- Oracle �κ� Backup (scott7)    ----> professor Table
C:\orabackup> 
exp scott7/tiger   file=professor.dmp   tables=professor
-- 3. ���� TBL ����  ���� 
-- Oracle �κ� Restore  (scott7)
C:\orabackup> 
imp scott7/tiger file=professor.dmp    tables=professor
