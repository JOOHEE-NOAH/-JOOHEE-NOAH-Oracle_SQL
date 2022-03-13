SELECT studno, name, grade, deptno, weight
FROM student
WHERE grade=1 OR weight<=70;

--BETWEEN 연산자를 사용하여 몸무게가 50kg에서 70kg 사이인 학생의 학번, 이름, 몸무게를 출력하여라
SELECT studno, name, weight
FROM student
WHERE weight BETWEEN 50 AND 70;

--학생테이블에서 81년에서 83년도에 태어난 학생의 이름과 생년월일을 출력해라
SELECT name, birthdate
FROM student
WHERE birthdate between '81/01/01' AND '83/12/31';
--IN 연산자를 사용하여 102번 학과와 201번 학과 학생의 이름, 학년, 학과번호를 출력하여라
SELECT name, grade, deptno
FROM student
WHERE deptno = 102 OR deptno = 201;
--WHERE deptno IN (102,201); 가독성 때문에 in을 더 많이 사용

--학생 테이블에서 성이 ‘김’씨인 학생의 이름, 학년, 학과 번호를 출력하여라 ★★★★★★★★★★★★★★
SELECT name, grade, deptno
FROM student
WHERE name LIKE '김%';
--학생 테이블에서 이름이 3글자, 성은 ‘김’씨고 마지막 글자가 
--‘영’으로 끝나는 학생의 이름, 학년, 학과 번호를 출력하여라
SELECT name, grade, deptno
FROM student
WHERE name LIKE '김_영';

--NULL 이해 (nvl함수 사용하기):: null은 0값이 아니다. null값은 알 수 없다.
SELECT empno, ename, sal, comm, sal+comm hap
FROM emp
;
-- NVL(컬럼, 대체값) 함수를 이용하여 null값을 대체값으로 변경 ★★★★★★★★★★★★★★★★★★★★★
SELECT empno, ename, sal, comm, sal+NVL(comm,0) hap
FROM emp
;
--교수 테이블에서 이름, 직급, 보직수당을 출력하여라
SELECT name, position, comm
FROM professor
;

--교수 테이블에서 보직수당이 없는 교수의 이름, 직급, 보직수당을 출력하여라.
SELECT name, position, comm
FROM professor
WHERE comm = NULL;   --x 안됨

SELECT name, position, comm
FROM professor
WHERE comm IS NULL; --OK

--102번 학과의 학생 중에서 1학년 또는 4학년 학생의 이름, 학년, 학과 번호를 출력하여라.
SELECT name, grade, deptno
FROM student
WHERE deptno = 102 and grade in(1,4);
--WHERE deptno = 102 and (grade =1 or grade=4);

-- 집합 연산자 ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
--1학년 이면서 몸무게가 70kg 이상인 학생의 집합(stud_heavy) 테이블 생성
create table stud_heavy
AS
SELECT * 
FROM student
WHERE grade = 1
AND weight >=70
;

--1학년 이면서 101번 학과에 소속된 학생(stud_101)으로 구성된 테이블 생성
create table stud_101
AS
SELECT * 
FROM student
WHERE grade = 1
AND deptno = 101
;
--실행 x (컬럼의 수가 옳지 않기 때문)
SELECT studno, name
FROM stud_heavy
UNION
SELECT  studno, name, grade
FROM stud_101
;
--실행 ok 1 (컬럼의 수가 동일하므로 올바르게 실행됨) : UNION(중복되는 값은 한번만 출력) 사용 시 검색하고자 하는 컬럼의 수와 이름이 일치해야 한다
SELECT studno, name ,grade
FROM stud_heavy
UNION
SELECT  studno, name, grade
FROM stud_101
;
--실행 ok 2 (중복되는 것까지 모두 나옴)
SELECT studno, name ,grade
FROM stud_heavy
UNION ALL
SELECT  studno, name, grade
FROM stud_101
;
--실행 ok 3 (차집합: 중복되는 것 상쇄시켜 나오지않음): MINUS(두 집합간의 차집합) 사용 시 검색하고자 하는 컬럼의 수와 이름이 일치해야 한다
SELECT studno, name ,grade
FROM stud_heavy
MINUS
SELECT  studno, name, grade
FROM stud_101
;
--실행 ok 4 INTERSECT:(두 집합간의 교집합) 사용 시 검색하고자 하는 컬럼의 수와 이름이 일치해야 한다
SELECT studno, name ,grade
FROM stud_heavy
INTERSECT
SELECT  studno, name, grade
FROM stud_101
;

-- 소팅(정렬) ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
--SORTING 1 -> 오름차순 ASC(default 값)
SELECT name, grade, tel
FROM student
ORDER BY name ASC
;
--SORTING 2 -> 내림차순 DESC(생략안됨)
SELECT name, grade, tel
FROM student
ORDER BY name DESC
;
--SORTING 3 -> Multi sorting
--모든 사원의 이름과 급여 및 부서번호를 출력하는데, 
--부서 번호로 결과를 정렬한 다음 급여에 대해서는 내림차순으로 정렬하라
SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC
;

--과제1. 부서 10 또는 30에 속하는 모든 사원의 이름과 부서번호를 이름의 알파벳 순으로 정렬되도록 질의문을 형성하라
SELECT ename, deptno
FROM emp
WHERE deptno in (10,30)
ORDER BY ename ASC
;
--과제2. 1982년에 입사한 모든 사원의 이름과 입사일을 구하는 질의문
SELECT ename, hiredate
FROM emp
WHERE hiredate LIKE '82%';
--between '1982/01/01' and '1982/12/31';

