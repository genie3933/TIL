-- with recursive 문
-- 메모리 상에 가상 테이블 저장
-- 재귀 쿼리 이용하여 실제로 테이블을 생성하거나 insert를 하지 않아도 가상 테이블 생성 가능
-- 거의 재귀 쿼리의 역할

WITH RECURSIVE 테이블명 AS (
	SELECT 초기값 AS 컬럼명1
	UNION ALL
	SELECT 컬럼명1 계산식 FROM 테이블명 WHERE 제어문
)


-- 예시: n(컬럼)이 초기값 1부터 5까지 데이터를 갖는 가상 테이블 생성
WITH RECURSIVE CTE(n) AS (
	SELECT 1 -- 초기값
	UNION ALL
	SELECT n+1 FROM CTE WHERE n<5 -- 추가반환 (재귀)
)

-- CTE(Common Table Expression): 해당 SQL문 내에서만 존재하는 일시적인 테이블
-- UNION 또는 UNION ALL로 구분된 두 부분이 존재
-- 두 번째 SELECT문이 더 이상 행을 생성하지 않을때 재귀는 끝남


-- 예시2 프로그래머스 group by 문제
WITH RECURSIVE T AS (
    SELECT 0 AS HOUR
    UNION ALL
    SELECT HOUR+1 FROM T WHERE HOUR<23
)

SELECT HOUR, COUNT(B.ANIMAL_ID) AS COUNT
FROM T AS A
LEFT JOIN ANIMAL_OUTS AS B
ON A.HOUR = HOUR(B.DATETIME)
GROUP BY HOUR
ORDER BY 1;

