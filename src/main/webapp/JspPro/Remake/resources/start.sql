-- USERS와 CATEGORIES 테이블 삭제
DROP TABLE USER_CATEGORIES CASCADE CONSTRAINTS;
DROP TABLE EXPENSES CASCADE CONSTRAINTS;
DROP TABLE MY_USERS CASCADE CONSTRAINTS;
Drop table board;

PURGE RECYCLEBIN;

-- MY_USERS 테이블
CREATE TABLE MY_USERS (
  USER_ID     VARCHAR2(50) PRIMARY KEY,
  USER_NAME   VARCHAR2(50) NOT NULL,
  USER_BIRTH  DATE NOT NULL,
  CREATED_AT  DATE DEFAULT TRUNC(SYSDATE)
);

-- DEMO 사용자
INSERT INTO MY_USERS (USER_ID, USER_NAME, USER_BIRTH)
VALUES ('h1234', '홍길동', TO_DATE('2000-01-01', 'YYYY-MM-DD'));

-- EXPENSES 테이블
CREATE TABLE EXPENSES (
  EXP_ID        NUMBER PRIMARY KEY,
  USER_ID       VARCHAR2(50),
  EXP_DATE      DATE,
  EXP_ITEM      VARCHAR2(100),
  EXP_MONEY     NUMBER,
  EXP_TYPE      VARCHAR2(10),
  EXP_CATEGORY  VARCHAR2(50),
  EXP_MEMO      VARCHAR2(200),
  CONSTRAINT FK_USER_ID_EXP FOREIGN KEY (USER_ID) REFERENCES MY_USERS(USER_ID)
);

INSERT INTO EXPENSES (EXP_ID, USER_ID, EXP_DATE, EXP_ITEM, EXP_MONEY,EXP_TYPE, EXP_CATEGORY, EXP_MEMO)
VALUES(0, 'h1234', '2025-05-01', '샘플 데이터', 500000, '수입', '식비', '샘플 데이터');
INSERT INTO EXPENSES (EXP_ID, USER_ID, EXP_DATE, EXP_ITEM, EXP_MONEY,EXP_TYPE, EXP_CATEGORY, EXP_MEMO)
VALUES(1, 'h1234', '2025-05-02', '샘플 데이터', 50000, '지출', '문화생활', '샘플 데이터');

-- USER_CATEGORIES 테이블
CREATE TABLE USER_CATEGORIES (
  CATEGORY_ID   NUMBER PRIMARY KEY,
  USER_ID       VARCHAR2(50),
  CATEGORY_NAME VARCHAR2(50),
  CONSTRAINT FK_USER_ID_CAT FOREIGN KEY (USER_ID) REFERENCES MY_USERS(USER_ID)
);

-- 사용자별 카테고리 추가를 위한 시퀀스
CREATE SEQUENCE USER_CAT_SEQ START WITH 8 INCREMENT BY 1;
CREATE TABLE board (
  num     NUMBER PRIMARY KEY,
  writer  VARCHAR2(50),
  title   VARCHAR2(100),
  content VARCHAR2(4000),
  regtime DATE,
  hits    NUMBER
);

SET SERVEROUTPUT ON;

DECLARE
  CURSOR name_cur IS
    SELECT saname FROM sawon WHERE ROWNUM <= 20;

  name_arr    DBMS_SQL.VARCHAR2_TABLE;
  idx         PLS_INTEGER := 0;
  total_count CONSTANT PLS_INTEGER := 255;
  name_count  PLS_INTEGER := 0;
BEGIN

  DELETE FROM board;

  FOR n IN name_cur LOOP
    name_arr(name_count) := n.saname;
    name_count := name_count + 1;
  END LOOP;

FOR i IN 0..total_count - 1 LOOP
  idx := MOD(i, name_count); 

	INSERT INTO board (
	  num,
	  writer,
	  title,
	  content,
	  regtime,
	  hits
	) VALUES (
	  255 - i,  -- 최신 글일수록 높은 번호
	  name_arr(idx),
	  name_arr(idx) || ' 가계부 작성했습니다.',
	  (i + 1) || '번째 가계부 작성했습니다.',
	  SYSDATE - i,
	  0
	);
END LOOP;


  COMMIT;
  DBMS_OUTPUT.PUT_LINE('총 ' || total_count || '개의 게시글이 생성되었습니다.');
END;
/
COMMIT;
