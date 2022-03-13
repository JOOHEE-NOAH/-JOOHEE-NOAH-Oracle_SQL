SELECT sysdate
FROM dual;--dual: 3바이트를 가지고 있는 임시테이블. select 컬럼 from 테이블의 문법을 맞춰주기 위해 사용.


-- 입사한지 120개월 미만인 교수의 교수번호, 입사일, 입사일로부터 현재일까지의 개월 수,
-- 입사일에서 6개월 후의 날짜를 출력하여라
SELECT profno, name, hiredate,
       MONTHS_BETWEEN(sysdate, hiredate) dur_date,
       ADD_MONTHS(hiredate, 6)    Add_6
FROM professor
WHERE MONTHS_BETWEEN(sysdate, hiredate)< 120;
-- 오늘이 속한 달의 마지막 날짜와 다가오는 일요일의 날짜를 출력하여라
SELECT sysdate, LAST_DAY(sysdate), NEXT_DAY(sysdate, '일')
FROM dual;
-- 101번 학과 교수들의 입사일을 일, 월, 년을 기준으로 반올림하여 출력하여라
-- ROUND 'dd' 쓰면 12시 기준으로 날짜 반올림
-- mm 기준으로 1~15일은 해당 달 1일 16일부터는 다음달 1일
-- yy  기준으로 1~6월은 해당 년 1월1일 7~12는 다음해 1월1일
SELECT hiredate,
       TO_CHAR(hiredate, 'YY/MM/DD HH24:MI:SS') hiredate,
       TO_CHAR(ROUND(hiredate,'dd'), 'YY/MM/DD') round_dd,
       TO_CHAR(ROUND(hiredate,'mm'), 'YY/MM/DD') round_mm,
       TO_CHAR(ROUND(hiredate,'yy'), 'YY/MM/DD') round_yy
FROM professor
WHERE deptno = 101;
-- 학생 테이블에서 전인하 학생의 학번과 생년월일 중에서 년월만 출력하여라
SELECT studno, birthdate, TO_CHAR(birthdate, 'YY/MM') birthdate
FROM student
WHERE name = '전인하'
;
-- 교수 테이블에서 101번 학과 교수들의 이름, 직급, 입사일을 출력하여라
SELECT name, position, TO_CHAR(hiredate, 'YY/MM/dd') hiredate
FROM professor
WHERE deptno=101
;
--보직수당을 받는 교수들의 이름, 급여, 보직수당, 그리고 급여와 보직수당을 더한 값에 12를 곱한 결과를 연봉으로 출력하여라
SELECT name, sal, comm, TO_CHAR((sal+comm)*12, '9,999') anual_sal
FROM professor
WHERE comm IS NOT NULL;

--To_number
select to_number('100.00') num
from dual;

--NVL2 함수  ->nvl이 if라면, nvl2는 If esle가 함께있는것
--102번 학과 교수중에서 보직수당을 받는 사람은 급여와 보직수당을 더한 값을 급여 총액으로 출력하여라. 
--단, 보직수당을 받지 않는 교수는 급여만 급여 총액으로 출력하여라
--(해당값이 널이 아니면, 이 값이 실행, 널이면 이값이 실행)
--(comm이 널인가?, 널이 아니면 sal+comm실행, 널이면  sal 실행)
select  name, position, sal, comm,
        NVL2(comm, sal+comm, sal) sal_hap
from professor
where deptno= 102
;
--NULLIF 함수
--교수 테이블에서 이름의 바이트 수와 사용자 아이디의 바이트 수를 비교해서 
--같으면 NULL을 반환하고 같지 않으면 이름의 바이트 수를 반환하여라
--nullif(컬럼1, 컬럼2)-->컬럼1과 2를 비교하여 그 값이 같으면 null,아니면 컬럼1의 값이 나옴
select  name, userid, LENGTHB(name), LENGTHB(userid),
        NULLIF( LENGTHB(name), LENGTHB(userid)) nullif_result
        
