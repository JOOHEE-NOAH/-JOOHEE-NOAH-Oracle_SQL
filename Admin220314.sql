--------------------------------------------
------- Tablespace  --------------
--------------------------------------------
--1. TableSpace 생성 : 드라이브 C에 먼저 폴더 생성후 실행
CREATE TABLESPACE user1 Datafile 'C:\tableSpace\user1.ora' SIZE 100M;
CREATE TABLESPACE user2 Datafile 'C:\tableSpace\user2.ora' SIZE 100M;
CREATE TABLESPACE user3 Datafile 'C:\tableSpace\user3.ora' SIZE 100M;
CREATE TABLESPACE user4 Datafile 'C:\tableSpace\user4.ora' SIZE 100M;

--2. usertest03 생성하며 TableSpace user1 Mapping

drop user usertest03;
CREATE USER usertest03 IDENTIFIED BY tiger
DEFAULT Tablespace user1;

grant dba to usertest03;


---------------------------------------------------
---  Backup 관리
---------------------------------------------------
--1. Directory 생성
create or replace directory mdBackup2 as 'C:\orabackup';


--2. Backup test 계정
Drop User scott3;
CREATE USER scott3 IDENTIFIED BY tiger;
grant dba to scott3;

--3  scott3에게 mdBackup2 Read,Write  권한 허가
grant read,write on directory mdBackup2 to scott3;

--cmd -> C:\Users\joohe>cd c:\orabackup -> c:\orabackup>dir ->
-- Oracle 전체 Backup  (scott3) -->c:\orabackup>EXPDP scott3/tiger Directory=mdbackup2 DUMPFILE=scott3.dmp
C:\orabackup>
EXPDP scott3/tiger Directory=mdBackup2 DUMPFILE=scott3.dmp

-- Oracle 전체 Restore  (scott3) --> 삭제한 테이블 다시 복원시킴 (해당 테이블의 데이터 몇 행 삭제한거 복원시켜려면 아예 테이블 삭제했다 전체 restore 해야함.)
C:\orabackup>
IMPDP scott3/tiger Directory=mdBackup2 DUMPFILE=scott3.dmp

-- 1. Directory 생성   ---> mdBackup7 (위치 : c:\orabackup )
CREATE OR Replace Directory mdBackup7 as 'c:\orabackup';
-- 2. USER            ----> scott7(Create Table Emp_Dept생성)
 CREATE USER scott7 Identified By tiger;
 Grant DBA TO scott7;
-- 3. Backup          ----> DUMPFILE=scott7.dmp
--3-1  scott7에게 mdBackup2 Read,Write  권한 허가 
GRANT Read,Write On Directory mdBackup7 To scott7;
-- Oracle 전체 Backup  (scott7) Console
C:\orabackup> 
EXPDP scott7/tiger Directory=mdBackup7 DUMPFILE=scott7.dmp
-- 4. 관련 TBL         ----> 2개 이상 TBL 삭제
-- 5. 관련 삭제 TBL 복원 

-- Oracle 전체 Restore  (scott7)
C:\orabackup> 
IMPDP scott7/tiger Directory=mdBackup7 DUMPFILE=scott7.dmp

-------------------------------------------------
-----   부분 Backup 과제 2
--------------------------------------------------
-- 1. USER            ----> scott7(Create Table Emp_Dept생성)
-- Oracle 부분 Backup (scott7)    ----> professor Table
C:\orabackup> 
exp scott7/tiger   file=professor.dmp   tables=professor
-- 3. 관련 TBL 삭제  복원 
-- Oracle 부분 Restore  (scott7)
C:\orabackup> 
imp scott7/tiger file=professor.dmp    tables=professor
