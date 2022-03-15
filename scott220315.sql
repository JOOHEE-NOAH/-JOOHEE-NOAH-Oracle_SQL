-------------------------------����1--------------------------------------
-- SQL> EXECUTE Dept_Search(7900);
-- Sales �μ� ����Դϴ�.
-- SQL> EXECUTE Dept_Search(7566); : �츶�콺 �������� ��� �Է��غ���
-- ACCOUNTING �μ� ����Դϴ�.
---------------------------------------------------------
CREATE OR REPLACE  PROCEDURE Dept_Search
(p_empno IN emp.empno%TYPE
-- ,p_dname OUT dept.dname%type
 )
IS  
    v_dname    dept.dname%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT  d.dname
    INTO    v_dname
    FROM    emp e, dept d
    WHERE   empno = p_empno
    AND     e.deptno = d.deptno;
    
    DBMS_OUTPUT.PUT_LINE(v_dname || ' �μ� ����Դϴ�. ');
    
END;


-------------------����2---------------------------------------
-- PROCEDURE Delete_Test
-- SQL> EXECUTE Delete_Test(7900);
-- �����ȣ : 7900
-- ����̸� : JAMES
-- �� �� �� : 81/12/03
-- ������ ���� ����
--  1. Parameter : ��� �Է�
--  2. ��� �̿��� �����ȣ ,����̸� , �� �� �� ���
--  3. ��� �ش��ϴ� ������ ���� 
----------------------------------------------------------
CREATE OR REPLACE PROCEDURE Delete_Test
(p_empno IN emp.empno%TYPE)
IS  --���� �����͸� Ȯ���ϱ����� ���� ����
    v_empno     emp.empno%TYPE;
    v_ename     emp.ename%TYPE;
    v_hiredate  emp.hiredate%TYPE;
    
BEGIN
    DBMS_OUTPUT.ENABLE;
    --������ ������ Ȯ�ο� ����
    SELECT empno, ename, hiredate
    INTO v_empno, v_ename, v_hiredate
    FROM    emp
    WHERE   empno = p_empno;
    DBMS_OUTPUT.PUT_LINE('�����ȣ : '||v_empno);
    DBMS_OUTPUT.PUT_LINE('����̸� : '||v_ename);
    DBMS_OUTPUT.PUT_LINE('�Ի��� : '||v_hiredate);
    
    DELETE
    FROM    emp
    WHERE   empno = p_empno;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('������ ���� ����');
    
END Delete_test;

----------------------���� 3-------------------------------
--  Procedure up_emp ���� ���
-- SQL> EXECUTE up_emp(7654);  -- ��� 
-- ��� : �޿� �λ� ����
--              ���۹���
-- ����  1) job = SALE����         v_pct : 10
--      2)          MAN          v_pct : 7  
--      3)                       v_pct : 5
--   job�� ���� �޿� �λ��� ����  sal = sal+sal*v_pct/100
-- Ȯ�� : DB -> TBL
-----------------------------------------------------
CREATE OR REPLACE PROCEDURE up_emp
(p_empno IN emp.empno%TYPE)
IS
    v_job emp.job%TYPE;
    v_pct number(3);  --�ۼ�Ʈ�� ���ڸ��� �ȳѾ�� ������ ���۸� ���̱� ���ؼ� 3���� ����. �ۼ�Ʈ ó�� Ȯ���� ��쿡�� ���� ���ֱ� �ϴµ� �׳� number�ص� ����.
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT job
    INTO v_job
    FROM    emp
    WHERE   empno = p_empno;
    IF 
        v_job LIKE 'SALE%' THEN v_pct:=10;
    ELSIF
        v_job LIKE 'MAN%' THEN v_pct:=7;
    ELSE
        v_pct:=5;
    END IF;
    
    UPDATE emp
    SET sal = sal+sal*v_pct/100
    WHERE   empno = p_empno;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('�޿� �λ� ����');
END up_emp;

------------------------���� 4------------------------------------
--  EMP ���̺��� ����� �Է¹޾� �ش� ����� �޿��� ���� ������ ����.
-- �޿��� 1000 �̸��̸� �޿��� 5%, 
-- �޿��� 2000 �̸��̸� 7%, 
-- 3000 �̸��̸� 9%, 
-- �� �̻��� 12%�� ����
--- FUNCTION  emp_tax
-- 1) Parameter : ���
-- 2) ����� ������ �޿��� ����
-- 3) �޿��� ������ ���� ��� 
-- 4) ��� �� �� Return   number
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION emp_tax
    (p_empno IN emp.empno%TYPE)  --1) Parameter :���
RETURN number
IS
    v_sal emp.sal%TYPE;
    v_pct number(3);
BEGIN
    --2)����� ������ �޿��� ����
    select sal
    into v_sal
    from emp
    where empno = p_empno;
    --3)�޿��� ������ ���� ���
    IF
        v_sal < 1000 then v_pct := (v_sal*0.05);
    ELSIF
        v_sal < 2000 then v_pct := (v_sal*0.07);
    ELSIF
        v_sal < 3000 then v_pct := (v_sal*0.09);
    ELSE
        v_pct := (v_sal*0.12);
    END IF;
    
    RETURN(v_pct);
END emp_tax;

--4) �Լ� ȣ���غ���
SELECT ename, sal, emp_tax(empno) emp_rate
FROM emp;


