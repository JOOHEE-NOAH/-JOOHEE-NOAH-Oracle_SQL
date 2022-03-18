Create Or Replace Function func_sal
    (v_empno in number)
    RETURN number
IS
    PRAGMA AUTONOMOUS_TRANSACTION; --자동적으로 트랜잭션 처리 해줌(구글링)
    vsal emp.sal%type; -- emp table에 sal과 같은 타입
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