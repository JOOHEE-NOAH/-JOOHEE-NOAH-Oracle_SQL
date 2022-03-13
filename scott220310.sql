----------------------------
--  DML
-----------------------------
-- Insert /update / delete / select
INSERT INTO DEPT VALUES(10,'�λ�','�̴�'); -- ���� �־ ������� �˾Ƽ� ��︶ (�� ������� �ۼ��ؾ���)
INSERT INTO DEPT VALUES(11,'�λ�','�̴�');
INSERT INTO DEPT (deptno, dname, loc)
            values (51, 'ȸ����','������');
            ---pk null --> ����
INSERT INTO DEPT (dname, loc)
values ('ȸ����','������');
-- column �Ϻ� ����
INSERT INTO DEPT (deptno, dname)
values (12, '�濵��');
commit;

INSERT INTO professor (profno, name, position, hiredate, deptno)
VALUES (9920 , '������','������', TO_DATE('2006/01/01','yyyy/mm/dd'), 102);
INSERT INTO professor (profno, name, position, hiredate, deptno)
VALUES (9910 , '��̼�','���Ӱ���', sysdate, 101);

--table ����
CREATE TABLE JOB3
( JOBNo     VARCHAR2(2)     PRIMARY KEY,
  JOBNAME   VARCHAR2(20)
);
-- Jobno jobname
--11, '������'
--12, '�����'
INSERT INTO JOB3 (jobno, jobname)
VALUES (11, '������');
INSERT INTO JOB3 (jobno, jobname)
VALUES (12, '�����');
INSERT INTO JOB3 VALUES (13, '����');
INSERT INTO JOB3 VALUES (14, '�߼ұ��');
INSERT INTO JOB3 VALUES (10, '�б�');

CREATE TABLE Religion
( ReligionNo     VARCHAR2(2)     CONSTRAINT PK_ReligionNo3 PRIMARY KEY,
  ReligionName   VARCHAR2(20)
);
-- ReligionNo  ReligionName
-- 10,          '�⵶��'
-- 20,          'ī�縯��'
-- 30,          '�ұ�'

INSERT INTO Religion (religionno, religionname)
VALUES (10, '�⵶��');
INSERT INTO Religion VALUES (20, 'ī�縯��');
INSERT INTO Religion VALUES (30, '�ұ�');
INSERT INTO Religion VALUES (40, '����');

-------------------------------------------------
--���� �� �Է�
--------------------------------
-- 1. ������ TBL�̿� �ű� TBL ����
--������ �״�� ������. ��� ��Ű���� �� ������ �ְ� ���������� ������ �ȵ�

create table dept_second
as
select * from dept;


-- 2. TBL ���� ����
create table emp20
as select empno, ename, sal*12 annsal
    from emp
    where deptno = 20;
    
-- 3. TBL ������ (������ ���� x)
create table dept30
as select deptno, dname
    from dept
    where 0=1;

-- 4. Column �߰� Alter add
alter table dept30
add(birth Date);

--5 Column ���� Alter modify
alter table dept30
modify dname varchar(20);

--6 Column ���� alter  drop
alter table dept30
drop column birth;

--7. TBL �� ���� rename to
rename dept30 to dept35;

--8. TBL ���� drop table : ������ü�� ����
drop table dept35;

--9. Truncate (ddl: �����Ŵ�� ���ÿ� Ŀ�� ���� �ѹ� �ȵ�) �߸�. --> ������ �ְ� �����ʹ� ������
truncate table dept_second;

rollback;

--table ����--->height_info / weight_info
create table height_info
( studNo        number(5),
  Name          varchar2(20),
  height        number(5,2)
);
create table weight_info
( studNo        number(5),
  Name          varchar2(20),
  weight        number(5,2)
);

insert all
into height_info values(studno, name, height)
into weight_info values(studno, name, weight)
select studno, name, height, weight
from student
where grade >= '2';

delete height_info;
delete weight_info;

-- �л� ���̺��� 2�г� �̻��� �л��� �˻��Ͽ� 
-- height_info ���̺��� Ű�� 170���� ū �л��� �й�, �̸�, Ű�� �Է�
-- weight_info ���̺��� �����԰� 70���� ū �л��� �й�, �̸�, �����Ը� 
-- ���� �Է��Ͽ���
insert all
when height > 170 then
     into height_info values(studno, name, height)
