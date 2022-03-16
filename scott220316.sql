-------------------------------------------------------------------
-------    Trigger 
-------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trigger_test
BEFORE
UPDATE ON dept
FOR EACH ROW -- old, new ����ϱ� ����
BEGIN
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : ' || :old.loc);
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : ' || :new.loc);
END;

UPDATE dept
SET loc = '����2'
WHERE deptno = 41;

--������ ����: ��� �޴�-> ���� -> DBMS ��� -> DBMS ��� â���� + ���� scott�����ϰ� update ����.


----------------------------------------------------------
--���� ) emp Table�� �޿��� ��ȭ��
--       ȭ�鿡 ����ϴ� Trigger �ۼ�( emp_sal_change)
--       emp Table ������
--      ���� : �Է½ô� empno�� 0���� Ŀ����

--��°�� ����
--     �����޿�  : 10000
--     ��  �޿�  : 15000
 --    �޿� ���� :  5000
----------------------------------------------------------
CREATE OR REPLACE TRIGGER emp_sal_change
BEFORE DELETE OR INSERT OR UPDATE ON emp
FOR EACH ROW
    WHEN (new.empno > 0 )
    DECLARE
        sal_diff number;
BEGIN
    sal_diff    := :new.sal - :old.sal;
    dbms_output.put_line('��� : ' || :old.empno);
    dbms_output.put_line('�̸� : ' || :old.ename);
    dbms_output.put_line('���� �޿� : ' || :old.sal);
    dbms_output.put_line('��   �޿� : ' || :new.sal);
    dbms_output.put_line('�޿� ���� : ' || sal_diff);
END;
    
UPDATE emp
SET    sal = 2000
WHERE  empno = 1002
;

-----------------------------------------------------------
--  EMP ���̺� INSERT,UPDATE,DELETE������ �Ϸ翡 �� ���� ROW�� �߻��Ǵ��� ����
--  ���� ������ EMP_ROW_AUDIT�� 
--  ID ,����� �̸�, �۾� ����,�۾� ���ڽð��� �����ϴ� 
--  Ʈ���Ÿ� �ۼ�
-----------------------------------------------------------
-- 1. SEQUENCE
-- DROP SEQUENCE emp_row_seq;
CREATE SEQUENCE emp_row_seq;
--2. Audit Table
--DROP TABLE emp_row_audit;
CREATE TABLE emp_row_audit(
    e_id        NUMBER(6)       CONSTRAINT emp_row_pk PRIMARY KEY,
    e_name      VARCHAR2(30),
    e_gubun     VARCHAR2(10),
    e_date      DATE
);
-- 3. Trigger
CREATE OR REPLACE TRIGGER emp_row_aud
AFTER DELETE OR INSERT OR UPDATE ON emp
FOR EACH ROW
    BEGIN
        IF INSERTING THEN
            INSERT INTO emp_row_audit
                VALUES(emp_row_seq.NEXTVAL, :new.ename, 'inserting', SYSDATE);
        ELSIF UPDATING THEN
            INSERT INTO emp_row_audit
                VALUES(emp_row_seq.NEXTVAL, :old.ename, 'updating', SYSDATE);
        ELSIF DELETING THEN
            INSERT INTO emp_row_audit
                VALUES(emp_row_seq.NEXTVAL, :old.ename, 'deleting', SYSDATE);
        END IF;
END;

--4. ���� �� emp_row_aud ��� ����
UPDATE emp
SET    ename = 'trigger'
WHERE  empno = 1002;
--emp�� ������ ����� (insert,update,delete)�� ���泻���� emp_row_audit�� �����.

INSERT INTO emp(empno, ename, sal, deptno)
        VALUES(3000,'������', 3500, 40);
INSERT INTO emp(empno, ename, sal, deptno)
        VALUES(3100,'������', 3400, 40);
DELETE emp WHERE empno = 1004;
