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
-------  �ڡ�   PL/SQL  �ڡ�--------------
--------------------------------------------
--- 1. �Լ�(Function)
--- Ư���� ���� ������ 7%�� ����ϴ� Function�� �ۼ��ϸ�
create or replace FUNCTION tax
    (p_num in number) -- Parameter
RETURN number         -- Return Value
Is
    v_tax number;     -- ���� ����
BEGIN                 --�Լ� ����
--���� 7%
    v_tax := p_num * 0.07;
    RETURN(v_tax);
END;

--is �� begin ���̿� ���� ������ ���ش�. ������� �ǹ̷� v_�� ���� �ۼ��Ѵ�.
-- begin�� end ���̿� ������ �����Ѵ�. =�� �ƴ϶� :=���� ���!

--2.�Լ�ȣ��
select tax(200) from dual;

select profno , name, sal, tax(sal)
from professor;


--------------------------------------------------------------
-- Procedure
-- 1. �Ķ��Ÿ : (p_deptno , p_dname ,   p_loc)
-- 2. dept TBL�� Insert Procedure
--------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Dept_Insert
    (p_deptno in dept.deptno%type, --dept.deptno%type: dept���̺��� deptno�� data_type�� ��� �Ȱ��� �����. ��� ��
     p_dname in dept.dname%type,
     p_loc in dept.loc%type)
IS
BEGIN
    INSERT into dept VALUES(p_deptno, p_dname, p_loc);
    COMMIT;
END;
    