when weight > 70 then
     into weight_info values(studno, name, weight)
select studno, name, height, weight
from student
where grade>='2';

--- Update 
-- ���� ��ȣ�� 9903�� ������ ���� ������ ���α������� �����Ͽ���
update professor
set position ='�α���'
where profno = 9903;

-- ���������� �̿��Ͽ� �й��� 10201�� �л��� �г�� �а� ��ȣ��
-- 10103 �й� �л��� �г�� �а� ��ȣ�� �����ϰ� �����Ͽ���
update student
set (grade, deptno) = (select grade, deptno
                       from student
                       where studno = 10103
                       )
where studno = 10201;

-- �л� ���̺��� �й��� 20103�� �л��� �����͸� ����
delete
from student
where studno = 20103;

-- �л� ���̺��� ��ǻ�Ͱ��а��� �Ҽӵ� �л��� ��� �����Ͽ���.
delete student
where deptno=(select deptno
              from department
              where dname = '��ǻ�Ͱ��а�'
              );

rollback;

------------------------------------
---- MERGE
------------------------------------

create table professor_temp
as select * from professor
    where position = '����';
    
update professor_temp
set position = '������'
where position='����';

Insert into professor_temp
Values (9999,'�赵��','arom21','���Ӱ���',200,sysdate, 10, 101);

-- MERGE ����
-- ������ ���� �ΰ��� ���̺��� ���Ͽ� �ϳ��� ���̺�� ��ġ�� ���� ������ ���۾�
-- WHEN ���� ���������� ��� ���̺� �ش� ���� �����ϸ� UPDATE ��ɹ��� ���� ���ο� ������ ����,
-- �׷��� ������ INSERT ��ɹ����� ���ο� ���� ����
-- 2. ��Ȳ 
  -- 1) ������ �������� 2�� Update
  -- 2) �赵�� ���� �ű� Insert

--3. merge  
merge into professor p
using professor_temp f
on  (p.profno=f.profno)
when matched then --pk�� ������ ������ update
    update set p.position = f.position
when not matched then --pk�� ������ �ű� insert
    insert values(f.profno, f.name, f.userid, f.position, f.sal, f.hiredate, f.comm, f.deptno);
    
----------------------------------
-- SEQUENCE �ڡڡ�
---------------------------------
create sequence sample_seq
increment by 1
start with 1;

-- Data �������� ���� ��ȸ
select sequence_name, min_value, max_value, increment_by
from user_sequences;

select sample_seq.nextval from dual;
select sample_seq.currval from dual;

drop sequence dno_seq;
create sequence dno_seq
increment by 1
start with 1;

select dno_seq.nextval from dual;
select dno_seq.currval from dual; --CURRENT VALUE�� ����

insert into dept_second
values(dno_seq.nextval , 'Accounting', 'NEW YORK');
insert into dept_second
values((SELECT max(deptno)+1 from dept_second), 'Accounting', 'NEW YORK');

insert into dept_second
values(dno_seq.nextval , 'ȸ��' , '�̴�');

select dno_seq.currval from dual;

COMMENT ON COLUMN DEPT_SECOND.DNAME IS '�μ���';

----------------------------------
-- Table ����
---------------------------------
create table address
(   id      number(3),
    Name    varchar2(50),
    addr    varchar2(100),
    phone    varchar2(30),
    email    varchar2(100)

);

insert into address
values(1, 'HGDONG','SEOUL','123-4567', 'gdhong@naver.com');

create table addr_second(id, name, addr, phone, email)
    as select * from address;
create table addr_seven(id, name, addr, phone, email)
    as select * from address
    where '1'='2';

--�ּҷ� ���̺��� id, name �÷��� �����Ͽ� addr_third ���̺��� �����Ͽ���
create table addr_third
    as select id, name from address;
    
select table_name from user_tables;
select owner,table_name from all_tables;

-------------------------------------
---- DeadLock
-------------------------------------
-- Transaction   A : Smith
-- seq 1 �ڿ��Ҵ�
update emp
set sal=sal*1.1
where empno = 7369;
-- seq 3 ���μ���A
update emp
set sal=sal*1.1
where empno = 7839;

--transaction  B: King
-- seq 2 �ڿ��Ҵ�
update emp
set comm = 500
where empno = 7839;
-- seq 4 ���μ���B
update emp
set comm = 300
where empno = 7369;