--과제3. 보너스를 받는 모든 사원에 대해서 이름, 급여 그리고 보너스를 출력하는 질의문을 형성하라.  단 급여와 보너스에 대해서 내림차순 정렬
SELECT ename, sal, comm
FROM emp
WHERE comm is not null
ORDER BY sal DESC, comm DESC
;
--과제4. 보너스가 급여의 20% 이상이고 부서번호가 30인 많은 모든 사원에 대해서 이름, 급여 그리고 보너스를 출력하는 질의문을 형성하라
SELECT ename, sal, comm
FROM emp
WHERE comm>=sal*0.2
AND
deptno=30
; 

----------------------------------------------------
----- 07장 함수
------------------------------------------------------
--1.학생 테이블에서 ‘김영균’ 학생의 이름, 사용자 아이디를 출력하여라. 그리고 사용자 아이디의 첫 문자를 대문자로 변환하여 출력하여라
SELECT name, userid, INITCAP(userid)
FROM student
WHERE  name = '김영균'
;
--2.학생 테이블에서 학번이 ‘20101’인 학생의 사용자 아이디를 소문자와 대문자로 변환하여 출력하여라
SELECT userid, LOWER(userid), UPPER(userid)
FROM student
WHERE  studno = 20101
;
--3.부서 테이블에서 부서 이름의 길이를 문자 수와 바이트 수로 각각 출력하여라
SELECT dname, LENGTH(dname), LENGTHB(dname)
FROM department;

-- 4. 문자조작 함수 ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
    --1) concat 함수: 데이터의 연결 ★★★★★★★★★★★★★★★★★★★아주많이 사용
SELECT name, position, CONCAT(CONCAT(name, '의 직책은 '), position)
FROM professor;
    --2) SUBSTR함수★★★★★★★★SUBSTR(컬럼명 또는 데이터,첫번째글자부터,6개의 글자 추출)
    --학생 테이블에서 1학년 학생의 주민등록 번호에서 생년월일과 태어난 달을 추출하여 이름, 주민번호, 생년월일, 태어난 달을 출력하여라
SELECT name, idnum, SUBSTR(idnum,1,6) birth_date,
                    SUBSTR(idnum,3,2) birth_month
FROM student
WHERE grade = 1
;
    --3) INSTR 함수
    --부서 테이블의 부서 이름 칼럼에서 ‘과’ 글자의 위치를 출력하여라
SELECT dname, INSTR(dname,'과')
FROM department;
    
    --4) LPAD, RPAD 함수
    --교수테이블에서 직급 칼럼의 왼쪽에 ‘*’ 문자를 삽입하여 10바이트로 출력하고 교수 아이다 칼럼은 오른쪽에 ‘+’문자를 삽입하여 12바이트로 출력하여라
SELECT position, LPAD(position, 10, '*') lpad_position,
        userid, RPAD(userid, 12, '+') rpad_position
FROM    professor;

    --5)문자조작 함수  LTRIM, RTRIM 함수
    --부서 테이블에서 부서 이름의 마지막 글자인 ‘과’를 삭제하여 출력하여라
SELECT dname, RTRIM(dname, '과')
FROM department;

SELECT dname, LTRIM('    1234567', ' ') kk1, '    1234567' kk2
FROM department;

-------------------------------------------------------------------------------
--5. 숫자 함수 ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
-------------------------------------------------------------------------------
    --1)Round (지정한 자리 이하에서 반올림한 결과 값을 반환하는 함수)★★★★★★★
    --교수 테이블에서 101학과 교수의 일급을 계산(월 근무일은 22일)하여 소수점 첫째 자리와 셋째 자리에서 반올림 한 값과 
    --소숫점 왼쪽 첫째 자리에서 반올림한 값을 출력하여라 -1은 일의자리에서 반올림 -2는 백의 밑인 십의자리에서 반올림
 SELECT name, sal, sal/22, ROUND(sal/22), ROUND(sal/22,2), ROUND(sal/22,-1), ROUND(1234.567,-2)
 FROM professor
 WHERE deptno = 101;
 
    --2) 숫자함수 TRUNC 함수
    --교수 테이블에서 101학과 교수의 일급을 계산(월 근무일은 22일)하여 소수점 첫째 자리와 셋째 자리에서 절삭 한 값과
    --소숫점 왼쪽 첫째 자리에서 절삭한 값을 출력하여라
SELECT name, sal, sal/22, TRUNC(sal/22), TRUNC(sal/22,2), TRUNC(sal/22,-1)
 FROM professor
 WHERE deptno = 101;

    --3)숫자 함수  MOD 함수
    --교수 테이블에서 101번 학과 교수의 급여를 보직수당으로 나눈 나머지를 계산하여 출력하여라
SELECT name, sal, comm, MOD(sal, comm), MOD(100,17)
 FROM professor
 WHERE deptno = 101;

    --4) 숫자 함수 Ceil(올림): 크거나 같은 정수중 최소값추출 , Floor 함수(내림):작거나 같은 정수중 최대값 추출
    SELECT CEIL(19.7), FLOOR(-12.745), Trunc(-12.745)
    FROM dual;

-------------------------------------------------------------------------------
-- 6. 날짜 함수 ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
-------------------------------------------------------------------------------
    --1)교수 번호가 9908인 교수의 입사일을 기준으로 입사 30일 후와 60일 후의 날짜를 출력하여라
SELECT name, hiredate, hiredate+30, hiredate+60
FROM professor
;
SELECT sysdate, sysdate+28, sysdate+29
FROM dual
;

