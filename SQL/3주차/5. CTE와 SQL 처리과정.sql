- WITH 절 (CTE)
- WITH 절 특징
- SQL 처리과정
    - SQL 내부 처리 프로세스
    - 최적의 실행계획
- TOP n Query
    - ROWNUM 사용
    - ROW_NUMBER( ) 사용
    - FETCH FIRST ROWS 구문 (12C부터)

---

## WITH 절 (CTE)

- 서브쿼리의 일종
- 하나의 서브쿼리를 또 다른 서브쿼리에서 참조하여 재사용 가능한 구문
- WITH 절의 구문은 다음과 같다

WITH alias1 AS (SELECT ...
		FROM ....),
	alias2 AS (SELECT ...
		FROM ....),
	alias_last AS (SELECT ...
		FROM ...)
SELECT ...
FROM alias_last
...;


- WITH는 한 번만 명시하고 서브쿼리를 여러개 사용 가능하다
- 최종 반환 결과는 마지막에 있는 메인쿼리이다
- 서브쿼리 내의 FROM 절에서 다른 서브쿼리 별칭을 기술해 인라인 뷰처럼 사용 가능하다
-- 예시 쿼리

WITH COUN_SAL AS(
	SELECT C.COUNTRY_ID, SUM(A.SALARY) SAL_AMT
	FROM EMPLOYEES A,
	    DEPARTMENTS B,
	    LOCATIONS C
	WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
	AND B.LOCATION_ID = C.LOCATION_ID
	GROUP BY C.COUNTRY_ID
	),
    MAINS AS(
	    SELECT B.COUNTRY_NAME, A.SAL_AMT
	    FROM COUN_SAL A,
		COUNTRIES B
	    WHERE A.COUNTRY_ID = B.COUNTRY_ID
	    )
SELECT *
FROM MAINS
ORDER BY 1;


- 메인쿼리에서는 FROM 절에서 서브쿼리 한 개, 혹은 여러 개의 서브쿼리를 조인해 결과를 조회할 수 있다
- 결국 메인쿼리에서 쓸 서브쿼리를 미리 WITH절에 기술해주는 것이라고 생각하면 쉽다
-- 예시 쿼리

WITH DEPT AS (
    SELECT DEPARTMENT_ID,
        DEPARTMENT_NAME DEPT_NAME
    FROM DEPARTMENTS
    )
SELECT A.EMPLOYEE_ID,
        A.FIRST_NAME||' '||A.LAST_NAME
FROM EMPLOYEES A, 
    DEPT B
WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
ORDER BY 1;


## WITH 절 특징

- 내부적으로 TEMP 테이블 스페이스를 사용한다 (TEMP 테이블 스페이스에 각 서브쿼리 결과를 담아두고 있다)
- TEMP 테이블 스페이스는 정렬 용도로 사용한다
- 과도한 사용시에는 TEMP 테이블 스페이스의 공간을 차지하기 때문에 성능에 좋지 않다
- 일반적인 경우에는 서브쿼리를 사용하고 서브쿼리 사용이 수월하지 않은 경우 WITH절을 사용하는 것이 좋다

## SQL 처리과정

### SQL 내부 처리 프로세스

1. SQL Syntax Check : SQL 문장 검사 (오타 등)
2. Semantic Check: 의미검사, 객체 권한 검사
3. Optimization: SQL 문장을 최적화 해 재작성, 가능한 여러개의 실행계획 수립
4. Row Source Generation: 최적의 실행계획 선정
5. Execution: 실행

### 최적의 실행계획

- 여러개의 실행계획을 세우고 그 중 가장 비용이 낮은 계획을 선택해 실행하는 것을 '최적의 실행계획'이라고 한다
- 최적의 실행계획을 위해서는 테이블의 통계정보를 최신으로 갱신시켜야 한다
- 여기서의 통계정보는 테이블의 로우 수, 블록 수 등 실행계획을 세우기 위한 기초정보를 말한다
- 조인 시, 어떤 테이블을 먼저 읽느냐에 따라 성능의 차이가 발생할 수 있기 때문에 통계정보가 중요한 것이다
- 실행계획을 잘 못 세웠을 경우 SQL 튜닝을 한다
- 실행했던 이력을 조회하는 쿼리: SELECT * FROM V$SQL;

## TOP n Query

- 특정 컬럼 값을 기준으로 상위 n개, 혹은 하위 n개 로우를 조회하는 쿼리
- 오라클 12c 부터 기본 문법으로 제공되기 시작했다

### ROWNUM 사용

-- 서브쿼리에서 SALARY 값을 기준으로 내림차순 정렬
-- ROWNUM을 사용해 5건 이하만 조회
SELECT *
FROM (SELECT A.EMPLOYEE_ID,
	A.FIRST_NAME||' '||A.LAST_NAME EMP_NAME,
	A.SALARY
	FROM EMPLOYEES A
	ORDER BY A.SALARY DESC) B
WHERE ROWNUM <=5


### ROW_NUMBER( ) 사용

-- 서브쿼리에서 분석함수 사용해 SALARY 값을 기준으로 내림차순 순번 계산
-- 계산한 순번을 사용해 5건 이하만 조회
SELECT *
FROM (SELECT A.EMPLOYEE_ID,
	A.FIRST_NAME||' '||A.LAST_NAME EMP_NAME,
	ROW_NUMBER() OVER(ORDER BY A.SALARY DESC) ROW_SEQ
	FROM EMPLOYEES A ) B
WHERE ROW_SEQ <=5;


### FETCH FIRST ROWS 구문(12C 부터 사용 가능)

-- SALARY 값 기준으로 내림차순 정렬
-- FETCH FIRST ROWS 구문 사용해 5개 로우만 조회
SELECT A.EMPLOYEE_ID,
	A.FIRST_NAME||' '||A.LAST_NAME EMP_NAME,
	A.SALARY
FROM EMPLOYEES A
ORDER BY A.SALARY DESC
FETCH FIRST 5 ROWS ONLY;

-- 5퍼센트에 해당하는 로우를 조회하려면?
SELECT A.EMPLOYEE_ID,
	A.FIRST_NAME||' '||A.LAST_NAME EMP_NAME,
	A.SALARY
FROM EMPLOYEES A
ORDER BY A.SALARY DESC
FETCH FIRST 5 PERCENT ROWS ONLY;

-- WITH TIES 옵션은 끝에 같은 값을 모두 조회하게 한다
SELECT A.EMPLOYEE_ID,
	A.FIRST_NAME||' '||A.LAST_NAME EMP_NAME,
	A.SALARY
FROM EMPLOYEES A
ORDER BY A.SALARY DESC
FETCH FIRST 5 PERCENT ROWS WITH TIES;
