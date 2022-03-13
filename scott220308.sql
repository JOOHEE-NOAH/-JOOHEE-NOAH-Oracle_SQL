----------------------------------------------------
---------------------CH09.JOIN----------------------
----------------------------------------------------
-- �й��� 10101�� �л��� �̸��� �Ҽ� �а� �̸��� ����Ͽ���
-- 1. �Ҽ��а� �˻�
SELECT studno, name, deptno
FROM student
WHERE studno = 10101;
-- 2. �а��� ������ �а��̸�
SELECT dname
FROM department
WHERE deptno = 101;
-- 1+2 ==> ������ �̿��� �л��̸��� �а��̸� �˻�
SELECT studno, name,
       student.deptno, department.dname
FROM student, department
WHERE student.deptno = department.deptno
;
--> = �յڿ� (+) �� ���°��� equi ����
-- �ָŸ�ȣ�� (ambiguously)
SELECT studno, name, deptno, dname
FROM student, department
WHERE student.deptno = department.deptno
;

-- �ָŸ�ȣ�� (ambiguously) �ذ�  --> ����(alias)�� �ٿ��� 
SELECT s.studno, s.name, d.deptno, d.dname
FROM student s, department d
WHERE s.deptno = d.deptno
;
-- �����ϡ� �л��� �й�, �̸�, �а� �̸� �׸��� �а� ��ġ�� ���
SELECT s.studno, s.name, d.dname, d.loc
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    s.name='������'
-- �����԰� 80kg�̻��� �л��� �й�, �̸�, ü��, �а� �̸�, �а���ġ�� ���
SELECT s.studno, s.name, s.weight, d.dname, d.loc
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    s.weight >= 80
-- īƼ�� �� �� �� �̻��� ���̺� ���� ���� ������ ���� ��� ����
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM student s, department d;
--īƼ�� �� = CROSS JOIN
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM student s CROSS JOIN department d;

-- Natural Join
SELECT s.studno, s.name, d.dname, d.loc, s.weight, deptno
FROM student s
     NATURAL JOIN department d;
-- EQUI JOIN = Inner Join
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM student s, department d
WHERE s.deptno = d.deptno

-- Natural Join
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM student s
     NATURAL JOIN department d;

-- NATURAL JOIN�� �̿��Ͽ� ���� ��ȣ, �̸�, �а� ��ȣ, �а� �̸��� ����Ͽ���
SELECT p.profno, p.name, deptno, d.dname
FROM professor p
     NATURAL JOIN department d;

-- NATURAL JOIN�� �̿��Ͽ� 4�г� �л��� �̸�, �а� ��ȣ, �а��̸��� ����Ͽ���
SELECT s.name, s.grade, deptno, d.dname
FROM student s
     NATURAL JOIN department d
WHERE s.grade = 4;

-- JOIN ~ USING ���� �̿��Ͽ� �й�, �̸�, �а���ȣ, �а��̸�, �а���ġ�� ����Ͽ��� (���� : name -->�达���� ����)
SELECT s.studno, s.name, deptno, dname
FROM   student s JOIN department
       USING (deptno)
WHERE s.name LIKE '��%';

-- NON-EQUI JOIN *
-- ���� ���̺�� �޿� ��� ���̺��� NON-EQUI JOIN�Ͽ� �������� �޿� ����� ����Ͽ���
SELECT p.profno, p.name, p.sal, s.grade
FROM professor p, salgrade s
WHERE p.sal BETWEEN s.losal AND s.hisal;
---------------------------------------------------
----- OUTER JOIN        
---------------------------------------------------
SELECT e.empno, e.ename, d.deptno, d.dname
FROM   emp e, dept d
WHERE  e.deptno = d.deptno (+) -- LEFT O.J
;
-- �л� ���̺�� ���� ���̺��� �����Ͽ� �̸�, �г�, ���������� �̸�, ������ ���
-- ��, ���������� �������� ���� �л��̸��� �Բ� ����Ͽ���.
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno = p.profno(+)
ORDER BY p.profno;

--- ANSI OUTER JOIN
-- 1. ANSI LEFT OUTER JOIN
SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       LEFT OUTER JOIN professor p
       ON s.profno = p.profno;
