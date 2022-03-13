SELECT studno, name, grade, deptno, weight
FROM student
WHERE grade=1 OR weight<=70;

--BETWEEN �����ڸ� ����Ͽ� �����԰� 50kg���� 70kg ������ �л��� �й�, �̸�, �����Ը� ����Ͽ���
SELECT studno, name, weight
FROM student
WHERE weight BETWEEN 50 AND 70;

--�л����̺��� 81�⿡�� 83�⵵�� �¾ �л��� �̸��� ��������� ����ض�
SELECT name, birthdate
FROM student
WHERE birthdate between '81/01/01' AND '83/12/31';
--IN �����ڸ� ����Ͽ� 102�� �а��� 201�� �а� �л��� �̸�, �г�, �а���ȣ�� ����Ͽ���
SELECT name, grade, deptno
FROM student
WHERE deptno = 102 OR deptno = 201;
--WHERE deptno IN (102,201); ������ ������ in�� �� ���� ���

--�л� ���̺��� ���� ���衯���� �л��� �̸�, �г�, �а� ��ȣ�� ����Ͽ��� �ڡڡڡڡڡڡڡڡڡڡڡڡڡ�
SELECT name, grade, deptno
FROM student
WHERE name LIKE '��%';
--�л� ���̺��� �̸��� 3����, ���� ���衯���� ������ ���ڰ� 
--���������� ������ �л��� �̸�, �г�, �а� ��ȣ�� ����Ͽ���
SELECT name, grade, deptno
FROM student
WHERE name LIKE '��_��';

--NULL ���� (nvl�Լ� ����ϱ�):: null�� 0���� �ƴϴ�. null���� �� �� ����.
SELECT empno, ename, sal, comm, sal+comm hap
FROM emp
;
-- NVL(�÷�, ��ü��) �Լ��� �̿��Ͽ� null���� ��ü������ ���� �ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ�
SELECT empno, ename, sal, comm, sal+NVL(comm,0) hap
FROM emp
;
--���� ���̺��� �̸�, ����, ���������� ����Ͽ���
SELECT name, position, comm
FROM professor
;

--���� ���̺��� ���������� ���� ������ �̸�, ����, ���������� ����Ͽ���.
SELECT name, position, comm
FROM professor
WHERE comm = NULL;   --x �ȵ�

SELECT name, position, comm
FROM professor
WHERE comm IS NULL; --OK

--102�� �а��� �л� �߿��� 1�г� �Ǵ� 4�г� �л��� �̸�, �г�, �а� ��ȣ�� ����Ͽ���.
SELECT name, grade, deptno
FROM student
WHERE deptno = 102 and grade in(1,4);
--WHERE deptno = 102 and (grade =1 or grade=4);

-- ���� ������ �ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ�
--1�г� �̸鼭 �����԰� 70kg �̻��� �л��� ����(stud_heavy) ���̺� ����
create table stud_heavy
AS
SELECT * 
FROM student
WHERE grade = 1
AND weight >=70
;

--1�г� �̸鼭 101�� �а��� �Ҽӵ� �л�(stud_101)���� ������ ���̺� ����
create table stud_101
AS
SELECT * 
FROM student
WHERE grade = 1
AND deptno = 101
;
--���� x (�÷��� ���� ���� �ʱ� ����)
SELECT studno, name
FROM stud_heavy
UNION
SELECT  studno, name, grade
FROM stud_101
;
--���� ok 1 (�÷��� ���� �����ϹǷ� �ùٸ��� �����) : UNION(�ߺ��Ǵ� ���� �ѹ��� ���) ��� �� �˻��ϰ��� �ϴ� �÷��� ���� �̸��� ��ġ�ؾ� �Ѵ�
SELECT studno, name ,grade
FROM stud_heavy
UNION
SELECT  studno, name, grade
FROM stud_101
;
--���� ok 2 (�ߺ��Ǵ� �ͱ��� ��� ����)
SELECT studno, name ,grade
FROM stud_heavy
UNION ALL
SELECT  studno, name, grade
FROM stud_101
;
--���� ok 3 (������: �ߺ��Ǵ� �� ������ ����������): MINUS(�� ���հ��� ������) ��� �� �˻��ϰ��� �ϴ� �÷��� ���� �̸��� ��ġ�ؾ� �Ѵ�
SELECT studno, name ,grade
FROM stud_heavy
MINUS
SELECT  studno, name, grade
FROM stud_101
;
--���� ok 4 INTERSECT:(�� ���հ��� ������) ��� �� �˻��ϰ��� �ϴ� �÷��� ���� �̸��� ��ġ�ؾ� �Ѵ�
SELECT studno, name ,grade
FROM stud_heavy
INTERSECT
SELECT  studno, name, grade
FROM stud_101
;

