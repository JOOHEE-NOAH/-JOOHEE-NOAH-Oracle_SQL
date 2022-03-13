----------------------------------------------------
---------------------CH09.JOIN----------------------
----------------------------------------------------
-- 학번이 10101인 학생의 이름과 소속 학과 이름을 출력하여라
-- 1. 소속학과 검색
SELECT studno, name, deptno
FROM student
WHERE studno = 10101;
-- 2. 학과를 가지고 학과이름
SELECT dname
FROM department
WHERE deptno = 101;
-- 1+2 ==> 조인을 이용한 학생이름과 학과이름 검색
SELECT studno, name,
       student.deptno, department.dname
FROM student, department
WHERE student.deptno = department.deptno
;
--> = 앞뒤에 (+) 다 없는것이 equi 조인
-- 애매모호성 (ambiguously)
SELECT studno, name, deptno, dname
FROM student, department
WHERE student.deptno = department.deptno
;

-- 애매모호성 (ambiguously) 해결  --> 별명(alias)을 붙여줌 
SELECT s.studno, s.name, d.deptno, d.dname
FROM student s, department d
WHERE s.deptno = d.deptno
;
-- 전인하’ 학생의 학번, 이름, 학과 이름 그리고 학과 위치를 출력
SELECT s.studno, s.name, d.dname, d.loc
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    s.name='전인하'
-- 몸무게가 80kg이상인 학생의 학번, 이름, 체중, 학과 이름, 학과위치를 출력
SELECT s.studno, s.name, s.weight, d.dname, d.loc
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    s.weight >= 80
-- 카티션 곱 두 개 이상의 테이블에 대해 연결 가능한 행을 모두 결합
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM student s, department d;
--카티션 곱 = CROSS JOIN
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM student s CROSS JOIN department d;

-- Natural Join
SELECT s.studno, s.name, d.dname, d.loc, s.weight, deptno
FROM student s
     NATURAL JOIN department d;
-- EQUI JOIN = Inner Join
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM student s, department d
WHERE s.deptno = d.deptno

-- Natural Join
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM student s
     NATURAL JOIN department d;

-- NATURAL JOIN을 이용하여 교수 번호, 이름, 학과 번호, 학과 이름을 출력하여라
SELECT p.profno, p.name, deptno, d.dname
FROM professor p
     NATURAL JOIN department d;

-- NATURAL JOIN을 이용하여 4학년 학생의 이름, 학과 번호, 학과이름을 출력하여라
SELECT s.name, s.grade, deptno, d.dname
FROM student s
     NATURAL JOIN department d
WHERE s.grade = 4;

-- JOIN ~ USING 절을 이용하여 학번, 이름, 학과번호, 학과이름, 학과위치를 출력하여라 (조건 : name -->김씨성을 가진)
SELECT s.studno, s.name, deptno, dname
FROM   student s JOIN department
       USING (deptno)
WHERE s.name LIKE '김%';

-- NON-EQUI JOIN *
-- 교수 테이블과 급여 등급 테이블을 NON-EQUI JOIN하여 교수별로 급여 등급을 출력하여라
SELECT p.profno, p.name, p.sal, s.grade
FROM professor p, salgrade s
WHERE p.sal BETWEEN s.losal AND s.hisal;
---------------------------------------------------
----- OUTER JOIN        
---------------------------------------------------
SELECT e.empno, e.ename, d.deptno, d.dname
FROM   emp e, dept d
WHERE  e.deptno = d.deptno (+) -- LEFT O.J
;
-- 학생 테이블과 교수 테이블을 조인하여 이름, 학년, 지도교수의 이름, 직급을 출력
-- 단, 지도교수가 배정되지 않은 학생이름도 함께 출력하여라.
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno = p.profno(+)
ORDER BY p.profno;

--- ANSI OUTER JOIN
-- 1. ANSI LEFT OUTER JOIN
SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       LEFT OUTER JOIN professor p
       ON s.profno = p.profno;
-- 2. ANSI RIGHT OUTER JOIN
SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       RIGHT OUTER JOIN professor p
       ON s.profno = p.profno;
