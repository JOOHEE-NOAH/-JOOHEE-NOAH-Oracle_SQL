----------------------------
--  DML
-----------------------------
-- Insert /update / delete / select
INSERT INTO DEPT VALUES(10,'인사','이대'); -- 값만 넣어도 순서대로 알아서 들억마 (값 순서대로 작성해야함)
INSERT INTO DEPT VALUES(11,'인사','이대');
INSERT INTO DEPT (deptno, dname, loc)
            values (51, '회계팀','충정로');
            ---pk null --> 오류
INSERT INTO DEPT (dname, loc)
values ('회계팀','충정로');
-- column 일부 누락
INSERT INTO DEPT (deptno, dname)
values (12, '경영팀');
commit;

INSERT INTO professor (profno, name, position, hiredate, deptno)
VALUES (9920 , '최윤식','조교수', TO_DATE('2006/01/01','yyyy/mm/dd'), 102);
INSERT INTO professor (profno, name, position, hiredate, deptno)
VALUES (9910 , '백미선','전임강사', sysdate, 101);

--table 생성
CREATE TABLE JOB3
( JOBNo     VARCHAR2(2)     PRIMARY KEY,
  JOBNAME   VARCHAR2(20)
);
-- Jobno jobname
--11, '공무원'
--12, '공기업'
INSERT INTO JOB3 (jobno, jobname)
VALUES (11, '공무원');
INSERT INTO JOB3 (jobno, jobname)
VALUES (12, '공기업');
INSERT INTO JOB3 VALUES (13, '대기업');
INSERT INTO JOB3 VALUES (14, '중소기업');
INSERT INTO JOB3 VALUES (10, '학교');

CREATE TABLE Religion
( ReligionNo     VARCHAR2(2)     CONSTRAINT PK_ReligionNo3 PRIMARY KEY,
  ReligionName   VARCHAR2(20)
);
-- ReligionNo  ReligionName
-- 10,          '기독교'
-- 20,          '카톨릭교'
-- 30,          '불교'

INSERT INTO Religion (religionno, religionname)
VALUES (10, '기독교');
INSERT INTO Religion VALUES (20, '카톨릭교');
INSERT INTO Religion VALUES (30, '불교');
INSERT INTO Religion VALUES (40, '무교');

-------------------------------------------------
--다중 행 입력
--------------------------------
-- 1. 생성된 TBL이용 신규 TBL 생성
--값까지 그대로 가져옴. 모든 스키마는 다 가지고 있고 제약조건은 생성이 안됨

create table dept_second
as
select * from dept;


-- 2. TBL 가공 생성
create table emp20
as select empno, ename, sal*12 annsal
    from emp
    where deptno = 20;
    
-- 3. TBL 구조만 (데이터 복사 x)
create table dept30
as select deptno, dname
    from dept
    where 0=1;

-- 4. Column 추가 Alter add
alter table dept30
add(birth Date);

--5 Column 변경 Alter modify
alter table dept30
modify dname varchar(20);

--6 Column 삭제 alter  drop
alter table dept30
drop column birth;

--7. TBL 명 변경 rename to
rename dept30 to dept35;

--8. TBL 제거 drop table : 존재자체가 날라감
drop table dept35;

--9. Truncate (ddl: 실행시킴과 동시에 커밋 따라서 롤백 안됨) 잘림. --> 구조는 있고 데이터는 없어짐
truncate table dept_second;

rollback;

--table 생성--->height_info / weight_info
create table height_info
( studNo        number(5),
  Name          varchar2(20),
  height        number(5,2)
);
create table weight_info
( studNo        number(5),
  Name          varchar2(20),
  weight        number(5,2)
);

insert all
into height_info values(studno, name, height)
into weight_info values(studno, name, weight)
select studno, name, height, weight
from student
where grade >= '2';

delete height_info;
delete weight_info;

-- 학생 테이블에서 2학년 이상의 학생을 검색하여 
-- height_info 테이블에는 키가 170보다 큰 학생의 학번, 이름, 키를 입력
-- weight_info 테이블에는 몸무게가 70보다 큰 학생의 학번, 이름, 몸무게를 
-- 각각 입력하여라
insert all
when height > 170 then
     into height_info values(studno, name, height)
