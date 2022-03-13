SELECT sysdate
FROM dual;--dual: 3����Ʈ�� ������ �ִ� �ӽ����̺�. select �÷� from ���̺��� ������ �����ֱ� ���� ���.


-- �Ի����� 120���� �̸��� ������ ������ȣ, �Ի���, �Ի��Ϸκ��� �����ϱ����� ���� ��,
-- �Ի��Ͽ��� 6���� ���� ��¥�� ����Ͽ���
SELECT profno, name, hiredate,
       MONTHS_BETWEEN(sysdate, hiredate) dur_date,
       ADD_MONTHS(hiredate, 6)    Add_6
FROM professor
WHERE MONTHS_BETWEEN(sysdate, hiredate)< 120;
-- ������ ���� ���� ������ ��¥�� �ٰ����� �Ͽ����� ��¥�� ����Ͽ���
SELECT sysdate, LAST_DAY(sysdate), NEXT_DAY(sysdate, '��')
FROM dual;
-- 101�� �а� �������� �Ի����� ��, ��, ���� �������� �ݿø��Ͽ� ����Ͽ���
-- ROUND 'dd' ���� 12�� �������� ��¥ �ݿø�
-- mm �������� 1~15���� �ش� �� 1�� 16�Ϻ��ʹ� ������ 1��
-- yy  �������� 1~6���� �ش� �� 1��1�� 7~12�� ������ 1��1��
SELECT hiredate,
       TO_CHAR(hiredate, 'YY/MM/DD HH24:MI:SS') hiredate,
       TO_CHAR(ROUND(hiredate,'dd'), 'YY/MM/DD') round_dd,
       TO_CHAR(ROUND(hiredate,'mm'), 'YY/MM/DD') round_mm,
       TO_CHAR(ROUND(hiredate,'yy'), 'YY/MM/DD') round_yy
FROM professor
WHERE deptno = 101;
-- �л� ���̺��� ������ �л��� �й��� ������� �߿��� ����� ����Ͽ���
SELECT studno, birthdate, TO_CHAR(birthdate, 'YY/MM') birthdate
FROM student
WHERE name = '������'
;
-- ���� ���̺��� 101�� �а� �������� �̸�, ����, �Ի����� ����Ͽ���
SELECT name, position, TO_CHAR(hiredate, 'YY/MM/dd') hiredate
FROM professor
WHERE deptno=101
;
--���������� �޴� �������� �̸�, �޿�, ��������, �׸��� �޿��� ���������� ���� ���� 12�� ���� ����� �������� ����Ͽ���
SELECT name, sal, comm, TO_CHAR((sal+comm)*12, '9,999') anual_sal
FROM professor
WHERE comm IS NOT NULL;

--To_number
select to_number('100.00') num
from dual;

--NVL2 �Լ�  ->nvl�� if���, nvl2�� If esle�� �Բ��ִ°�
--102�� �а� �����߿��� ���������� �޴� ����� �޿��� ���������� ���� ���� �޿� �Ѿ����� ����Ͽ���. 
--��, ���������� ���� �ʴ� ������ �޿��� �޿� �Ѿ����� ����Ͽ���
--(�ش簪�� ���� �ƴϸ�, �� ���� ����, ���̸� �̰��� ����)
--(comm�� ���ΰ�?, ���� �ƴϸ� sal+comm����, ���̸�  sal ����)
select  name, position, sal, comm,
        NVL2(comm, sal+comm, sal) sal_hap
from professor
where deptno= 102
;
--NULLIF �Լ�
--���� ���̺��� �̸��� ����Ʈ ���� ����� ���̵��� ����Ʈ ���� ���ؼ� 
--������ NULL�� ��ȯ�ϰ� ���� ������ �̸��� ����Ʈ ���� ��ȯ�Ͽ���
--nullif(�÷�1, �÷�2)-->�÷�1�� 2�� ���Ͽ� �� ���� ������ null,�ƴϸ� �÷�1�� ���� ����
select  name, userid, LENGTHB(name), LENGTHB(userid),
        NULLIF( LENGTHB(name), LENGTHB(userid)) nullif_result
        
from professor;

