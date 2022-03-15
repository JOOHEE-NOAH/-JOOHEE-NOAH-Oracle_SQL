-------------------------------문제1--------------------------------------
-- SQL> EXECUTE Dept_Search(7900);
-- Sales 부서 사원입니다.
-- SQL> EXECUTE Dept_Search(7566); : 우마우스 실행으로 사번 입력해보기
-- ACCOUNTING 부서 사원입니다.
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
    
    DBMS_OUTPUT.PUT_LINE(v_dname || ' 부서 사원입니다. ');
    
END;


-------------------문제2---------------------------------------
-- PROCEDURE Delete_Test
-- SQL> EXECUTE Delete_Test(7900);
-- 사원번호 : 7900
-- 사원이름 : JAMES
-- 입 사 일 : 81/12/03
-- 데이터 삭제 성공
--  1. Parameter : 사번 입력
--  2. 사번 이용해 사원번호 ,사원이름 , 입 사 일 출력
--  3. 사번 해당하는 데이터 삭제 
----------------------------------------------------------
CREATE OR REPLACE PROCEDURE Delete_Test
(p_empno IN emp.empno%TYPE)
IS  --삭제 데이터를 확인하기위한 변수 선언
    v_empno     emp.empno%TYPE;
    v_ename     emp.ename%TYPE;
    v_hiredate  emp.hiredate%TYPE;
    
BEGIN
    DBMS_OUTPUT.ENABLE;
    --삭제할 데이터 확인용 쿼리
    SELECT empno, ename, hiredate
    INTO v_empno, v_ename, v_hiredate
    FROM    emp
    WHERE   empno = p_empno;
    DBMS_OUTPUT.PUT_LINE('사원번호 : '||v_empno);
    DBMS_OUTPUT.PUT_LINE('사원이름 : '||v_ename);
    DBMS_OUTPUT.PUT_LINE('입사일 : '||v_hiredate);
    
    DELETE
    FROM    emp
    WHERE   empno = p_empno;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('데이터 삭제 성공');
    
END Delete_test;

----------------------문제 3-------------------------------
--  Procedure up_emp 실행 결과
-- SQL> EXECUTE up_emp(7654);  -- 사번 
-- 결과 : 급여 인상 저장
--              시작문자
-- 조건  1) job = SALE포함         v_pct : 10
--      2)          MAN          v_pct : 7  
--      3)                       v_pct : 5
--   job에 따른 급여 인상을 수행  sal = sal+sal*v_pct/100
-- 확인 : DB -> TBL
-----------------------------------------------------
CREATE OR REPLACE PROCEDURE up_emp
(p_empno IN emp.empno%TYPE)
IS
    v_job emp.job%TYPE;
    v_pct number(3);  --퍼센트는 세자리를 안넘어가기 때문에 버퍼를 줄이기 위해서 3으로 설정. 퍼센트 처럼 확실한 경우에는 선언 해주긴 하는데 그냥 number해도 무관.
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
    DBMS_OUTPUT.PUT_LINE('급여 인상 저장');
END up_emp;

------------------------문제 4------------------------------------
--  EMP 테이블에서 사번을 입력받아 해당 사원의 급여에 따른 세금을 구함.
-- 급여가 1000 미만이면 급여의 5%, 
-- 급여가 2000 미만이면 7%, 
-- 3000 미만이면 9%, 
-- 그 이상은 12%로 세금
--- FUNCTION  emp_tax
-- 1) Parameter : 사번
-- 2) 사번을 가지고 급여를 구함
-- 3) 급여를 가지고 세율 계산 
-- 4) 계산 된 값 Return   number
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION emp_tax
    (p_empno IN emp.empno%TYPE)  --1) Parameter :사번
RETURN number
IS
    v_sal emp.sal%TYPE;
    v_pct number(3);
BEGIN
    --2)사번을 가지고 급여를 구함
    select sal
    into v_sal
    from emp
    where empno = p_empno;
    --3)급여를 가지고 세율 계산
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

--4) 함수 호출해보기
SELECT ename, sal, emp_tax(empno) emp_rate
FROM emp;
    