from professor;

--COALESCE 함수
--교수 테이블에서 보직수당이 NULL이 아니면 보직수당을 출력하고,
--보직수당이 NULL이고 급여가 NULL이 아니면 급여를 출력, 보직수당과 급여가 NULL이면 0을 출력하여라
--if  else if else
--COALESCE(x,y,z) x가 null이 아니면 x값 출력, x가 null이고 y가 null이 아니면 y값 출력, 둘다 null이면 x 출력 
select  name, comm, sal,
        COALESCE(comm,sal,0) co_hap
from professor
;

--★★★★★★★Decode ★★★★★★★★★★★★★★★★★★★★★★★★★★개중요
--교수 테이블에서 교수의 소속 학과 번호를 학과 이름으로 변환하여 출력하여라. 
--학과 번호가 101이면 ‘컴퓨터공학과’, 102이면 ‘멀티미디어학과’, 201이면 ‘전자공학과’, 
--나머지 학과 번호는 ‘기계공학과’(default)로 변환한다.

select  name, deptno,
        DECODE(deptno, 101, '컴퓨터공학과'
                     , 102, '멀티미디어학과'
                     , 201, '전자공학과'
                          , '기계공학과') deptname
from professor
;

--case★★★★★★★★★★★★★★★★★★★★★★★★★★개중요
--교수 테이블에서 소속 학과에 따라 보너스를 다르게 계산하여 출력하여라.학과 번호별로 보너스는 다음과 같이 계산한다. 
--학과 번호가 101이면 보너스는 급여의 10%, 102이면 20%, 201이면 30%, 나머지 학과는 0%이다
select  name, deptno, sal,
        CASE WHEN deptno = 101 THEN sal*0.1
             WHEN deptno = 102 THEN sal*0.2
             WHEN deptno = 201 THEN sal*0.3
             ELSE                   0
        END  bonus     
from professor;

-------------------------과제1 ---------------------------------------
--1. salgrade 데이터 전체 보기
select *
from salgrade;

--2. scott에서 사용가능한 테이블 보기
select *
from tab;

--3. emp Table에서 사번 , 이름, 급여, 업무, 입사일
select empno , ename , sal, job, hiredate
from emp;
--4. emp Table에서 급여가 2000미만인 사람 에 대한 사번, 이름, 급여 항목 조회
select empno , ename , sal
from emp
where sal < 2000;

--5. emp Table에서 81/02이후에 입사한 사람에 대한  사번,이름,업무,입사일 
select empno , ename , job, hiredate
from emp
where hiredate>='81/02/01';

--6. emp Table에서 급여가 1500이상이고 3000이하 사번, 이름, 급여  조회
select empno , ename , sal
from emp
where sal >=1500
and sal<=3000 ;
--=where sal between 1500 and 3000;

--7. emp Table에서 사번, 이름, 업무, 급여 출력 [ 급여가 2500이상이고
--   업무가 MANAGER인 사람]
select empno , ename , sal
from emp
where sal >=2500
and job='MANAGER' ;

--8. emp Table에서 이름, 급여, 연봉 조회 [단 조건은  연봉 = (급여+상여) * 12  , null을 0으로 변경]
select empno , ename , sal, (sal+nvl(comm,0)) * 12 연봉
from emp;

--9. emp Table에서  81/02 이후에 입사자들중 xxx는 입사일이 xxX
--  [ 전체 Row 출력 ]
select  concat(concat(concat(ename,'는 입사일이'),hiredate),'이다')
from emp
where hiredate>='81/02/01';

select  ename || '는 입사일이' || hiredate || '이다'
from emp
where hiredate>='81/02/01';

--10.emp Table에서 이름속에 T가 있는 사번,이름 출력
select empno, ename
from emp
where ename like '%T%';

--11.82년에 입사한 사람 전체 컬럼 출력
select *
from emp
where hiredate between '82/01/01' and '82/12/31';
--=where hiredate like '82%';