when weight > 70 then
     into weight_info values(studno, name, weight)
select studno, name, height, weight
from student
where grade>='2';

--- Update 
-- 교수 번호가 9903인 교수의 현재 직급을 ‘부교수’로 수정하여라
update professor
set position ='부교수'
where profno = 9903;

-- 서브쿼리를 이용하여 학번이 10201인 학생의 학년과 학과 번호를
-- 10103 학번 학생의 학년과 학과 번호와 동일하게 수정하여라
update student
set (grade, deptno) = (select grade, deptno
                       from student
                       where studno = 10103
                       )
where studno = 10201;

-- 학생 테이블에서 학번이 20103인 학생의 데이터를 삭제
delete
from student
where studno = 20103;

-- 학생 테이블에서 컴퓨터공학과에 소속된 학생을 모두 삭제하여라.
delete student
where deptno=(select deptno
              from department
              where dname = '컴퓨터공학과'
              );

rollback;

------------------------------------
---- MERGE
------------------------------------

create table professor_temp
as select * from professor
    where position = '교수';
    
update professor_temp
set position = '명예교수'
where position='교수';

Insert into professor_temp
Values (9999,'김도경','arom21','전임강사',200,sysdate, 10, 101);

-- MERGE 개요
-- 구조가 같은 두개의 테이블을 비교하여 하나의 테이블로 합치기 위한 데이터 조작어
-- WHEN 절의 조건절에서 결과 테이블에 해당 행이 존재하면 UPDATE 명령문에 의해 새로운 값으로 수정,
-- 그렇지 않으면 INSERT 명령문으로 새로운 행을 삽입
-- 2. 상황 
  -- 1) 교수가 명예교수로 2행 Update
  -- 2) 김도경 씨가 신규 Insert

--3. merge  
merge into professor p
using professor_temp f
on  (p.profno=f.profno)
when matched then --pk가 같으면 직위를 update
    update set p.position = f.position
when not matched then --pk가 없으면 신규 insert
    insert values(f.profno, f.name, f.userid, f.position, f.sal, f.hiredate, f.comm, f.deptno);
    
----------------------------------
-- SEQUENCE ★★★
---------------------------------
create sequence sample_seq
increment by 1
start with 1;

-- Data 사전에서 정보 조회
select sequence_name, min_value, max_value, increment_by
from user_sequences;

select sample_seq.nextval from dual;
select sample_seq.currval from dual;

drop sequence dno_seq;
create sequence dno_seq
increment by 1
start with 1;

select dno_seq.nextval from dual;
select dno_seq.currval from dual; --CURRENT VALUE의 약자

insert into dept_second
values(dno_seq.nextval , 'Accounting', 'NEW YORK');
insert into dept_second
values((SELECT max(deptno)+1 from dept_second), 'Accounting', 'NEW YORK');

insert into dept_second
values(dno_seq.nextval , '회계' , '이대');

select dno_seq.currval from dual;

COMMENT ON COLUMN DEPT_SECOND.DNAME IS '부서명';

----------------------------------
-- Table 관리
---------------------------------
create table address
(   id      number(3),
    Name    varchar2(50),
    addr    varchar2(100),
    phone    varchar2(30),
    email    varchar2(100)

);

insert into address
values(1, 'HGDONG','SEOUL','123-4567', 'gdhong@naver.com');

create table addr_second(id, name, addr, phone, email)
    as select * from address;
create table addr_seven(id, name, addr, phone, email)
    as select * from address
    where '1'='2';

--주소록 테이블에서 id, name 컬럼만 복사하여 addr_third 테이블을 생성하여라
create table addr_third
    as select id, name from address;
    
select table_name from user_tables;
select owner,table_name from all_tables;

-------------------------------------
---- DeadLock
-------------------------------------
-- Transaction   A : Smith
-- seq 1 자원할당
update emp
set sal=sal*1.1
where empno = 7369;
-- seq 3 프로세스A
update emp
set sal=sal*1.1
where empno = 7839;

--transaction  B: King
-- seq 2 자원할당
update emp
set comm = 500
where empno = 7839;
-- seq 4 프로세스B
update emp
set comm = 300
where empno = 7369;



