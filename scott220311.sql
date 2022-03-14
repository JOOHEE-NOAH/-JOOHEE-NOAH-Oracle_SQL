----------------------------------------------------------------------------
------------------      �������� (constraint)   -------------------------------
----------------------------------------------------------------------------
create table subject(
    subno        number(5)      constraint subject_no_pk        primary key,
    subname      varchar2(20)   constraint subject_name_nn      not null,
    term         varchar2(1)    constraint subject_term_ck      check(term in('1','2'))
); -- term = 1 or term = 2

--Success
insert into subject (subno, subname, term)
            values(10000,'�����а���','1');       
insert into subject (subno, subname, term)--> subname�� term�� ������ subno�̶�� pk�� �ߺ����� �ʾ� ����.
            values(10001,'�����а���','1');

-- Fail 1-->unique constraint (SCOTT.SUBJECT_NO_PK) violated ������ ����
insert into subject (subno, subname, term)
            values(10000,'�����а���2','2');
-- Fail 2-->cannot insert NULL into ("SCOTT"."SUBJECT"."SUBNAME") not null ����
insert into subject (subno, term)
            values(10000,'1');
-- Fail 3-->check constraint (SCOTT.SUBJECT_TERM_CK) violated 
insert into subject (subno, subname, term)
            values(10003,'�����а���','3');
            
--�������� (Constraint) ������ �߰� �߰� ���
alter table student
add constraint stud_idnum_uk unique(idnum);

alter table student
modify (name constraint stud_name_nn not null);

--constraint ��ȸ
select CONSTRAINT_name, CONSTRAINT_Type
from user_CONSTRAINTs
where table_name in ('SUBJECT', 'STUDNET');


----------------------------------------------------------------------------
------------------      INDEX   -------------------------------
----------------------------------------------------------------------------
-- 1. Emp--> ename Index
create index idx_emp_name on emp(ename);
--2. index ��ȸ
select index_name , table_name, column_name
from user_ind_columns;
--3. ��ȸ
select * from emp where ename = 'SMITH';

--- Optimizer
--- 1) RBO(rule based optimizer): ������ ��Ģ��θ� ����  2) CBO(cost based optimizer)
--RBO ����
ALTER SESSION SET OPTIMIZER_MODE=RULE;

-- CBO ����
ALTER SESSION SET OPTIMIZER_MODE=CHOOSE;

-- ���� Index
CREATE UNIQUE INDEX IDX_DEPT_DNO ON dept_second(deptno);

--���� index
create index IDX_DEPT_COM ON dept_second(dname, loc);


-- stud_101���̺��� deptno�� name Į������ ���� �ε����� �����Ͽ���.
-- ��, deptno Į���� ������������ name Į���� ������������ �����Ͽ���.
--idx_stud101_no_name (index ��)
create index idx_stud101_no_name ON stud_101(deptno DESC, name ASC);

-- -- FBI (Funtion Based Index) �Լ��� �ε��� �����
create index IDX_EMP_ANNSAL
ON emp(sal*12+NVL(comm,0));

-------------------------------------
-----       ����           -----------
-------------------------------------
-- 1. �μ� ���̺�[department]���� dname Į���� ���� �ε����� �����Ͽ���. 
--    ��  , ���� �ε����� �̸��� idx_dept_name���� ����
create unique index idx_dept_name on department(dname);
-- 2.�л� ���̺�[student]�� birthdate Į���� ����� �ε����� ����.
-- ����� �ε����� �̸��� idx_stud_birthdate�� ����
CREATE INDEX idx_stud_birthdate ON student(birthdate);
-- 3.�л� ���̺�[stud_101]�� deptno, grade Į���� ���� �ε����� ����.
-- ���� �ε����� �̸��� idx_stud101_dno_grade �� ����
create index idx_stud101_dno_grade ON stud_101(deptno, grade);
-- 4. emp20 �� ename�� �빮�ڷ� FBI, �ε����� �̸��� emp20_uppercase_idx
create index emp20_uppercase_idx ON emp20(upper(ename));

select * from emp20 where upper(ename) ='SMITH';

-- �л� ���̺� ������ PK_STUDNO �ε����� �籸�� / REBUILD �ϸ� ������ �ξ� ������
ALTER INDEX PK_STUDNO REBUILD;

--�л� ���̺� ������ fidx_stud_no_name �ε����� �����Ͽ���
DROP INDEX fidx_stud_no_name;

-----------------------------------------------------------------------------------------
--   11. View 
------------------------------------------------------------------------------
-- View : �ϳ� �̻��� �⺻ ���̺��̳� �ٸ� �並 �̿��Ͽ� �����Ǵ� ���� ���̺�
--        ��� �����͵�ųʸ� ���̺� �信 ���� ���Ǹ� ����
--        Performance(����)�� �� ���� 
--        ���� : ����

create or replace view VIEW_PROFESSOR AS
SELECT profno, name, userid, position, hiredate, sal, deptno
from professor;

--view ����
drop view VIEW_PROFESSOR;

-- select
select * from VIEW_PROFESSOR;

-- userid ���� --> �����
create or replace view VIEW_PROFESSOR AS
SELECT profno, name, position, hiredate, deptno
from professor;

select * from VIEW_PROFESSOR;

--��(������ �÷���θ� ����)�� insert �ص� �������� �����ʹ� �������� ���̺�(�������̺�)�� ���� 
insert into VIEW_PROFESSOR values(2000, 'view', 'userid', 'position', sysdate, 101);

--�������� ����(sal>180) sal:170 -->check constraint (SCOTT.PROFESSOR_CHK1) violated
insert into VIEW_PROFESSOR values(2010, 'view', 'userid', 'position', sysdate, 170, 101);


--------------   VIEW v_emp_sample
--------------   �ش� column  : empno , ename , job, mgr,deptno  (emp)
create or replace VIEW v_emp_sample 
AS
SELECT empno , ename , job, mgr, deptno
from emp;

create or replace VIEW v_emp_complex 
AS
SELECT *
from emp natural join dept; --equi ���ΰ� ����

---��1)  �л� ���̺��� 101�� �а� �л����� �й�, �̸�, �а� ��ȣ�� ���ǵǴ� �ܼ� �並 ����
---     �� �� :  v_stud_dept101
create or replace view v_stud_dept101 
as
select studno, name, deptno
from student
where deptno=101;

--��2) �л� ���̺�� �μ� ���̺��� �����Ͽ� 102�� �а� �л����� �й�, �̸�, �г�, �а� �̸����� ���ǵǴ� ���� �並 ����
--      �� �� :   v_stud_dept102
create or replace VIEW v_stud_dept102 
AS
SELECT studno, name, grade, dname
from student natural join department 
where deptno=102; natural ���� ���

create or replace VIEW v_stud_dept102 
AS
SELECT s.studno, s.name, s.grade, d.dname
from student s, department d
where s.deptno=d.deptno
and s.deptno=102; --equi ���� ���

--��3)  ���� ���̺��� �а��� ��� �޿���     �Ѱ�� ���ǵǴ� �並 ����
--  �� �� :  v_prof_avg_sal       Column �� :   avg_sal      sum_sal
create or replace VIEW v_prof_avg_sal
AS
select deptno, round(avg(sal)) avg_sal, sum(sal) sum_sal
from professor
group by deptno;
 
