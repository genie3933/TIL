- 분석함수
- 분석함수 종류
    - ROW_NUMBER( )
    - RANK( )
    - DENSE_RANK( )
    - LAG와 LEAD
    - 집계함수
    - RATIO_TO_REPORT( )
- MSSQL
    - MSSQL
    - 오라클과의 차이점

---

## 분석함수 (Analytic Function)

- 로우별 그룹을 지정해서 값을 집계함수를 분석함수라고 한다
- 분석함수는 GROUP BY 절과 다른 함수이다
- GROUP BY 절 사용 시, 집계 대상에 따라 로우 수가 줄어들지만 분석함수는 로우 수 그대로 집계 값 산출이 가능하다
- 분석함수에서 말하는 로우별 그룹을 '윈도우(window) 절'이라고 한다
- 일반 집계함수(SUM, MAX, MIN, AVG 등)를 분석함수로 사용 가능하다
- 그 외에도 ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD 함수가 있다
- 구문
**분석함수 OVER(PARTITION BY COL1, COL2, ...**
**ORDER BY COL1, COL2 ....)**
PARTITION BY: 분석 함수 집계 대상이 되는 로우 값의 범위로, 생략시 전체 로우가 분석함수 집계 대상이 된다.
ORDER BY: 분석 함수 계산 시, 고려되는 로우 순서

## 분석함수 종류

### ROW_NUMBER( ): 일련번호

- 구문은 다음과 같다

-- ROW_NUMBER( )
SELECT COL1, COL2, ...
	ROW_NUMBER OVER(PARTITION BY COL1, COL2, ...
			ORDER BY COL1, COL2, ...)
FROM ~
WHERE ~
ORDER BY ~;


- EX) 부서별 사원의 급여 순으로 **순번** 구하기
- PARTITION BY나 ORDER BY를 꼭 쓰지 않아도 분석함수를 사용할 수 있지만, PARTITION BY를 쓰지 않을 경우 전체 데이터에 분석함수가 적용된다


### RANK( ): 순위

- 구문은 다음과 같다

-- RANK( )
SELECT COL1, COL2, ...
	RANK OVER(PARTITION BY COL1, COL2, ...
		ORDER BY COL1, COL2, ...)
FROM ~
WHERE ~
ORDER BY ~;

- EX) 부서별 사원의 급여가 높은 순으로 **순위** 구하기
- RANK 함수는 동일값이 있을 때 동일한 순위로 표시한다


### DENSE_RANK( ): 누적순위

- 구문은 다음과 같다

-- DENSE_RANK( )
SELECT COL1, COL2, ...
	DENSE_RANK OVER(PARTITION BY COL1, COL2, ...
			ORDER BY COL1, COL2, ...)
FROM ~
WHERE ~
ORDER BY ~;

- RANK 함수와 비슷하지만 DENSE_RANK 함수는 동일 순위를 하나의 건수로 취급한다
    EX) 만약 1위가 2명일 경우 DENSE_RANK는 1, 1로 값 입력, 다음 순위는 2의 값을 가진다. 반면 RANK는 다음 순위가 3의 값을 가지게 된다

### LEAD(expr, offset, default): 후행 로우값

- 파티션 별 윈도우에서 이후 몇 번째 행의 값을 가져올 수 있는 함수
- LEAD(인수, 이후 몇 번째 행, NULL값을 대신할 값) OVER( )의 형태
- 인수는 3개까지 허용 가능하다

### LAG(expr, offset, default): 선행 로우값

- 파티션 별 윈도우 이전 몇 번째 행의 값을 가져올 수 있는 함수
- LAG(인수, 이전 몇 번째 행, NULL값을 대신할 값) OVER( )의 형태
- LEAD와 마찬가지로 인수는 3개까지 허용 가능하다

### 집계함수

- 앞의 함수들과 마찬가지로 분석함수 자리에 집계함수를 입력하면 파티션 별 값을 얻을 수 있다
- SUM, MAX, MIN, AVG등의 집계함수가 이에 해당한다
- 집계함수의 사용 예는 아래와 같다

-- 사원 급여와 부서별 누적 급여를 조회하는 쿼리
SELECT b.department_id, b.department_name,
	a.first_name || ' ' || a.last_name as emp_name,
	a.salary ,
	ROUND(SUM(a.salary) OVER (PARTITION BY b.department_id
				ORDER BY a.salary ),0) dept_cum_sum
FROM employees a,
	departments b
WHERE a.department_id = b.department_id
ORDER BY 2, 4;


### RATIO_TO_REPORT( ): 비율

- 분석함수 자리에 입력하면 파티션 별 인수의 비율을 구할 수 있다
- 사용 예시는 아래와 같다

-- 부서별 사원 급여의 비율을 조회하는 쿼리
SELECT b.department_id, b.department_name,
	a.first_name || ' ' || a.last_name as emp_name,
	a.salary ,
	ROUND(RATIO_TO_REPORT(a.salary) OVER (PARTITION BY b.department_id ),2) rates
FROM employees a,
	departments b
WHERE a.department_id = b.department_id
ORDER BY 2, 4 DESC;


## MSSQL

### MSSQL

- MSSQL 혹은 SQL Server라고 부른다
- SSMS(Sql Server Management Studio)툴을 사용하는데, 오라클의 SQL Developer와 비슷한 툴이다
- 기본적인 SQL은 오라클과 동일하다
- MSSQL에서는 외부조인을 할 때 ANSI 문법을 사용한다
- 빌트인 함수, 컬럼의 데이터 형이 오라클과 약간의 차이가 존재한다

    문자형: VARCHAR
    날짜형: DATETIME
    숫자형: INT, FLOAT, DOUBLE, DECIMAL

### 오라클과의 차이점

- 대소문자를 구분하지 않는다
- 문자열 결합에서 '||'가 아닌 '+'기호를 사용한다
- INSTR 함수: CHARINDEX를 쓸 뿐만 아니라 INSTR 함수와 매개변수 순서가 반대이다

    EX) SELECT CHARINDEX('A', 'AB')

- 문자열 길이: LEN, DATALENGTH 사용
- LEFT, RIGHT함수가 존재한다 (MSSQL에만 있다)
- 오라클의 NVL → MSSQL에서는 IsNull
- 오라클의 MOD → MSSQL에서는 % 연산자
- 차집합을 EXCEPT로 쓴다
- 오라클에서 empty string('')은 Null이지만 MSSQL에서는 Null이 아니라 ''값이다
- 그러므로 조건절에 등호를 사용해 비교가 가능하다 (where null_check = '')