--COALESCE �Լ�
--���� ���̺��� ���������� NULL�� �ƴϸ� ���������� ����ϰ�,
--���������� NULL�̰� �޿��� NULL�� �ƴϸ� �޿��� ���, ��������� �޿��� NULL�̸� 0�� ����Ͽ���
--if  else if else
--COALESCE(x,y,z) x�� null�� �ƴϸ� x�� ���, x�� null�̰� y�� null�� �ƴϸ� y�� ���, �Ѵ� null�̸� x ��� 
select  name, comm, sal,
        COALESCE(comm,sal,0) co_hap
from professor
;

--�ڡڡڡڡڡڡ�Decode �ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڰ��߿�
--���� ���̺��� ������ �Ҽ� �а� ��ȣ�� �а� �̸����� ��ȯ�Ͽ� ����Ͽ���. 
--�а� ��ȣ�� 101�̸� ����ǻ�Ͱ��а���, 102�̸� ����Ƽ�̵���а���, 201�̸� �����ڰ��а���, 
--������ �а� ��ȣ�� �������а���(default)�� ��ȯ�Ѵ�.

select  name, deptno,
        DECODE(deptno, 101, '��ǻ�Ͱ��а�'
                     , 102, '��Ƽ�̵���а�'
                     , 201, '���ڰ��а�'
                          , '�����а�') deptname
from professor
;

--case�ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڰ��߿�
--���� ���̺��� �Ҽ� �а��� ���� ���ʽ��� �ٸ��� ����Ͽ� ����Ͽ���.�а� ��ȣ���� ���ʽ��� ������ ���� ����Ѵ�. 
--�а� ��ȣ�� 101�̸� ���ʽ��� �޿��� 10%, 102�̸� 20%, 201�̸� 30%, ������ �а��� 0%�̴�
select  name, deptno, sal,
        CASE WHEN deptno = 101 THEN sal*0.1
             WHEN deptno = 102 THEN sal*0.2
             WHEN deptno = 201 THEN sal*0.3
             ELSE                   0
        END  bonus     
from professor;

-------------------------����1 ---------------------------------------
--1. salgrade ������ ��ü ����
select *
from salgrade;

--2. scott���� ��밡���� ���̺� ����
select *
from tab;

--3. emp Table���� ��� , �̸�, �޿�, ����, �Ի���
select empno , ename , sal, job, hiredate
from emp;
--4. emp Table���� �޿��� 2000�̸��� ��� �� ���� ���, �̸�, �޿� �׸� ��ȸ
select empno , ename , sal
from emp
where sal < 2000;

--5. emp Table���� 81/02���Ŀ� �Ի��� ����� ����  ���,�̸�,����,�Ի��� 
select empno , ename , job, hiredate
from emp
where hiredate>='81/02/01';

--6. emp Table���� �޿��� 1500�̻��̰� 3000���� ���, �̸�, �޿�  ��ȸ
select empno , ename , sal
from emp
where sal >=1500
and sal<=3000 ;
--=where sal between 1500 and 3000;

--7. emp Table���� ���, �̸�, ����, �޿� ��� [ �޿��� 2500�̻��̰�
--   ������ MANAGER�� ���]
select empno , ename , sal
from emp
where sal >=2500
and job='MANAGER' ;

--8. emp Table���� �̸�, �޿�, ���� ��ȸ [�� ������  ���� = (�޿�+��) * 12  , null�� 0���� ����]
select empno , ename , sal, (sal+nvl(comm,0)) * 12 ����
from emp;

--9. emp Table����  81/02 ���Ŀ� �Ի��ڵ��� xxx�� �Ի����� xxX
--  [ ��ü Row ��� ]
select  concat(concat(concat(ename,'�� �Ի�����'),hiredate),'�̴�')
from emp
where hiredate>='81/02/01';

select  ename || '�� �Ի�����' || hiredate || '�̴�'
from emp
where hiredate>='81/02/01';

--10.emp Table���� �̸��ӿ� T�� �ִ� ���,�̸� ���
select empno, ename
from emp
where ename like '%T%';

--11.82�⿡ �Ի��� ��� ��ü �÷� ���
select *
from emp
where hiredate between '82/01/01' and '82/12/31';
--=where hiredate like '82%';

