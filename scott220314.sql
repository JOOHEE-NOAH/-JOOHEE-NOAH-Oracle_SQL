-------------------------------------
---- ������ ���ǹ�
-------------------------------------
-- ������ ���ǹ��� ����Ͽ� �μ� ���̺��� �а�,�к�,�ܰ������� �˻��Ͽ� �ܴ�,�к�
-- �а������� top-down(�ڽ��� ���� ������ �״㿡 �θ�) ������ ���� ������ ����Ͽ���. ��, ���� �����ʹ� 10�� �μ�
select deptno, dname, college
from department
start with deptno = 10
connect by prior deptno = college;

-- ������ ���ǹ��� ����Ͽ� �μ� ���̺��� �а�,�к�,�ܰ������� �˻��Ͽ� �а�,�к�
-- �ܴ� ������ bottom-up ������ ���� ������ ����Ͽ���. ��, ���� �����ʹ� 102�� �μ��̴�
select deptno, dname, college
from department
start with deptno = 102
connect by prior college = deptno;

--- ������ ���ǹ��� ����Ͽ� �μ� ���̺��� �μ� �̸��� �˻��Ͽ� �ܴ�, �к�, �а�����
--- top-down �������� ����Ͽ���. ��, ���� �����ʹ� ���������С��̰�,
--- �� �������� �������� 2ĭ �̵��Ͽ� ��� (���� 1: ��Ʈ/ �θ�(����) , ����2: �θ�/�ڽ�(�к�), ���� 3: ������(��))
                      -->������ �ϳ� *�� ä����
SELECT LPAD(' ', (LEVEL-1)*2,'*') || dname ������   
FROM department
START WITH dname = '��������'
CONNECT BY PRIOR deptno = college;

--          �����ٹ��ڿ� / �������� ����  / �������� ä������ ����      
SELECT LPAD('abcd',         5        ,'*') FROM dual;

-- FK
-- 1) Restrict : �ڽ� ���� ���� �ȵ�
-- 2) SET NULL
-- 3) Cascading Delete : ���� ����
insert into dept values(50, 'OPERATIONS', 'BOSTON');

INSERT INTO EMP VALUES
(1010,'FK Test1','CLERK', 7902, TO_DATE('17-12-1980','DD-MM-YYYY'),800,NULL,50);

-- 1) �⺻--> restrict : �ڽ� ���� ���� �ȵ�.
DELETE dept
where deptno = 50;

-- 2) SET NULL�� ���� --> �θ��� ���� ������� �ڽ��� �ܷ�Ű�� null�� ��
DELETE dept
where deptno = 50;

-- 3) Cascading Delete : ���� ����
DELETE dept
where deptno = 50;

--------------------------------------------
-------  1.   Data  Tablespace  --------------
--------------------------------------------