-- 3. ANSI FULL OUTER JOIN
SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       RIGHT OUTER JOIN professor p
       ON s.profno = p.profno;

-- FULL OUTER 모방   --> Union
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno = p.profno(+)
UNION
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno(+) = p.profno

--부서 테이블의 SELF JOIN **
SELECT c.deptno, c.dname, c.college, d.dname college_name
     --학과           학부
FROM department c, department d
WHERE c.college = d.deptno;
-- 부서 번호가 201 이상인 부서 이름과 상위 부서의 이름을 출력
-- 결과 : xxx소속은 xxx학부

--내답안
SELECT concat(concat(c.dname,'의 소속은 '), d.dname)
FROM department c, department d
WHERE c.college = d.deptno
AND c.deptno>=201

--쌤답안
SELECT dept.dname||'의 소속은 '||org.dname
FROM department dept, department org
WHERE dept.college = org.deptno
AND dept.deptno >= 201;

-- SALGRADE2 생성
 CREATE TABLE "SCOTT"."SALGRADE2" 
   (   "GRADE" NUMBER(2,0), 
        "LOSAL" NUMBER(5,0), 
        "HISAL" NUMBER(5,0), 
         CONSTRAINT "PK_GRADE2" PRIMARY KEY ("GRADE")
        )

-- 1. 이름, 관리자명(emp TBL)
select w.ename, m.ename
from emp w, emp m
where w.mgr = m.empno
    -- 1) CLARK 관리자 사번 
    select   w.ename , w.mgr
    from    emp w
    where   w.empno = 7782; 
    -- 2) CLARK 관리자 사번 을 이용한 이름
    select   m.ename
    from    emp m
    where   m.empno = 7839;


-- 2. 이름,급여,부서코드,부서명,근무지, 관리자 명, 전체직원(emp ,dept TBL)
select w.ename, w.sal, w.deptno, d.dname, d.loc, m.ename 관리자
from   emp w, emp m, dept d
where  w.mgr = m.empno(+) 
AND    w.deptno = d.deptno;
-- ansi 방법
select w.ename, w.sal, w.deptno, d.dname, d.loc, m.ename 관리자
from   emp w
       left outer join emp m on w.mgr = m.empno
       left outer join dept d on w.deptno = d.deptno

-- 3. 이름,급여,등급,부서명,관리자명, 급여가 1500이상인 사람
--    (emp, dept,salgrade2 TBL)
select w.ename, w.sal, s.grade, d.dname, m.ename
from emp w, emp m, dept d, salgrade2 s
WHERE w.mgr = m.empno 
AND w.deptno = d.deptno 
AND w.sal BETWEEN s.losal AND s.hisal --(범위조인)
AND w.sal >= 1500;

-- 4. 보너스를 받는 사원에 대하여 이름,부서명,위치를 출력하는 SELECT 문장을 작성emp ,dept TBL)
select e.ename, d.dname, d.loc
from emp e, dept d
where e.deptno = d.deptno
and e.comm is not null

-- 5. 사번, 사원명, 부서코드, 부서명을 검색하라. 사원명기준으로 오름차순정열(emp ,dept TBL)
select e.empno, e.ename, d.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno
order by e.ename asc;

------------------------------------------------
----- SUB Query
------------------------------------------------
--  1. 목표 : 교수 테이블에서 ‘전은지’ 교수와 직급이 동일한 모든 교수의 이름 검색
--       1-1 교수 테이블에서 ‘전은지’ 교수의 직급 검색 SQL 명령문 실행
--       1-2 교수 테이블의 직급 칼럼에서 1 에서 얻은 결과 값과 동일한 직급을 가진 교수 검색 명령문 실행
-- 1-1
SELECT position
FROM professor
WHERE name = '전은지'

-- 1-2
SELECT name, position
FROM professor
WHERE position = '전임강사'

-- 단일 행 Sub Query
-- 1. SUB Query (1-1) + (1-2)
select name, position
from professor
where position = (
      -- 1-1
      select position 
      from professor 
      where name='전은지'
      )

