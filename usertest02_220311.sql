select * from scott.dept;

INSERT INTO SCOTT.dept(DEPTNO,DNAME,LOC)
    VALUES(50,'KIM','SEOUL');

update scott.dept
set dname = 'KIM'
where deptno = 50;

DELETE
from scott.dept
where deptno=50;

commit; --> Ŀ���ؾ� ���� �����Ϳ��� �����Ǿ� ��������.