-- 2. ANSI RIGHT OUTER JOIN
SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       RIGHT OUTER JOIN professor p
       ON s.profno = p.profno;
-- 3. ANSI FULL OUTER JOIN
SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       RIGHT OUTER JOIN professor p
       ON s.profno = p.profno;

-- FULL OUTER ���   --> Union
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno = p.profno(+)
UNION
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno(+) = p.profno

--�μ� ���̺��� SELF JOIN **
SELECT c.deptno, c.dname, c.college, d.dname college_name
     --�а�           �к�
FROM department c, department d
WHERE c.college = d.deptno;
-- �μ� ��ȣ�� 201 �̻��� �μ� �̸��� ���� �μ��� �̸��� ���
-- ��� : xxx�Ҽ��� xxx�к�

--�����
SELECT concat(concat(c.dname,'�� �Ҽ��� '), d.dname)
FROM department c, department d
WHERE c.college = d.deptno
AND c.deptno>=201

--�ܴ��
SELECT dept.dname||'�� �Ҽ��� '||org.dname
FROM department dept, department org
WHERE dept.college = org.deptno
AND dept.deptno >= 201;

-- SALGRADE2 ����
 CREATE TABLE "SCOTT"."SALGRADE2" 
   (   "GRADE" NUMBER(2,0), 
        "LOSAL" NUMBER(5,0), 
        "HISAL" NUMBER(5,0), 
         CONSTRAINT "PK_GRADE2" PRIMARY KEY ("GRADE")
        )

-- 1. �̸�, �����ڸ�(emp TBL)
select w.ename, m.ename
from emp w, emp m
where w.mgr = m.empno
    -- 1) CLARK ������ ��� 
    select   w.ename , w.mgr
    from    emp w
    where   w.empno = 7782; 
    -- 2) CLARK ������ ��� �� �̿��� �̸�
    select   m.ename
    from    emp m
    where   m.empno = 7839;


-- 2. �̸�,�޿�,�μ��ڵ�,�μ���,�ٹ���, ������ ��, ��ü����(emp ,dept TBL)
select w.ename, w.sal, w.deptno, d.dname, d.loc, m.ename ������
from   emp w, emp m, dept d
where  w.mgr = m.empno(+) 
AND    w.deptno = d.deptno;
-- ansi ���
select w.ename, w.sal, w.deptno, d.dname, d.loc, m.ename ������
from   emp w
       left outer join emp m on w.mgr = m.empno
       left outer join dept d on w.deptno = d.deptno

-- 3. �̸�,�޿�,���,�μ���,�����ڸ�, �޿��� 1500�̻��� ���
--    (emp, dept,salgrade2 TBL)
select w.ename, w.sal, s.grade, d.dname, m.ename
from emp w, emp m, dept d, salgrade2 s
WHERE w.mgr = m.empno 
AND w.deptno = d.deptno 
AND w.sal BETWEEN s.losal AND s.hisal --(��������)
AND w.sal >= 1500;

-- 4. ���ʽ��� �޴� ����� ���Ͽ� �̸�,�μ���,��ġ�� ����ϴ� SELECT ������ �ۼ�emp ,dept TBL)
select e.ename, d.dname, d.loc
from emp e, dept d
where e.deptno = d.deptno
and e.comm is not null

-- 5. ���, �����, �μ��ڵ�, �μ����� �˻��϶�. ������������ ������������(emp ,dept TBL)
select e.empno, e.ename, d.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno
order by e.ename asc;

------------------------------------------------
----- SUB Query
------------------------------------------------
--  1. ��ǥ : ���� ���̺��� ���������� ������ ������ ������ ��� ������ �̸� �˻�
--       1-1 ���� ���̺��� ���������� ������ ���� �˻� SQL ��ɹ� ����
--       1-2 ���� ���̺��� ���� Į������ 1 ���� ���� ��� ���� ������ ������ ���� ���� �˻� ��ɹ� ����
-- 1-1
SELECT position
FROM professor
WHERE name = '������'

-- 1-2
SELECT name, position
FROM professor
WHERE position = '���Ӱ���'

-- ���� �� Sub Query
-- 1. SUB Query (1-1) + (1-2)
select name, position
from professor
where position = (
      -- 1-1
      select position 
      from professor 
      where name='������'
      )

