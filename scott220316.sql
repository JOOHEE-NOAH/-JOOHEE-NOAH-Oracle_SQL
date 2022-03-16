-------------------------------------------------------------------
-------    Trigger 
-------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trigger_test
BEFORE
UPDATE ON dept
FOR EACH ROW -- old, new 사용하기 위해
BEGIN
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('변경 전 컬럼 값 : ' || :old.loc);
    DBMS_OUTPUT.PUT_LINE('변경 후 컬럼 값 : ' || :new.loc);
END;

UPDATE dept
SET loc = '합정2'
WHERE deptno = 41;

--실행결과 보기: 상단 메뉴-> 보기 -> DBMS 출력 -> DBMS 출력 창에서 + 에서 scott선택하고 update 실행.


----------------------------------------------------------
--문제 ) emp Table의 급여가 변화시
--       화면에 출력하는 Trigger 작성( emp_sal_change)
--       emp Table 수정전
--      조건 : 입력시는 empno가 0보다 커야함

--출력결과 예시
--     이전급여  : 10000
--     신  급여  : 15000
 --    급여 차액 :  5000
----------------------------------------------------------
CREATE OR REPLACE TRIGGER emp_sal_change
BEFORE DELETE OR INSERT OR UPDATE ON emp
FOR EACH ROW
    WHEN (new.empno > 0 )
    DECLARE
        sal_diff number;
BEGIN
    sal_diff    := :new.sal - :old.sal;
    dbms_output.put_line('사번 : ' || :old.empno);
    dbms_output.put_line('이름 : ' || :old.ename);
    dbms_output.put_line('이전 급여 : ' || :old.sal);
    dbms_output.put_line('신   급여 : ' || :new.sal);
    dbms_output.put_line('급여 차액 : ' || sal_diff);
END;
    
UPDATE emp
SET    sal = 2000
WHERE  empno = 1002
;

-----------------------------------------------------------
--  EMP 테이블에 INSERT,UPDATE,DELETE문장이 하루에 몇 건의 ROW가 발생되는지 조사
--  조사 내용은 EMP_ROW_AUDIT에 
--  ID ,사용자 이름, 작업 구분,작업 일자시간을 저장하는 
--  트리거를 작성
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

--4. 수정 시 emp_row_aud 결과 학인
UPDATE emp
SET    ename = 'trigger'
WHERE  empno = 1002;
--emp의 데이터 변경시 (insert,update,delete)시 변경내역을 emp_row_audit에 저장됨.

INSERT INTO emp(empno, ename, sal, deptno)
        VALUES(3000,'강희준', 3500, 40);
INSERT INTO emp(empno, ename, sal, deptno)
        VALUES(3100,'김주희', 3400, 40);
DELETE emp WHERE empno = 1004;
