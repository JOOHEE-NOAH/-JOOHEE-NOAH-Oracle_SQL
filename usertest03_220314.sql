--1.Admin: usertest03 ������ TableSpace user1 Mapping �� ���¿��� Table ����

CREATE TABLE DEPT
        (DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
         DNAME VARCHAR2(14),
	     LOC   VARCHAR2(13) ) ; --> system ������ �ƴ϶� user1��

-- 2. Result -> DEPT ���̺��� TableSpace�� user1 ���� �Ҵ�ȴ�.��