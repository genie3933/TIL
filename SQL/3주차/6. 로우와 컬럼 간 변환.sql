## 로우를 컬럼으로 변환하기

-- SCORE_TABLE 생성
CREATE TABLE SCORE_TABLE (
	YEARS VARCHAR2(4),
	GUBUN VARCHAR2(30),
	SUBJECTS VARCHAR2(30),
	SCORE NUMBER);

-- 데이터 입력
INSERT INTO score_table VALUES('2020','중간고사','국어',92);
INSERT INTO score_table VALUES('2020','중간고사','영어',87);
INSERT INTO score_table VALUES('2020','중간고사','수학',67);
INSERT INTO score_table VALUES('2020','중간고사','과학',80);
INSERT INTO score_table VALUES('2020','중간고사','지리',93);
INSERT INTO score_table VALUES('2020','중간고사','독일어',82);
INSERT INTO score_table VALUES('2020','기말고사','국어',88);
INSERT INTO score_table VALUES('2020','기말고사','영어',80);
INSERT INTO score_table VALUES('2020','기말고사','수학',93);
INSERT INTO score_table VALUES('2020','기말고사','과학',91);
INSERT INTO score_table VALUES('2020','기말고사','지리',89);
INSERT INTO score_table VALUES('2020','기말고사','독일어',83);
COMMIT;


### CASE 문 사용하는 경우

SELECT YEARS, GUBUN,
    SUM(국어) AS 국어,
    SUM(영어) AS 영어,
    SUM(수학) AS 수학,
    SUM(과학) AS 과학,
    SUM(지리) AS 지리,
    SUM(독일어) AS 독일어
FROM ( SELECT YEARS, GUBUN,
	CASE WHEN SUBJECTS = '국어' THEN SCORE ELSE 0 END 국어,
	CASE WHEN SUBJECTS = '영어' THEN SCORE ELSE 0 END 영어,
	CASE WHEN SUBJECTS = '수학' THEN SCORE ELSE 0 END 수학,
	CASE WHEN SUBJECTS = '과학' THEN SCORE ELSE 0 END 과학,
	CASE WHEN SUBJECTS = '지리' THEN SCORE ELSE 0 END 지리,
	CASE WHEN SUBJECTS = '독일어' THEN SCORE ELSE 0 END 독일어
FROM SCORE_TABLE A)
GROUP BY YEARS, GUBUN;


### DECODE 사용하는 경우

SELECT YEARS, GUBUN,
    	SUM(국어) AS 국어, 
	SUM(영어) AS 영어, 
	SUM(수학) AS 수학,
   	SUM(과학) AS 과학, 
	SUM(지리) AS 지리, 
	SUM(독일어) AS 독일어
FROM ( SELECT years, gubun,
    DECODE(subjects,'국어',score,0) "국어",
    DECODE(subjects,'영어',score,0) "영어",
    DECODE(subjects,'수학',score,0) "수학",
    DECODE(subjects,'과학',score,0) "과학",
    DECODE(subjects,'지리',score,0) "지리",
    DECODE(subjects,'독일어',score,0) "독일어"
    FROM SCORE_TABLE A)
GROUP BY YEARS, GUBUN;


### WITH 절 사용하는 경우

WITH MAINS AS ( SELECT YEARS, GUBUN,
        CASE WHEN SUBJECTS='국어' THEN SCORE ELSE 0 END 국어,
        CASE WHEN SUBJECTS='영어' THEN SCORE ELSE 0 END 영어,
        CASE WHEN SUBJECTS='수학' THEN SCORE ELSE 0 END 수학,
        CASE WHEN SUBJECTS='과학' THEN SCORE ELSE 0 END 과학,
        CASE WHEN SUBJECTS='지리' THEN SCORE ELSE 0 END 지리,
        CASE WHEN SUBJECTS='독일어' THEN SCORE ELSE 0 END 독일어
        FROM SCORE_TABLE A
        )
SELECT YEARS, GUBUN,
        SUM(국어) AS 국어,
        SUM(영어) AS 영어,
        SUM(수학) AS 수학,
        SUM(과학) AS 과학,
        SUM(지리) AS 지리,
        SUM(독일어) AS 독일어
FROM MAINS
GROUP BY YEARS, GUBUN;


### PIVOT 절 사용하는 경우

- 구문 형식
SELECT *
FROM (피벗 대상 쿼리문)
PIVOT (그룹함수(집계컬럼) FOR 피벗컬럼 IN (피벗컬럼 값 AS '별칭'));

SELECT *
FROM (SELECT *
       FROM SCORE_TABLE)
PIVOT (SUM(SCORE)
    FOR SUBJECTS IN ('국어', '영어', '수학', '과학', '지리', '독일어'));


## 컬럼을 로우로 변환하기

-- SCORE_COL_TABLE 생성
CREATE TABLE score_col_table (
	YEARS VARCHAR2(4), 
	GUBUN VARCHAR2(30), 
	KOREAN NUMBER, 
	ENGLISH NUMBER, 
	MATH NUMBER,
	SCIENCE NUMBER, 
	GEOLOGY NUMBER, 
	GERMAN NUMBER 
	);

-- 데이터 입력
INSERT INTO score_col_table
VALUES ('2020', '중간고사', 92, 87, 67, 80, 93, 82 );
INSERT INTO score_col_table
VALUES ('2020', '기말고사', 88, 80, 93, 91, 89, 83 );
COMMIT;


### UNION ALL 사용하는 경우

SELECT YEARS, GUBUN, '국어' SUBJECT, KOREAN AS SCORE
FROM SCORE_COL_TABLE
UNION ALL
SELECT YEARS, GUBUN, '영어' SUBJECT, ENGLISH AS SCORE
FROM SCORE_COL_TABLE
UNION ALL
SELECT YEARS, GUBUN, '수학' SUBJECT, MATH AS SCORE
FROM SCORE_COL_TABLE
UNION ALL
SELECT YEARS, GUBUN, '과학' SUBJECT, SCIENCE AS SCORE
FROM SCORE_COL_TABLE
UNION ALL
SELECT YEARS, GUBUN, '지리' SUBJECT, GEOLOGY AS SCORE
FROM SCORE_COL_TABLE
UNION ALL
SELECT YEARS, GUBUN, '독일어' SUBJECT, GERMAN AS SCORE
FROM SCORE_COL_TABLE
ORDER BY 1, 2 DESC;


### UNPIVOT절 사용하는 경우

- 구문 형식

SELECT *
FROM (피벗 대상 쿼리문)
UNPIVOT ( 열의 값을 표시할 컬럼명 FOR 행으로 표시될 때 새로운 컬럼의 별칭 IN (UNPIVOT 대상 컬럼명 AS '별칭')

SELECT *
FROM SCORE_COL_TABLE
UNPIVOT(SCORE FOR SUBJECT IN (KOREAN AS '국어', ENGLISH AS '영어', MATH AS '수학',
				SCIENCE AS '과학', GEOLOGY AS '지리', GERMAN AS '독일어'));