-- ����� ���̵� ��jun123���� �л��� ���� �г��� �л��� �й�, �̸�, �г��� ����Ͽ���
select studno, name, grade
from student
where grade = (select grade from student where userid = 'jun123')

-- 101�� �а� �л����� ��� �����Ժ��� �����԰� ���� �л��� �̸�, �а���ȣ, �����Ը� 
-- ���\
select name, grade, deptno, weight
from student
where weight < (
                select AVG(weight) 
                from student 
                where deptno=101
                )
order by deptno
-- 20101�� �л��� �г��� ����, Ű�� 20101�� �л����� ū �л��� 
-- �̸�, �г�, Ű�� ����Ͽ���
select name, grade, height
from student
where grade = (select grade 
               from student 
               where studno = 20101)
and height > (select height 
              from student 
              where studno = 20101)
order by deptno

----------------------------------------
----- ���� �� �ڡڡڡ�
----------------------------------------
-- 1.  IN �����ڸ� �̿��� ���� �� ��������
SELECT name, grade, deptno
FROM student
WHERE deptno IN (
                SELECT deptno
                FROM department
                WHERE college = 100
                )
-- ���� ���� �ǹ�
SELECT name, grade, deptno
FROM   student
WHERE  deptno IN (
                  101,102
               );

-- 2. ANY �����ڸ� �̿��� ���� �� ��������
SELECT studno, name, height 
FROM student
WHERE height > ANY (
                    -- 175, 176, 177
                    SELECT height
                    FROM student
                    WHERE grade = '4'
                    )
                    
-- 3. ANY �����ڸ� �̿��� ���� �� ��������
SELECT studno, name, height 
FROM student
WHERE height > ALL (
                    SELECT height
                    FROM student
                    WHERE grade = '4'
                    )
--- 4. EXISTS �����ڸ� �̿��� ���� �� �������� �ڡڡ�
SELECT profno, name, sal, comm, position
FROM   professor
WHERE EXISTS (
            SELECT position
            FROM professor
            WHERE comm IS NOT NULL
            );

-- PAIRWISE ���� Į�� ��������
-- PAIRWISE �� ����� ���� �г⺰�� �����԰� �ּ��� 
-- �л��� �̸�, �г�, �����Ը� ����Ͽ���
SELECT name, grade, weight
FROM student
WHERE (grade, weight) IN ( SELECT grade, MIN(weight)
                           FROM student
                           GROUP BY grade);

-- ��ȣ���� �������� ***�ڡڡڡڡڡڡڡڡ�
-- ������������ ������������ �˻� ����� ��ȯ�ϴ� ��������
-- ���� �� �а� �л��� ��� Ű���� Ű�� ū �л��� �̸�, �а� ��ȣ, Ű�� ����Ͽ���
SELECT deptno, name, grade, height
FROM student s1
WHERE height > ( SELECT AVG(height)
                 FROM student s2
                 WHERE s2.deptno = s1.deptno
                )
ORDER BY deptno
;

-- 101 171.125
-- 102 168
-- 201 176
SELECT AVG(height)
FROM student s2
WHERE s2.deptno = 101 

-------------------  HomeWork --------------------------
-- 1. Blake�� ���� �μ��� �ִ� ��� ����� ���ؼ� ��� �̸��� �Ի����� ���÷����϶�
SELECT ename, hiredate, deptno
FROM   emp
WHERE  deptno = ( SELECT deptno
                  FROM   emp
                  WHERE INITCAP(ename) = 'Blake'
                  );
-- 2. ��� �޿� �̻��� �޴� ��� ����� ���ؼ� ��� ��ȣ�� �̸��� ���÷����ϴ� ���ǹ��� ����. 
--    �� ����� �޿� �������� �����϶�
SELECT empno, ename, sal
from emp e1
where sal >= (select avg(sal)
              from emp e2
              )
order by sal desc;              
-- 3. ���ʽ��� �޴� � ����� �μ� ��ȣ�� 
--    �޿��� ��ġ�ϴ� ����� �̸�, �μ� ��ȣ �׸��� �޿��� ���÷����϶�.
select ename, deptno, sal
from emp
where (deptno,sal) in ( SELECT deptno,sal
            FROM emp
            WHERE comm IS NOT NULL);





















