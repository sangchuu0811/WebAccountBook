CREATE TABLE BoardV02 (
	BOD_NO 		NUMBER(23),				-- 글번호
	BOD_WRITER	VARCHAR2(30), 			-- 글쓴이
	BOD_EMAIL	VARCHAR2(30), 			-- 이메일
	BOD_SUBJECT	VARCHAR2(100), 			-- 글제목
	BOD_PWD	VARCHAR2(30) NOT NULL, 		-- 글의 비밀번호
	BOD_LOGTIME	DATE DEFAULT sysdate,	-- 글을 쓴 날짜
	BOD_CONTENT	VARCHAR2(4000),			-- 글내용
	BOD_READCNT	NUMBER(23) default 0, 	-- 글의 조회수
	BOD_CONNIP	VARCHAR2(20)			-- 글쓴이의 IP
)

-- Sample Data 
insert into boardV02 values
    (1, '홍길동', '글 1', '글의 내용 1', '2017-07-30 10:10:11', 0);
insert into board values
    (2, '이순신', '글 2', '글의 내용 2', '2017-07-30 10:10:12', 0);
insert into board values
    (3, '강감찬', '글 3', '글의 내용 3', '2017-07-30 10:10:13', 0);
insert into board values
    (4, '김수로', '글 4', '글의 내용 4', '2017-07-30 10:10:14', 0);
insert into board values
    (5, '장길산', '글 5', '글의 내용 5', '2017-07-30 10:10:15', 0);
insert into board values
    (6, '김수로', '글 6', '글의 내용 6', '2017-07-30 10:10:16', 0);
insert into board values
    (7, '홍길동', '글 7', '글의 내용 7', '2017-07-30 10:10:17', 0);
insert into board values
    (8, '이순신', '글 8', '글의 내용 8', '2017-07-30 10:10:18', 0);
    
---------------------------------------------------------------------
-- db초기화
delete boardV02; 
purge recyclebin;

-- 선언
DECLARE
  TYPE sanameTab IS TABLE OF sawon.saname%TYPE 	
  INDEX BY BINARY_INTEGER;				
  sanameT sanameTab; 				

BEGIN
    FOR i IN 1 .. 255 LOOP 
       SELECT saname INTO sanameT(i) 		
       FROM sawon
       WHERE sabun = MOD(i, 20) + 1; 	
	   
       INSERT INTO boardV02 (BOD_NO, BOD_WRITER, BOD_EMAIL, BOD_SUBJECT, BOD_PWD, BOD_LOGTIME, BOD_CONTENT, BOD_READCNT, BOD_CONNIP)
       VALUES (i, sanameT(i),  sanameT(i) || '@test.com', sanameT(i) || ' 안녕하세요', '1234', sysdate-i, sanameT(i)||' 입니다.', 0, '0:0:0:0:0:0:0:1');
    END LOOP;
END;
/