--------------------EXCEPCTION ó��-------------------------------------
-- �ൿ���� : �μ���ȣ �Է� �ش� emp ����
-- SQL> EXECUTE DeptEmpSearch(50);
--  ��ȸȭ�� :   ���  : 1000
--             �̸�  : ������ 
-- ����ó��
-- �ΰ��� Row�� ��Ÿ���� ����
CREATE OR REPLACE PROCEDURE DeptEmpSearch
(p_deptno IN  emp.deptno%TYPE)
IS
    --ROW ��ü ����
    v_emp emp%ROWTYPE;
--  v_empno emp.empno%TYPE;
--  v_ename emp.ename%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT *
    INTO v_emp
    FROM emp
    WHERE deptno=p_deptno;
        DBMS_OUTPUT.PUT_LINE('��� : '|| v_emp.empno);
        DBMS_OUTPUT.PUT_LINE('�̸� : '|| v_emp.ename);
       
        ----- Multi Row Error
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERR CODE 1 : '|| TO_CHAR(SQLCODE));
        DBMS_OUTPUT.PUT_LINE('ERR CODE 2 : '|| SQLCODE);
        DBMS_OUTPUT.PUT_LINE('ERR MESSAGE : '|| SQLERRM);
END DeptEmpSearch;

---------------------------------------------------------
--  cursor �� �ڡڡڡڡڡڡڡڡڡڡڡڡ� pl/sql�� ���ǿ�
-- EXECUTE ���� �̿��� �Լ��� �����մϴ�.
-- SQL>EXECUTE show_emp3(7900);
---------------------------------------------------------
CREATE OR REPLACE PROCEDURE show_emp3
(p_empno    IN  emp.empno%TYPE)
IS  
    CURSOR emp_cursor IS
    SELECT ename, job, sal
    FROM emp
    WHERE empno LIKE p_empno||'%';
    
    v_ename emp.ename%TYPE;
    v_sal emp.sal%TYPE;
    v_job emp.job%TYPE;
BEGIN
    OPEN emp_cursor;
        DBMS_OUTPUT.PUT_LINE('�̸�    '|| '����'||'�޿�');
        DBMS_OUTPUT.PUT_LINE('----------------------');
    LOOP
        FETCH emp_cursor INTO v_ename, v_job, v_sal;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_ename||'    '|| v_job ||'     ' || v_sal);
    END LOOP;
        DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT|| '���� �� ����');
    CLOSE emp_cursor;
END;

-- 77 �Է��Ͽ� ������ �����
--�̸�    �����޿�
------------------------
--CLARK    MANAGER     2450
--SCOTT    ANALYST     3000
--2���� �� ����


-----------------------------------------------------------
--����Ŭ PL/SQL�� ���� �Ͼ�� ��� ���ܸ� �̸� ������ ��������, 
--�̷��� ���ܴ� �����ڰ� ���� ������ �ʿ䰡 ����.
--�̸� ���ǵ� ������ ����
-- NO_DATA_FOUND : SELECT���� �ƹ��� ������ ���� ��ȯ���� ���� ��
-- DUP_VAL_ON_INDEX : UNIQUE ������ ���� �÷��� �ߺ��Ǵ� ������ INSERT �� ��
-- ZERO_DIVIDE : 0���� ���� ��
-- INVALID_CURSOR : �߸��� Ŀ�� ����
-----------------------------------------------------------
CREATE OR REPLACE PROCEDURE PreException_test
(v_deptno IN emp.deptno%TYPE)
IS
    v_emp emp%ROWTYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT empno, ename, deptno
    INTO   v_emp.empno, v_emp.ename, v_emp.deptno
    FROM    emp
    WHERE   deptno = v_deptno;
    
    DBMS_OUTPUT.PUT_LINE('��� : '|| v_emp.empno);
    DBMS_OUTPUT.PUT_LINE('�̸� : '|| v_emp.ename);
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ : '|| v_emp.deptno);
    
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('�ߺ� �����Ͱ� �����մϴ�.');
                DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX���� �߻�');
    WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS���� �߻�');
    WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND���� �߻�');
    WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('��Ÿ ���� �߻�');
    
END;

--10�Է��� �����Ű�� �����߻�
--ORA-01422: exact fetch returns more than requested number of rows
--ORA-06512: at "SCOTT.PREEXCEPTION_TEST", line 7
--ORA-06512: at line 6
-- ���� EXCEPTIONó��


-----------------------------------------------------------
--������ ���� EXCEPTION
--���� �ӱ���  --> 1000���� �̻� 1000�� ���� ������ �����߻��ϰ� �Ұ���.
-----------------------------------------------------------
create or replace PROCEDURE in_emp
(p_name     IN   emp.ename%TYPE,
 p_sal     IN   emp.sal%TYPE,
 p_job     IN   emp.job%TYPE,
 p_deptno     IN   emp.deptno%TYPE
)
IS
    v_empno emp.empno%TYPE;
    lowsal_err  Exception;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT MAX(empno)+1
    INTO v_empno
    FROM emp ;
    IF  p_sal >= 1000 THEN
        INSERT INTO emp(  empno,  ename,   sal,   job,   deptno, hiredate)
                 VALUES(v_empno, p_name, p_sal, p_job, p_deptno, SYSDATE);
    ELSE
        RAISE lowsal_err;
    END IF;
    EXCEPTION
        WHEN lowsal_err THEN
        DBMS_OUTPUT.PUT_LINE('ERROR!!!-������ �޿��� �ʹ� �����ϴ�. 1000�̻����� �ٽ� �Է��ϼ���');      
END;










