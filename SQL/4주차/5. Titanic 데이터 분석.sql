-- TITANIC 데이터를 좀 더 보기 쉽게 가공한 TITANIC2 테이블 생성
CREATE TABLE titanic2 AS
SELECT passengerid
	,CASE WHEN survived = 0 THEN '사망' ELSE '생존' end survived
	,TO_CHAR(pclass) || '등급' pclass ,name
	,DECODE(sex, 'male','남성', 'female','여성', '없음') gender
	,age, sibsp ,parch ,ticket ,fare ,cabin
	,CASE embarked WHEN 'C' THEN '프랑스-셰르부르'
	WHEN 'Q' THEN '아일랜드-퀸즈타운'
	WHEN 'S' THEN '영국-사우샘프턴'
	ELSE ''
	END embarked
FROM titanic
ORDER BY 1;

-- 성별 생존/사망자 수
SELECT GENDER, SURVIVED, COUNT(*) CNT
FROM TITANIC2
GROUP BY GENDER, SURVIVED
ORDER BY 1;

-- 성별 생존/사망자 수와 비율
SELECT A.GENDER, A.SURVIVED, A.CNT,
    ROUND(CNT/SUM(CNT) OVER(PARTITION BY GENDER ORDER BY GENDER),2) 비율
FROM (SELECT GENDER, SURVIVED, COUNT(*) CNT
    FROM TITANIC2
    GROUP BY GENDER, SURVIVED
    ORDER BY 1) A;


-- 등급별 생존/사망자 수
SELECT PCLASS, SURVIVED, COUNT(*) CNT
FROM TITANIC2
GROUP BY PCLASS, SURVIVED
ORDER BY 1;


-- 등급별 생존/사망자 수와 비율
SELECT A.PCLASS, A.SURVIVED,
    ROUND(A.CNT/SUM(A.CNT) OVER(PARTITION BY PCLASS ORDER BY PCLASS),2) 비율
FROM (SELECT PCLASS, SURVIVED, COUNT(*) CNT
    FROM TITANIC2
    GROUP BY PCLASS, SURVIVED
    ORDER BY 1) A;


-- 연령대별 생존/사망자 수
SELECT CASE WHEN AGE BETWEEN 1 AND 9 THEN '(1)10대 이하'
            WHEN AGE BETWEEN 10 AND 19 THEN '(2)10대'
            WHEN AGE BETWEEN 20 AND 29 THEN '(3)20대'
            WHEN AGE BETWEEN 30 AND 39 THEN '(4)30대'
            WHEN AGE BETWEEN 40 AND 49 THEN '(5)40대'
            WHEN AGE BETWEEN 50 AND 59 THEN '(6)50대'
            WHEN AGE BETWEEN 60 AND 69 THEN '(7)60대'
            ELSE '(8)70대 이상'
            END AS 연령대,
    SURVIVED, COUNT(*) CNT
FROM TITANIC2
GROUP BY CASE WHEN AGE BETWEEN 1 AND 9 THEN '(1)10대 이하'
            WHEN AGE BETWEEN 10 AND 19 THEN '(2)10대'
            WHEN AGE BETWEEN 20 AND 29 THEN '(3)20대'
            WHEN AGE BETWEEN 30 AND 39 THEN '(4)30대'
            WHEN AGE BETWEEN 40 AND 49 THEN '(5)40대'
            WHEN AGE BETWEEN 50 AND 59 THEN '(6)50대'
            WHEN AGE BETWEEN 60 AND 69 THEN '(7)60대'
            ELSE '(8)70대 이상'
            END, 
            SURVIVED
ORDER BY 1, 2;

-- 분석 결과 70대 이상의 사망자 수가 너무 많이 나옴
-- 나이 컬럼 살펴보기
SELECT AGE
FROM TITANIC2
ORDER BY 1 DESC; -- 나이 컬럼에 NULL 값 존재

SELECT AGE
FROM TITANIC2
ORDER BY 1; -- 0살부터 시작

-- 쿼리 보정(NULL값을 알수없음으로 처리, 나이 연령대를 0살부터 시작)
-- NULL값을 제거해버리면 값이 누락될 수 있으므로 '알수없음'으로 처리하였다
SELECT CASE WHEN AGE BETWEEN 0 AND 9 THEN '(1)10대 이하'
            WHEN AGE BETWEEN 10 AND 19 THEN '(2)10대'
            WHEN AGE BETWEEN 20 AND 29 THEN '(3)20대'
            WHEN AGE BETWEEN 30 AND 39 THEN '(4)30대'
            WHEN AGE BETWEEN 40 AND 49 THEN '(5)40대'
            WHEN AGE BETWEEN 50 AND 59 THEN '(6)50대'
            WHEN AGE BETWEEN 60 AND 69 THEN '(7)60대'
						WHEN AGE >= 70 THEN '(7)70대'
            ELSE '(9)알수없음'
            END AS 연령대,
    SURVIVED, COUNT(*) CNT
FROM TITANIC2
GROUP BY CASE WHEN AGE BETWEEN 0 AND 9 THEN '(1)10대 이하'
            WHEN AGE BETWEEN 10 AND 19 THEN '(2)10대'
            WHEN AGE BETWEEN 20 AND 29 THEN '(3)20대'
            WHEN AGE BETWEEN 30 AND 39 THEN '(4)30대'
            WHEN AGE BETWEEN 40 AND 49 THEN '(5)40대'
            WHEN AGE BETWEEN 50 AND 59 THEN '(6)50대'
            WHEN AGE BETWEEN 60 AND 69 THEN '(7)60대'
            WHEN AGE >= 70 THEN '(7)70대'
            ELSE '(9)알수없음'
            END, 
            SURVIVED
ORDER BY 1, 2;


-- 연령대, 성별 생존/사망자 수
SELECT CASE WHEN AGE BETWEEN 0 AND 9 THEN '(1)10대 이하'
            WHEN AGE BETWEEN 10 AND 19 THEN '(2)10대'
            WHEN AGE BETWEEN 20 AND 29 THEN '(3)20대'
            WHEN AGE BETWEEN 30 AND 39 THEN '(4)30대'
            WHEN AGE BETWEEN 40 AND 49 THEN '(5)40대'
            WHEN AGE BETWEEN 50 AND 59 THEN '(6)50대'
            WHEN AGE BETWEEN 60 AND 69 THEN '(7)60대'
						WHEN AGE >= 70 THEN '(7)70대'
            ELSE '(9)알수없음'
            END AS 연령대,
				    SURVIVED, GENDER, COUNT(*) CNT
FROM TITANIC2
GROUP BY CASE WHEN AGE BETWEEN 0 AND 9 THEN '(1)10대 이하'
            WHEN AGE BETWEEN 10 AND 19 THEN '(2)10대'
            WHEN AGE BETWEEN 20 AND 29 THEN '(3)20대'
            WHEN AGE BETWEEN 30 AND 39 THEN '(4)30대'
            WHEN AGE BETWEEN 40 AND 49 THEN '(5)40대'
            WHEN AGE BETWEEN 50 AND 59 THEN '(6)50대'
            WHEN AGE BETWEEN 60 AND 69 THEN '(7)60대'
            WHEN AGE >= 70 THEN '(7)70대'
            ELSE '(9)알수없음'
            END, 
            SURVIVED, GENDER
ORDER BY 1, 2, 3;


-- 형제, 배우자 수별 부모자식수별 생존/사망자 수
SELECT SIBSP, PARCH, SURVIVED, COUNT(*)
FROM TITANIC2
GROUP BY SIBSP, PARCH, SURVIVED
ORDER BY 1, 2, 3;