-- ����(����) �ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ�
--SORTING 1 -> �������� ASC(default ��)
SELECT name, grade, tel
FROM student
ORDER BY name ASC
;
--SORTING 2 -> �������� DESC(�����ȵ�)
SELECT name, grade, tel
FROM student
ORDER BY name DESC
;
--SORTING 3 -> Multi sorting
--��� ����� �̸��� �޿� �� �μ���ȣ�� ����ϴµ�, 
--�μ� ��ȣ�� ����� ������ ���� �޿��� ���ؼ��� ������������ �����϶�
SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC
;

--����1. �μ� 10 �Ǵ� 30�� ���ϴ� ��� ����� �̸��� �μ���ȣ�� �̸��� ���ĺ� ������ ���ĵǵ��� ���ǹ��� �����϶�
SELECT ename, deptno
FROM emp
WHERE deptno in (10,30)
ORDER BY ename ASC
;
--����2. 1982�⿡ �Ի��� ��� ����� �̸��� �Ի����� ���ϴ� ���ǹ�
SELECT ename, hiredate
FROM emp
WHERE hiredate LIKE '82%';
--between '1982/01/01' and '1982/12/31';

--����3. ���ʽ��� �޴� ��� ����� ���ؼ� �̸�, �޿� �׸��� ���ʽ��� ����ϴ� ���ǹ��� �����϶�.  �� �޿��� ���ʽ��� ���ؼ� �������� ����
SELECT ename, sal, comm
FROM emp
WHERE comm is not null
ORDER BY sal DESC, comm DESC
;
--����4. ���ʽ��� �޿��� 20% �̻��̰� �μ���ȣ�� 30�� ���� ��� ����� ���ؼ� �̸�, �޿� �׸��� ���ʽ��� ����ϴ� ���ǹ��� �����϶�
SELECT ename, sal, comm
FROM emp
WHERE comm>=sal*0.2
AND
deptno=30
; 

----------------------------------------------------
----- 07�� �Լ�
------------------------------------------------------
--1.�л� ���̺��� ���迵�ա� �л��� �̸�, ����� ���̵� ����Ͽ���. �׸��� ����� ���̵��� ù ���ڸ� �빮�ڷ� ��ȯ�Ͽ� ����Ͽ���
SELECT name, userid, INITCAP(userid)
FROM student
WHERE  name = '�迵��'
;
--2.�л� ���̺��� �й��� ��20101���� �л��� ����� ���̵� �ҹ��ڿ� �빮�ڷ� ��ȯ�Ͽ� ����Ͽ���
SELECT userid, LOWER(userid), UPPER(userid)
FROM student
WHERE  studno = 20101
;
--3.�μ� ���̺��� �μ� �̸��� ���̸� ���� ���� ����Ʈ ���� ���� ����Ͽ���
SELECT dname, LENGTH(dname), LENGTHB(dname)
FROM department;

-- 4. �������� �Լ� �ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ�
    --1) concat �Լ�: �������� ���� �ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡھ��ָ��� ���
SELECT name, position, CONCAT(CONCAT(name, '�� ��å�� '), position)
FROM professor;
    --2) SUBSTR�Լ��ڡڡڡڡڡڡڡ�SUBSTR(�÷��� �Ǵ� ������,ù��°���ں���,6���� ���� ����)
    --�л� ���̺��� 1�г� �л��� �ֹε�� ��ȣ���� ������ϰ� �¾ ���� �����Ͽ� �̸�, �ֹι�ȣ, �������, �¾ ���� ����Ͽ���
SELECT name, idnum, SUBSTR(idnum,1,6) birth_date,
                    SUBSTR(idnum,3,2) birth_month
FROM student
WHERE grade = 1
;
    --3) INSTR �Լ�
    --�μ� ���̺��� �μ� �̸� Į������ ������ ������ ��ġ�� ����Ͽ���
SELECT dname, INSTR(dname,'��')
FROM department;
    
    --4) LPAD, RPAD �Լ�
    --�������̺��� ���� Į���� ���ʿ� ��*�� ���ڸ� �����Ͽ� 10����Ʈ�� ����ϰ� ���� ���̴� Į���� �����ʿ� ��+�����ڸ� �����Ͽ� 12����Ʈ�� ����Ͽ���
SELECT position, LPAD(position, 10, '*') lpad_position,
        userid, RPAD(userid, 12, '+') rpad_position
FROM    professor;

    --5)�������� �Լ�  LTRIM, RTRIM �Լ�
    --�μ� ���̺��� �μ� �̸��� ������ ������ �������� �����Ͽ� ����Ͽ���
SELECT dname, RTRIM(dname, '��')
FROM department;

SELECT dname, LTRIM('    1234567', ' ') kk1, '    1234567' kk2
FROM department;

-------------------------------------------------------------------------------
--5. ���� �Լ� �ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ�
-------------------------------------------------------------------------------
    --1)Round (������ �ڸ� ���Ͽ��� �ݿø��� ��� ���� ��ȯ�ϴ� �Լ�)�ڡڡڡڡڡڡ�
    --���� ���̺��� 101�а� ������ �ϱ��� ���(�� �ٹ����� 22��)�Ͽ� �Ҽ��� ù° �ڸ��� ��° �ڸ����� �ݿø� �� ���� 
    --�Ҽ��� ���� ù° �ڸ����� �ݿø��� ���� ����Ͽ��� -1�� �����ڸ����� �ݿø� -2�� ���� ���� �����ڸ����� �ݿø�
 SELECT name, sal, sal/22, ROUND(sal/22), ROUND(sal/22,2), ROUND(sal/22,-1), ROUND(1234.567,-2)
 FROM professor
 WHERE deptno = 101;
 
    --2) �����Լ� TRUNC �Լ�
    --���� ���̺��� 101�а� ������ �ϱ��� ���(�� �ٹ����� 22��)�Ͽ� �Ҽ��� ù° �ڸ��� ��° �ڸ����� ���� �� ����
    --�Ҽ��� ���� ù° �ڸ����� ������ ���� ����Ͽ���
SELECT name, sal, sal/22, TRUNC(sal/22), TRUNC(sal/22,2), TRUNC(sal/22,-1)
 FROM professor
 WHERE deptno = 101;

    --3)���� �Լ�  MOD �Լ�
    --���� ���̺��� 101�� �а� ������ �޿��� ������������ ���� �������� ����Ͽ� ����Ͽ���
SELECT name, sal, comm, MOD(sal, comm), MOD(100,17)
 FROM professor
 WHERE deptno = 101;

    --4) ���� �Լ� Ceil(�ø�): ũ�ų� ���� ������ �ּҰ����� , Floor �Լ�(����):�۰ų� ���� ������ �ִ밪 ����
    SELECT CEIL(19.7), FLOOR(-12.745), Trunc(-12.745)
    FROM dual;

-------------------------------------------------------------------------------
-- 6. ��¥ �Լ� �ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ�
-------------------------------------------------------------------------------
    --1)���� ��ȣ�� 9908�� ������ �Ի����� �������� �Ի� 30�� �Ŀ� 60�� ���� ��¥�� ����Ͽ���
SELECT name, hiredate, hiredate+30, hiredate+60
FROM professor
;
SELECT sysdate, sysdate+28, sysdate+29
FROM dual
;