-- 사용자 아이디가 ‘jun123’인 학생과 같은 학년인 학생의 학번, 이름, 학년을 출력하여라
select studno, name, grade
from student
where grade = (select grade from student where userid = 'jun123')

-- 101번 학과 학생들의 평균 몸무게보다 몸무게가 적은 학생의 이름, 학과번호, 몸무게를 
-- 출력\
select name, grade, deptno, weight
from student
where weight < (
                select AVG(weight) 
                from student 
                where deptno=101
                )
order by deptno
-- 20101번 학생과 학년이 같고, 키는 20101번 학생보다 큰 학생의 
-- 이름, 학년, 키를 출력하여라
select name, grade, height
from student
where grade = (select grade 
               from student 
               where studno = 20101)
and height > (select height 
              from student 
              where studno = 20101)
order by deptno

----------------------------------------
----- 다중 행 ★★★★
----------------------------------------
-- 1.  IN 연산자를 이용한 다중 행 서브쿼리
SELECT name, grade, deptno
FROM student
WHERE deptno IN (
                SELECT deptno
                FROM department
                WHERE college = 100
                )
-- 위와 같은 의미
SELECT name, grade, deptno
FROM   student
WHERE  deptno IN (
                  101,102
               );

-- 2. ANY 연산자를 이용한 다중 행 서브쿼리
SELECT studno, name, height 
FROM student
WHERE height > ANY (
                    -- 175, 176, 177
                    SELECT height
                    FROM student
                    WHERE grade = '4'
                    )
                    
-- 3. ANY 연산자를 이용한 다중 행 서브쿼리
SELECT studno, name, height 
FROM student
WHERE height > ALL (
                    SELECT height
                    FROM student
                    WHERE grade = '4'
                    )
--- 4. EXISTS 연산자를 이용한 다중 행 서브쿼리 ★★★
SELECT profno, name, sal, comm, position
FROM   professor
WHERE EXISTS (
            SELECT position
            FROM professor
            WHERE comm IS NOT NULL
            );

-- PAIRWISE 다중 칼럼 서브쿼리
-- PAIRWISE 비교 방법에 의해 학년별로 몸무게가 최소인 
-- 학생의 이름, 학년, 몸무게를 출력하여라
SELECT name, grade, weight
FROM student
WHERE (grade, weight) IN ( SELECT grade, MIN(weight)
                           FROM student
                           GROUP BY grade);

-- 상호연관 서브쿼리 ***★★★★★★★★★
-- 메인쿼리절과 서브쿼리간에 검색 결과를 교환하는 서브쿼리
-- 예시 각 학과 학생의 평균 키보다 키가 큰 학생의 이름, 학과 번호, 키를 출력하여라
SELECT deptno, name, grade, height
FROM student s1
WHERE height > ( SELECT AVG(height)
                 FROM student s2
                 WHERE s2.deptno = s1.deptno
                )
ORDER BY deptno
;

-- 101 171.125
-- 102 168
-- 201 176
SELECT AVG(height)
FROM student s2
WHERE s2.deptno = 101 

-------------------  HomeWork --------------------------
-- 1. Blake와 같은 부서에 있는 모든 사원에 대해서 사원 이름과 입사일을 디스플레이하라
SELECT ename, hiredate, deptno
FROM   emp
WHERE  deptno = ( SELECT deptno
                  FROM   emp
                  WHERE INITCAP(ename) = 'Blake'
                  );
-- 2. 평균 급여 이상을 받는 모든 사원에 대해서 사원 번호와 이름을 디스플레이하는 질의문을 생성. 
--    단 출력은 급여 내림차순 정렬하라
SELECT empno, ename, sal
from emp e1
where sal >= (select avg(sal)
              from emp e2
              )
order by sal desc;              
-- 3. 보너스를 받는 어떤 사원의 부서 번호와 
--    급여에 일치하는 사원의 이름, 부서 번호 그리고 급여를 디스플레이하라.
select ename, deptno, sal
from emp
where (deptno,sal) in ( SELECT deptno,sal
            FROM emp
            WHERE comm IS NOT NULL);





















