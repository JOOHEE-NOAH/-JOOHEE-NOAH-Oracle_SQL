select * from scott.dept;

INSERT INTO SCOTT.dept(DEPTNO,DNAME,LOC)
    VALUES(50,'KIM','SEOUL');

update scott.dept
set dname = 'KIM'
where deptno = 50;

DELETE
from scott.dept
where deptno=50;

commit; --> 커밋해야 실제 데이터에서 수정되어 보여진다.