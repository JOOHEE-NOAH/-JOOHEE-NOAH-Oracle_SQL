----------------------------------------------------------------------------
------------------      제약조건 (constraint)   -------------------------------
----------------------------------------------------------------------------
create table subject(
    subno        number(5)      constraint subject_no_pk        primary key,
    subname      varchar2(20)   constraint subject_name_nn      not null,
    term         varchar2(1)    constraint subject_term_ck      check(term in('1','2'))
); -- term = 1 or term = 2

--Success
insert into subject (subno, subname, term)
            values(10000,'전산학개론','1');       
insert into subject (subno, subname, term)--> subname과 term이 같더라도 subno이라는 pk가 중복되지 않아 가능.
            values(10001,'전산학개론','1');

-- Fail 1-->unique constraint (SCOTT.SUBJECT_NO_PK) violated 고유성 위반
insert into subject (subno, subname, term)
            values(10000,'전산학개론2','2');
-- Fail 2-->cannot insert NULL into ("SCOTT"."SUBJECT"."SUBNAME") not null 위반
insert into subject (subno, term)
            values(10000,'1');
-- Fail 3-->check constraint (SCOTT.SUBJECT_TERM_CK) violated 
insert into subject (subno, subname, term)
            values(10003,'전산학개론','3');
            
--제약조건 (Constraint) 개발중 추가 발견 경우
alter table student
add constraint stud_idnum_uk unique(idnum);

alter table student
modify (name constraint stud_name_nn not null);

--constraint 조회
select CONSTRAINT_name, CONSTRAINT_Type
from user_CONSTRAINTs
where table_name in ('SUBJECT', 'STUDNET');


----------------------------------------------------------------------------
------------------      INDEX   -------------------------------
----------------------------------------------------------------------------
-- 1. Emp--> ename Index
create index idx_emp_name on emp(ename);
--2. index 조회
select index_name , table_name, column_name
from user_ind_columns;
--3. 조회
select * from emp where ename = 'SMITH';

--- Optimizer
--- 1) RBO(rule based optimizer): 정해진 규칙대로만 실행  2) CBO(cost based optimizer)
--RBO 변경
ALTER SESSION SET OPTIMIZER_MODE=RULE;

-- CBO 변경
ALTER SESSION SET OPTIMIZER_MODE=CHOOSE;

-- 고유 Index
CREATE UNIQUE INDEX IDX_DEPT_DNO ON dept_second(deptno);

--결합 index
create index IDX_DEPT_COM ON dept_second(dname, loc);


-- stud_101테이블의 deptno와 name 칼럼으로 결합 인덱스를 생성하여라.
-- 단, deptno 칼럼을 내림차순으로 name 칼럼은 오름차순으로 생성하여라.
--idx_stud101_no_name (index 명)
create index idx_stud101_no_name ON stud_101(deptno DESC, name ASC);

-- -- FBI (Funtion Based Index) 함수로 인덱스 만들기
create index IDX_EMP_ANNSAL
ON emp(sal*12+NVL(comm,0));

-------------------------------------
-----       문제           -----------
-------------------------------------
-- 1. 부서 테이블[department]에서 dname 칼럼을 고유 인덱스로 생성하여라. 
--    단  , 고유 인덱스의 이름을 idx_dept_name으로 정의
create unique index idx_dept_name on department(dname);
-- 2.학생 테이블[student]의 birthdate 칼럼을 비고유 인덱스로 생성.
-- 비고유 인덱스의 이름은 idx_stud_birthdate로 정의
CREATE INDEX idx_stud_birthdate ON student(birthdate);
-- 3.학생 테이블[stud_101]의 deptno, grade 칼럼을 결합 인덱스로 생성.
-- 결합 인덱스의 이름은 idx_stud101_dno_grade 로 정의
create index idx_stud101_dno_grade ON stud_101(deptno, grade);
-- 4. emp20 의 ename을 대문자로 FBI, 인덱스의 이름은 emp20_uppercase_idx
create index emp20_uppercase_idx ON emp20(upper(ename));

select * from emp20 where upper(ename) ='SMITH';

-- 학생 테이블에 생성된 PK_STUDNO 인덱스를 재구성 / REBUILD 하면 성능이 훨씬 빨라짐
ALTER INDEX PK_STUDNO REBUILD;

--학생 테이블에 생성한 fidx_stud_no_name 인덱스를 삭제하여라
DROP INDEX fidx_stud_no_name;

-----------------------------------------------------------------------------------------
--   11. View 
------------------------------------------------------------------------------
-- View : 하나 이상의 기본 테이블이나 다른 뷰를 이용하여 생성되는 가상 테이블
--        뷰는 데이터딕셔너리 테이블에 뷰에 대한 정의만 저장
--        Performance(성능)은 더 저하 
--        목적 : 보안

create or replace view VIEW_PROFESSOR AS
SELECT profno, name, userid, position, hiredate, sal, deptno
from professor;

--view 제거
drop view VIEW_PROFESSOR;

-- select
select * from VIEW_PROFESSOR;

-- userid 제거 --> 재생성
create or replace view VIEW_PROFESSOR AS
SELECT profno, name, position, hiredate, deptno
from professor;

select * from VIEW_PROFESSOR;

--뷰(논리적인 컬럼들로만 구성)에 insert 해도 물리적인 데이터는 물리적인 테이블(원래테이블)로 들어간다 
insert into VIEW_PROFESSOR values(2000, 'view', 'userid', 'position', sysdate, 101);

--제약조건 위반(sal>180) sal:170 -->check constraint (SCOTT.PROFESSOR_CHK1) violated
insert into VIEW_PROFESSOR values(2010, 'view', 'userid', 'position', sysdate, 170, 101);


--------------   VIEW v_emp_sample
--------------   해당 column  : empno , ename , job, mgr,deptno  (emp)
create or replace VIEW v_emp_sample 
AS
SELECT empno , ename , job, mgr, deptno
from emp;

create or replace VIEW v_emp_complex 
AS
SELECT *
from emp natural join dept; --equi 조인과 같다

---문1)  학생 테이블에서 101번 학과 학생들의 학번, 이름, 학과 번호로 정의되는 단순 뷰를 생성
---     뷰 명 :  v_stud_dept101
create or replace view v_stud_dept101 
as
select studno, name, deptno
from student
where deptno=101;

--문2) 학생 테이블과 부서 테이블을 조인하여 102번 학과 학생들의 학번, 이름, 학년, 학과 이름으로 정의되는 복합 뷰를 생성
--      뷰 명 :   v_stud_dept102
create or replace VIEW v_stud_dept102 
AS
SELECT studno, name, grade, dname
from student natural join department 
where deptno=102; natural 조인 방식

create or replace VIEW v_stud_dept102 
AS
SELECT s.studno, s.name, s.grade, d.dname
from student s, department d
where s.deptno=d.deptno
and s.deptno=102; --equi 조인 방식

--문3)  교수 테이블에서 학과별 평균 급여와     총계로 정의되는 뷰를 생성
--  뷰 명 :  v_prof_avg_sal       Column 명 :   avg_sal      sum_sal
create or replace VIEW v_prof_avg_sal
AS
select deptno, round(avg(sal)) avg_sal, sum(sal) sum_sal
from professor
group by deptno;
 
