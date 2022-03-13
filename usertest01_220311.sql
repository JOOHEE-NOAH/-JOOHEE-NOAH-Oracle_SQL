CREATE TABLE EMP5 
   (	"EMPNO" NUMBER(4,0), 
      "ENAME" VARCHAR2(10 BYTE), 
      "DEPTNO" NUMBER(2,0),
      "DEPTName" VARCHAR2(10 BYTE)
    );

select * from emp;
-- Admin에게 할당받은 이후 가능
select * from scott.emp;

update scott.emp
set comm = 500
where empno = 7369;