--12.2022�⿡ �Ի��� ��� ��ü �÷� ���
select * from emp where to_char(hiredate,'yyyy') = '2022';

--------------------���� 2--------------------------------
--1. emp Table �� �̸��� �빮��, �ҹ���, ù���ڸ� �빮�ڷ� ���
select UPPER(ename), LOWER(ename), INITCAP(ename)
from emp
;
--2. emp Table ��  �̸�, ����, ������ 2-5���� ���� ���
select ename, job, SUBSTR(job,2,4)
from emp
;
--3. emp Table �� �̸�, �̸��� 10�ڸ��� �ϰ� ���ʿ� #���� ä���
select ename, LPAD(ename, 10 ,'#')
from emp
;
-- 4. emp Table ��  �̸�, ����, ������ MANAGER�� �����ڷ� ���
select ename, job, DECODE(job, 'MANAGER', '������')
from emp 
;--> decode nanager�� �����ڷ� �ٲ� ����ϰ� job���� null�� ���
select ename, job, Replace(job,'MANAGER','������')
from emp
;-->decode nanager�� �����ڷ� �ٲ� ����ϰ� ������ job���� ���������� ���

--5. emp Table ��  �̸�, �޿�/7�� ���� ����, �Ҽ��� 1�ڸ�. 10������   �ݿø��Ͽ� ���
select ename, round(sal/7), round(sal/7,1),round(sal/7,-1)
from emp
;
--6. 5���� �����Ͽ� �����Ͽ� ���
select ename, sal/7, trunc(sal/7), trunc(sal/7,1),trunc(sal/7,-1)
from emp
;
--7. emp Table ��  �̸�, �޿�/7�� ����� �ݿø�,����,ceil,floor
select ename, sal/7, round(sal/7), trunc(sal/7), ceil(sal/7), floor(sal/7)
from emp
;
--8. emp Table ��  �̸�, �޿�, �޿�/7�� ������
select ename, sal, mod(sal,7)
from emp
;
--9. emp Table �� �̸�, �޿�, �Ի���, �Ի�Ⱓ(���� ����,��)���,  �Ҽ��� ���ϴ� �ݿø��ڡڡ�
select  ename, sal, hiredate, 
        round(sysdate-hiredate) �Ի�Ⱓ_��
        ,round(MONTHS_BETWEEN(sysdate, hiredate)) �Ի�Ⱓ_�� 
from emp;

--10.emp Table ��  job �� 'CLERK' �϶� 10% ,'ANALYSY' �϶� 20% 
--                                 'MANAGER' �϶� 30% ,'PRESIDENT' �϶� 40%
--                                 'SALESMAN' �϶� 50% 
--                                 �׿��϶� 60% �λ� �Ͽ� 
--   empno, ename, job, sal, �� �� �λ� �޿��� ����ϼ���(CASE/Decode�� ���)�ڡڡڡڡ�
select  empno, ename, job, sal,
        CASE WHEN job = 'CLERK' THEN sal*1.1
             WHEN job = 'ANALYSY' THEN sal*1.2
             WHEN job = 'MANAGER' THEN sal*1.3
             WHEN job = 'PRESIDENT' THEN sal*1.4
             WHEN job = 'SALESMAN' THEN sal*1.5
             ELSE                   sal*1.6
        END  �λ�޿�     
from emp;

select  empno, ename, job, sal,
        decode(job,'CLERK',sal*1.1
                  ,'ANALYSY',sal*1.2
                  ,'MANAGER',sal*1.3
                  ,'PRESIDENT',sal*1.4
                  ,'SALESMAN',sal*1.5
                  ,sal*1.6
                  ) �λ�޿�
from emp;

---------------------------------------------------------------------------
--------ch08 Group �Լ��ڡڡڡڡ�--------------------------------------------------
---------------------------------------------------------------------------
--101�� �а� �����߿��� ���������� �޴� ������ ���� ����Ͽ���.
--count(*)  --> �ΰ��� ���� �ʴ´�
select count(*)
from professor
where deptno = 101;

--count(�÷�)  --> �÷��� ���ؼ��� �ΰ��� ���� �ʴ´�
select count(comm)
from professor
where deptno = 101;

--101�� �а� �л����� ������ ��հ� �հ踦 ����Ͽ���.
select avg(weight), sum(weight)
from student
where deptno = 101;

