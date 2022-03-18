Create Or Replace Function func_sal
    (v_empno in number)
    RETURN number
IS
    PRAGMA AUTONOMOUS_TRANSACTION; --�ڵ������� Ʈ����� ó�� ����(���۸�)
    vsal emp.sal%type; -- emp table�� sal�� ���� Ÿ��
BEGIN
    UPDATE emp SET sal=sal*1.1
    WHERE empno=v_empno;
    commit;
    SELECT sal INTO vsal
    FROM emp
    WHERE empno=v_empno;
    RETURN vsal;
END;

SELECT func_sal(3100) FROM dual;