--12.2022년에 입사한 사람 전체 컬럼 출력
select * from emp where to_char(hiredate,'yyyy') = '2022';

--------------------과제 2--------------------------------
--1. emp Table 의 이름을 대문자, 소문자, 첫글자만 대문자로 출력
select UPPER(ename), LOWER(ename), INITCAP(ename)
from emp
;
--2. emp Table 의  이름, 업무, 업무를 2-5사이 문자 출력
select ename, job, SUBSTR(job,2,4)
from emp
;
--3. emp Table 의 이름, 이름을 10자리로 하고 왼쪽에 #으로 채우기
select ename, LPAD(ename, 10 ,'#')
from emp
;
-- 4. emp Table 의  이름, 업무, 업무가 MANAGER면 관리자로 출력
select ename, job, DECODE(job, 'MANAGER', '관리자')
from emp 
;--> decode nanager만 관리자로 바꿔 출력하고 job값은 null로 출력
select ename, job, Replace(job,'MANAGER','관리자')
from emp
;-->decode nanager를 관리자로 바꿔 출력하고 나머지 job값은 원래값으로 출력

--5. emp Table 의  이름, 급여/7을 각각 정수, 소숫점 1자리. 10단위로   반올림하여 출력
select ename, round(sal/7), round(sal/7,1),round(sal/7,-1)
from emp
;
--6. 5번을 참조하여 절사하여 출력
select ename, sal/7, trunc(sal/7), trunc(sal/7,1),trunc(sal/7,-1)
from emp
;
--7. emp Table 의  이름, 급여/7한 결과를 반올림,절사,ceil,floor
select ename, sal/7, round(sal/7), trunc(sal/7), ceil(sal/7), floor(sal/7)
from emp
;
--8. emp Table 의  이름, 급여, 급여/7한 나머지
select ename, sal, mod(sal,7)
from emp
;
--9. emp Table 의 이름, 급여, 입사일, 입사기간(각각 날자,월)출력,  소숫점 이하는 반올림★★★
select  ename, sal, hiredate, 
        round(sysdate-hiredate) 입사기간_일
        ,round(MONTHS_BETWEEN(sysdate, hiredate)) 입사기간_월 
from emp;

--10.emp Table 의  job 이 'CLERK' 일때 10% ,'ANALYSY' 일때 20% 
--                                 'MANAGER' 일때 30% ,'PRESIDENT' 일때 40%
--                                 'SALESMAN' 일때 50% 
--                                 그외일때 60% 인상 하여 
--   empno, ename, job, sal, 및 각 인상 급여를 출력하세요(CASE/Decode문 사용)★★★★★
select  empno, ename, job, sal,
        CASE WHEN job = 'CLERK' THEN sal*1.1
             WHEN job = 'ANALYSY' THEN sal*1.2
             WHEN job = 'MANAGER' THEN sal*1.3
             WHEN job = 'PRESIDENT' THEN sal*1.4
             WHEN job = 'SALESMAN' THEN sal*1.5
             ELSE                   sal*1.6
        END  인상급여     
from emp;

select  empno, ename, job, sal,
        decode(job,'CLERK',sal*1.1
                  ,'ANALYSY',sal*1.2
                  ,'MANAGER',sal*1.3
                  ,'PRESIDENT',sal*1.4
                  ,'SALESMAN',sal*1.5
                  ,sal*1.6
                  ) 인상급여
from emp;

---------------------------------------------------------------------------
--------ch08 Group 함수★★★★★--------------------------------------------------
---------------------------------------------------------------------------
--101번 학과 교수중에서 보직수당을 받는 교수의 수를 출력하여라.
--count(*)  --> 널값은 세지 않는다
select count(*)
from professor
where deptno = 101;

--count(컬럼)  --> 컬럼에 대해서는 널값을 세지 않는다
select count(comm)
from professor
where deptno = 101;