--102�� �а� �л� �߿��� �ִ� Ű�� �ּ� Ű�� ����Ͽ���
select max(height), min(height)
from student
where deptno = 102;

--����Լ� �տ� �÷��� �� �÷��� ��踦 �ǹ�. ���� �׷캰�� �����ش�.(group by)
select max(height), min(height)
from student
group by deptno
;
--���� ���̺��� �а����� ���� ���� ���������� �޴� ���� ���� ����Ͽ���
select deptno, count(*), count(comm) 
from professor
group by deptno
;

--�а����� �Ҽ� �������� ��ձ޿�, �ּұ޿�, �ִ�޿��� ����Ͽ���.
select avg(sal) ��ձ޿�, min(sal) �ּұ޿�, max(sal) �ִ�޿�
from professor
group by deptno
;

--��ü �л��� �Ҽ� �а����� ������, ���� �а� �л��� �ٽ� �г⺰�� �׷����Ͽ�, �а��� �г⺰ �ο���, ��� �����Ը� ����Ͽ���, ��, ��� �����Դ� �Ҽ��� ���� ù��° �ڸ����� �ݿø� �Ѵ�.
select deptno, grade, count(*), ROUND(AVG(weight))
from student
group by deptno, grade
order by deptno, grade
;

--�Ҽ� �а����� ���� �޿� �հ�� ��� �а� �������� �޿� �հ踦 ����Ͽ���
SELECT deptno, sum(sal)
from professor
group by rollup(deptno)
;

--ROLLUP �����ڸ� �̿��Ͽ� �а� �� ���޺� ���� ��, �а��� ���� ��, ��ü ���� ���� ����Ͽ���
SELECT deptno, position, count(*)
from professor
group by rollup(deptno, position)
;

--cube ������
--rollup�� ���� �׷� ����� group by ���� ����� ���ǿ� ���� �׷� ������ ����� ������

--�ڡڡڡڡڡڡ�having �� :GROUP BY ���� ���� ������ �׷��� ������� ������ ����
--�л� ���� 4���̻��� �г⿡ ���ؼ� �г�, �л� ��, ��� Ű, ��� �����Ը� ����Ͽ���.
--��, ��� Ű�� ��� �����Դ� �Ҽ��� ù ��° �ڸ����� �ݿø� �ϰ�,
--��¼����� ��� Ű�� ���� ������ ������������ ����Ͽ���.
select grade, count(*), round(avg(height)), round(avg(weight))
from student
group by grade
HAVING COUNT(*)>=4
order by avg(height) DESC;
--

--------------------���� 3--------------------------------
--1. �ֱ� �Ի� ����� ���� ������ ����� �Ի��� ��� (emp)
select max(hiredate) max_hiredate, min(hiredate) min_hiredate
from emp;

select to_char(max_hiredate,'yyyy/mm/dd'), to_char(min_hiredate,'yyyy/mm/dd')
from    (select max(hiredate) max_hiredate, min(hiredate) min_hiredate
        from emp
        ) sub_emp
     ;   
---- 2. �μ��� �ֱ� �Ի� ����� ���� ������ ����� �Ի��� ��� (emp)
select deptno, max(hiredate), min(hiredate)
from emp
GROUP BY deptno
;
-- 3.�Ѱ� �̻� Column ���� --> �μ���, ������ count & sum[�޿�]    (emp)
select deptno, job, count(*), sum(sal)
from emp
group by deptno, job
;
-- 4.�μ��� �޿��Ѿ� 3000�̻� �μ���ȣ,�μ��� �޿��ִ�ڡڡڡڡڡ�    (emp)
select deptno, max(sal)
from emp
group by deptno
having sum(sal)>=3000;


-- 5.��ü �л��� �Ҽ� �а����� ������, ���� �а� �л��� �ٽ� �г⺰�� �׷����Ͽ�, 
--   �а��� �г⺰ �ο���, ��� �����Ը� ���, 
-- (��, ��� �����Դ� �Ҽ��� ���� ù��° �ڸ����� �ݿø� )  STUDENT

select deptno, grade, count(*), round(avg(weight))
from student
group by deptno, grade;
--order by deptno;








