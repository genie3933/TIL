- 서브쿼리
    - 서브쿼리란?
    - 스칼라 서브쿼리
    - 인라인 뷰
    - 중첩 서브쿼리
- 세미 조인
- 안티 조인

---

## 서브쿼리

### 서브쿼리란?

- 메인쿼리 안에 있는 또 다른 보조 쿼리
- 서브쿼리는 하나의 SELECT 문장으로 괄호로 둘러쌓인 형태이다
- 메인쿼리 기준 여러개의 서브쿼리를 사용할 수 있다
- 종류는 아래와 같다

서브쿼리의 위치에 따라
- 스칼라 서브쿼리: SELECT 절
- 인라인 뷰: FROM 절
- 중첩 서브쿼리: WHERE 절

메인쿼리와의 연관성에 따라
- 연관성 있는 서브쿼리: 메인쿼리와 조인
- 연관성 없는 서브쿼리: 메인쿼리와 독립

### 스칼라 서브쿼리 (Scalar Subquery)

- 메인쿼리의 SELECT절에 위치한다
- SELECT 절에서 하나의 컬럼이나 표현식처럼 사용된다
- **최종 반환하는 로우 수, 컬럼, 표현식 등은 모두 1개**이다
- 하나의 컬럼 역할을 하기 때문에 ALIAS를 주는 것이 일반적이다
- 메인쿼리와 조인할 수 있다 (**사실 조인하지 않으면 여러건이 조회되기 때문에 조인을 하는 것이 일반적이다. 스칼라 서브쿼리 같은 경우 1건을 반환해야 하기 때문에 조인을 해야한다.**)
- 스칼라 서브쿼리를 쓰면 값을 모두 가져오기 때문에 값이 누락되는 일은 없다 (조인에서는 누락되는 경우가 종종 있다)
- 성능상 좋지 않기 때문에 과도한 사용은 자제해야한다

### 인라인 뷰 (Inline View)

- 메인쿼리의 FROM 절에 위치한다
- 서브쿼리 자체가 마치 하나의 테이블처럼 동작한다
- 최종 반환하는 로우, 컬럼, 표현식 수는 1개 이상 가능하다
- ALIAS를 반드시 명시해주어야 한다
- 기존 단일 테이블만 읽어서는 필요한 정보를 가져오기 어려울 때 인라인 뷰를 사용한다
- 일반적으로 인라인 뷰와 메인쿼리의 조인을 수행하려면 메인쿼리의 WHERE절에서 수행이 가능하다
- 그러나 오라클 12C부터 추가된 기능으로, 서브쿼리 앞에 LATERAL 키워드를 사용할 경우 서브쿼리 내에서도 조인이 가능하다 (스칼라 서브쿼리처럼 동작이 가능)

-- 비교
-- 일반적인 인라인 뷰 서브쿼리와 메인쿼리 조인
SELECT a.employee_id,
	a.first_name || a.last_name emp_name,
	a.department_id,
	c.dept_name
FROM employees a,
		( SELECT b.department_id, b.department_name dept_name
		FROM departments b ) c
WHERE a.department_id = c.department_id
ORDER BY 1;

-- LATERAL 키워드 사용했을 시
SELECT a.employee_id,
	a.first_name || a.last_name emp_name,
	a.department_id,
	c.dept_name
FROM employees a,
		LATERAL
		( SELECT b.department_name dept_name
			FROM departments b
			WHERE a.department_id = b.department_id ) c
ORDER BY 1;


- 인라인 뷰의 사용 이유?
- 분석함수가 나오기 전 그룹별 집계를 할 때 유용하게 쓰였다

### 중첩 서브쿼리 (Nested Subquery)

- 메인쿼리의 WHERE 절에 위치
- 서브쿼리가 조건절의 일부로 사용된다
- 최종 반환 값과 테이블의 특정 컬럼값을 비교한다
- 최종 반환 로우, 컬럼, 표현식의 수는 1개 이상이 가능하다
- 조건절의 일부이므로 서브쿼리에 대한 ALIAS 사용이 불가능하다
- 서브쿼리 내에서 메인쿼리와 조인이 가능하다
- IN, EXISTS 뒤에 많이 쓰인다


-- employees 테이블의 department_id와 같은 departments의 데이터만 조회
SELECT *
FROM departments
WHERE department_id IN ( SELECT department_id
			FROM employees
			);

-- 존재하는지를 체크하는 exists
-- 서브쿼리 내에서 employees, departements 조인
SELECT *
FROM departments a
WHERE EXISTS ( SELECT 1
		FROM employees b
		WHERE a.department_id = b.department_id);

- EXISTS는 조인조건이 있지만 IN은 조인조건이 없다
- EXISTS를 썼을 때는 SELECT절에 값을 확인할 용도로 아무 숫자 혹은 문자를 써 놓아야 한다

### 세미 조인 (Semi Join)

- 중첩 서브쿼리와의 조인을 의미한다
- 두 번째 테이블에 있는 로우와 조건이 맞는 첫 번째 테이블의 로우를 반환한다
- WHERE 절에서 EXISTS 연산자를 사용한다

### 안티 조인 (Anti Join)

- 세미 조인에서 NOT 연산자를 사용하는 조인
- 서브쿼리와의 조인조건에 부합하지 않는 건을 조회한다
- NOT IN, NOT EXISTS
