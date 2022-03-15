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


--------------------EXCEPCTION 처리-------------------------------------
-- 행동강령 : 부서번호 입력 해당 emp 정보
-- SQL> EXECUTE DeptEmpSearch(50);
--  조회화면 :   사번  : 1000
--             이름  : 강감찬 
-- 예외처리
-- 두개의 Row가 나타날수 있음
CREATE OR REPLACE PROCEDURE DeptEmpSearch
(p_deptno IN  emp.deptno%TYPE)
IS
    --ROW 객체 선언
    v_emp emp%ROWTYPE;
--  v_empno emp.empno%TYPE;
--  v_ename emp.ename%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT *
    INTO v_emp
    FROM emp
    WHERE deptno=p_deptno;
        DBMS_OUTPUT.PUT_LINE('사번 : '|| v_emp.empno);
        DBMS_OUTPUT.PUT_LINE('이름 : '|| v_emp.ename);
       
        ----- Multi Row Error
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERR CODE 1 : '|| TO_CHAR(SQLCODE));
        DBMS_OUTPUT.PUT_LINE('ERR CODE 2 : '|| SQLCODE);
        DBMS_OUTPUT.PUT_LINE('ERR MESSAGE : '|| SQLERRM);
END DeptEmpSearch;

---------------------------------------------------------
--  cursor 문 ★★★★★★★★★★★★★ pl/sql의 끝판왕
-- EXECUTE 문을 이용해 함수를 실행합니다.
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
        DBMS_OUTPUT.PUT_LINE('이름    '|| '업무'||'급여');
        DBMS_OUTPUT.PUT_LINE('----------------------');
    LOOP
        FETCH emp_cursor INTO v_ename, v_job, v_sal;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_ename||'    '|| v_job ||'     ' || v_sal);
    END LOOP;
        DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT|| '개의 행 선택');
    CLOSE emp_cursor;
END;

-- 77 입력하여 나오는 결과물
--이름    업무급여
------------------------
--CLARK    MANAGER     2450
--SCOTT    ANALYST     3000
--2개의 행 선택


-----------------------------------------------------------
--오라클 PL/SQL은 자주 일어나는 몇가지 예외를 미리 정의해 놓았으며, 
--이러한 예외는 개발자가 따로 선언할 필요가 없다.
--미리 정의된 예외의 종류
-- NO_DATA_FOUND : SELECT문이 아무런 데이터 행을 반환하지 못할 때
-- DUP_VAL_ON_INDEX : UNIQUE 제약을 갖는 컬럼에 중복되는 데이터 INSERT 될 때
-- ZERO_DIVIDE : 0으로 나눌 때
-- INVALID_CURSOR : 잘못된 커서 연산
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
    
    DBMS_OUTPUT.PUT_LINE('사번 : '|| v_emp.empno);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| v_emp.ename);
    DBMS_OUTPUT.PUT_LINE('부서번호 : '|| v_emp.deptno);
    
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('중복 데이터가 존재합니다.');
                DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX에러 발생');
    WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS에러 발생');
    WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND에러 발생');
    WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('기타 에러 발생');
    
END;

--10입력해 실행시키면 오류발생
--ORA-01422: exact fetch returns more than requested number of rows
--ORA-06512: at "SCOTT.PREEXCEPTION_TEST", line 7
--ORA-06512: at line 6
-- 따라서 EXCEPTION처리


-----------------------------------------------------------
--개발자 정의 EXCEPTION
--최저 임금제  --> 1000만원 이상 1000만 이하 들어오면 에러발생하게 할거임.
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
        DBMS_OUTPUT.PUT_LINE('ERROR!!!-지정한 급여가 너무 적습니다. 1000이상으로 다시 입력하세요');      
END;

-----------------------------------------------------
-- Fetch 문 
-- SQL> EXECUTE  Cur_sal_Hap (20);
-- CURSOR 문 이용 구현 
-- 부서만큼 반복 
-- 	부서명 : ACCOUNTING
-- 	인원수 : 5
-- 	급여합 : 5000
-- 	데이터 입력 성공
-----------------------------------------------------
create or replace PROCEDURE Cur_sal_Hap
(p_deptno    IN  emp.deptno%TYPE)
IS  
    CURSOR dept_sum IS
    SELECT dname, Count(*) cnt, SUM(sal) sumSal
    FROM emp e, Dept d
    WHERE e.deptno = d.deptno 
    AND e.deptno LIKE p_deptno||'%'
    GROUP BY dname;

    v_dname dept.dname%TYPE;
    v_cnt number;
    v_sumSal number;
BEGIN
    DBMS_OUTPUT.ENABLE;
    OPEN dept_sum;
    LOOP
        --3.FETCH단계
        FETCH dept_sum INTO v_dname, v_cnt, v_sumSal;
        EXIT WHEN dept_sum%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('부서명 : ' || v_dname);
        DBMS_OUTPUT.PUT_LINE('인원수 : ' || v_cnt);
        DBMS_OUTPUT.PUT_LINE('급여합 : ' || v_sumSal);
    END LOOP;

    CLOSE dept_sum;
END Cur_sal_Hap;


-----------------------------------------------------------
-- FOR문을 사용하면 커서의 OPEN, FETCH, CLOSE가 자동 발생하므로 
-- 따로 기술할 필요가 없고, 레코드 이름도 자동
-- 선언되므로 따로 선언할 필요가 없다. FOR문 변환
--실제 개발자들이 많이 사용하는 방법
-----------------------------------------------------------
CREATE OR REPLACE PROCEDURE ForCursor_Test
IS
-- Cursor 선언
-- ACCOUNTING	3	9250
-- OPERATIONS	2	8000
-- 인사팀      	2	5000
-- RESEARCH	    5	10955
-- SALES	    6	9250
CURSOR dept_sum IS
        SELECT b.dname, COUNT(a.empno) cnt, SUM(a.sal) salary
        FROM emp a, dept b
        WHERE a.deptno = b.deptno
        GROUP BY b.dname;
BEGIN
    DBMS_OUTPUT.ENABLE;
    
    --cursor를 for문에서 실행시킨다.
    FOR emp_list IN dept_sum LOOP
            DBMS_OUTPUT.PUT_LINE('부서명 : ' || emp_list.dname);
            DBMS_OUTPUT.PUT_LINE('인원수 : ' || emp_list.cnt);
            DBMS_OUTPUT.PUT_LINE('급여합 : ' || emp_list.salary);
    END LOOP;
    
    EXCEPTION
    WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(SQLERRM||'에러 발생');
END;

--결과는 아래와 같이 나옴.
--부서명 : ACCOUNTING
--인원수 : 3
--급여합 : 8750
--부서명 : OPERATIONS
--인원수 : 2
--급여합 : 7000
--부서명 : 인사팀
--인원수 : 2
--급여합 : 5000
--부서명 : RESEARCH
--인원수 : 5
--급여합 : 10955
--부서명 : SALES
--인원수 : 6
--급여합 : 9400

-------------------------------------------------------------------
-------    Trigger 
-------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trigger_test
BEFORE
UPDATE ON dept
FOR EACH ROW -- old, new 사용하기 위해
BEGIN
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('변경 전 컬럼 값 : ' || :old.dname);
    DBMS_OUTPUT.PUT_LINE('변경 후 컬럼 값 : ' || :new.dname);
END;

UPDATE dept
SET loc = '신촌3'
WHERE deptno = 41;

-- 상단 메뉴-> 보기 -> DBMS 출력 -> DBMS 출력 창에서 + 에서 선택하고 update 실행.
