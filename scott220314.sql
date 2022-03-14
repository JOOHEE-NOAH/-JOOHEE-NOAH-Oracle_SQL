-------------------------------------
---- 계층적 질의문
-------------------------------------
-- 계층적 질의문을 사용하여 부서 테이블에서 학과,학부,단과대학을 검색하여 단대,학부
-- 학과순으로 top-down(자식을 먼저 내놓고 그담에 부모) 형식의 계층 구조로 출력하여라. 단, 시작 데이터는 10번 부서
select deptno, dname, college
from department
start with deptno = 10
connect by prior deptno = college;

-- 계층적 질의문을 사용하여 부서 테이블에서 학과,학부,단과대학을 검색하여 학과,학부
-- 단대 순으로 bottom-up 형식의 계층 구조로 출력하여라. 단, 시작 데이터는 102번 부서이다
select deptno, dname, college
from department
start with deptno = 102
connect by prior college = deptno;

--- 계층적 질의문을 사용하여 부서 테이블에서 부서 이름을 검색하여 단대, 학부, 학과순의
--- top-down 형식으로 출력하여라. 단, 시작 데이터는 ‘공과대학’이고,
--- 각 레벨별로 우측으로 2칸 이동하여 출력 (레벨 1: 루트/ 부모(대학) , 레벨2: 부모/자식(학부), 레벨 3: 최하위(과))
                      -->공백중 하나 *로 채워라
SELECT LPAD(' ', (LEVEL-1)*2,'*') || dname 조직도   
FROM department
START WITH dname = '공과대학'
CONNECT BY PRIOR deptno = college;

--          보여줄문자열 / 보여지는 길이  / 남은길이 채워지는 문자      
SELECT LPAD('abcd',         5        ,'*') FROM dual;

-- FK
-- 1) Restrict : 자식 존재 삭제 안됨
-- 2) SET NULL
-- 3) Cascading Delete : 같이 죽자
insert into dept values(50, 'OPERATIONS', 'BOSTON');

INSERT INTO EMP VALUES
(1010,'FK Test1','CLERK', 7902, TO_DATE('17-12-1980','DD-MM-YYYY'),800,NULL,50);

-- 1) 기본--> restrict : 자식 존재 삭제 안됨.
DELETE dept
where deptno = 50;

-- 2) SET NULL로 설정 --> 부모쪽 행은 사라지고 자식의 외래키는 null이 됨
DELETE dept
where deptno = 50;

-- 3) Cascading Delete : 같이 죽자
DELETE dept
where deptno = 50;

--------------------------------------------
-------  ★★   PL/SQL  ★★--------------
--------------------------------------------
--- 1. 함수(Function)
--- 특정한 수에 세금을 7%로 계산하는 Function을 작성하면
create or replace FUNCTION tax
    (p_num in number) -- Parameter
RETURN number         -- Return Value
Is
    v_tax number;     -- 변수 선언
BEGIN                 --함수 시작
--세금 7%
    v_tax := p_num * 0.07;
    RETURN(v_tax);
END;

--is 와 begin 사이에 변수 선언을 해준다. 변수라는 의미로 v_로 많이 작성한다.
-- begin과 end 사이에 로직을 구성한다. =이 아니라 :=임을 명심!

--2.함수호출
select tax(200) from dual;

select profno , name, sal, tax(sal)
from professor;


--------------------------------------------------------------
-- Procedure
-- 1. 파라메타 : (p_deptno , p_dname ,   p_loc)
-- 2. dept TBL에 Insert Procedure
--------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Dept_Insert
    (p_deptno in dept.deptno%type, --dept.deptno%type: dept테이블에서 deptno의 data_type이 어떻든 똑같이 해줘라. 라는 뜻
     p_dname in dept.dname%type,
     p_loc in dept.loc%type)
IS
BEGIN
    INSERT into dept VALUES(p_deptno, p_dname, p_loc);
    COMMIT;
END;
    








