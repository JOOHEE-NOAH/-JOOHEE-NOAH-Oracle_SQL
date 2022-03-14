--1.Admin: usertest03 생성후 TableSpace user1 Mapping 된 상태에서 Table 생성

CREATE TABLE DEPT
        (DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
         DNAME VARCHAR2(14),
	     LOC   VARCHAR2(13) ) ; --> system 영영이 아니라 user1에

-- 2. Result -> DEPT 테이블의 TableSpace가 user1 으로 할당된다.★