--101번 학과 학생들의 몸무게 평균과 합계를 출력하여라.
select avg(weight), sum(weight)
from student
where deptno = 101;

--102번 학과 학생 중에서 최대 키와 최소 키를 출력하여라
select max(height), min(height)
from student
where deptno = 102;

--통계함수 앞에 컬럼은 그 컬럼별 통계를 의미. 따라서 그룹별로 묶어준다.(group by)
select max(height), min(height)
from student
group by deptno
;
--교수 테이블에서 학과별로 교수 수와 보직수당을 받는 교수 수를 출력하여라
select deptno, count(*), count(comm) 
from professor
group by deptno
;

--학과별로 소속 교수들의 평균급여, 최소급여, 최대급여를 출력하여라.
select avg(sal) 평균급여, min(sal) 최소급여, max(sal) 최대급여
from professor
group by deptno
;

--전체 학생을 소속 학과별로 나누고, 같은 학과 학생은 다시 학년별로 그룹핑하여, 학과와 학년별 인원수, 평균 몸무게를 출력하여라, 단, 평균 몸무게는 소수점 이하 첫번째 자리에서 반올림 한다.
select deptno, grade, count(*), ROUND(AVG(weight))
from student
group by deptno, grade
order by deptno, grade
;

--소속 학과별로 교수 급여 합계와 모든 학과 교수들의 급여 합계를 출력하여라
SELECT deptno, sum(sal)
from professor
group by rollup(deptno)
;

--ROLLUP 연산자를 이용하여 학과 및 직급별 교수 수, 학과별 교수 수, 전체 교수 수를 출력하여라
SELECT deptno, position, count(*)
from professor
group by rollup(deptno, position)
;

--cube 연산자
--rollup에 의한 그룹 결과와 group by 절에 기술된 조건에 따라 그룹 조합을 만드는 연산자

--★★★★★★★having 절 :GROUP BY 절에 의해 생성된 그룹을 대상으로 조건을 적용
--학생 수가 4명이상인 학년에 대해서 학년, 학생 수, 평균 키, 평균 몸무게를 출력하여라.
--단, 평균 키와 평균 몸무게는 소수점 첫 번째 자리에서 반올림 하고,
--출력순서는 평균 키가 높은 순부터 내림차순으로 출력하여라.
select grade, count(*), round(avg(height)), round(avg(weight))
from student
group by grade
HAVING COUNT(*)>=4
order by avg(height) DESC;
--

--------------------과제 3--------------------------------
--1. 최근 입사 사원과 가장 오래된 사원의 입사일 출력 (emp)
select max(hiredate) max_hiredate, min(hiredate) min_hiredate
from emp;

select to_char(max_hiredate,'yyyy/mm/dd'), to_char(min_hiredate,'yyyy/mm/dd')
from    (select max(hiredate) max_hiredate, min(hiredate) min_hiredate
        from emp
        ) sub_emp
     ;   
---- 2. 부서별 최근 입사 사원과 가장 오래된 사원의 입사일 출력 (emp)
select deptno, max(hiredate), min(hiredate)
from emp
GROUP BY deptno
;
-- 3.한개 이상 Column 적용 --> 부서별, 직업별 count & sum[급여]    (emp)
select deptno, job, count(*), sum(sal)
from emp
group by deptno, job
;
-- 4.부서별 급여총액 3000이상 부서번호,부서별 급여최대★★★★★★    (emp)
select deptno, max(sal)
from emp
group by deptno
having sum(sal)>=3000;


-- 5.전체 학생을 소속 학과별로 나누고, 같은 학과 학생은 다시 학년별로 그룹핑하여, 
--   학과와 학년별 인원수, 평균 몸무게를 출력, 
-- (단, 평균 몸무게는 소수점 이하 첫번째 자리에서 반올림 )  STUDENT

select deptno, grade, count(*), round(avg(weight))
from student
group by deptno, grade;
--order by deptno;








