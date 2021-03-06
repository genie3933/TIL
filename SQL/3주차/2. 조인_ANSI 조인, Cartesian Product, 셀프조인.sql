- ANSI 조인(ANSI Join)
    - ANSI 조인이란?
    - ANSI 조인 문법의 특징
    - ANSI 내부조인
    - ANSI 외부조인
    - 일반조인과 ANSI 조인 문법
- Cartesian Product
- 셀프 조인 (Self Join)

---

## ANSI 조인(ANSI Join)

### ANSI 조인이란?

- ANSI 표준 문법으로 작성한 조인 방법
- ANSI 표준 문법에서는 내부조인을 INNER JOIN, 외부조인을 LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN으로 표현하고 있다
- 중요한 점은 **FULL OUTER JOIN은 ANSI 문법으로만 구현이 가능하다는 것이다 **
- ANSI 문법은 오라클 뿐만 아니라 다른 DBMS에서도 사용이 가능하다

### ANSI 조인 문법의 특징

- 조인 조건절을 WHERE 절이 아닌 FROM 절에 기술한다
- 조인 조건은 ON 다음에 기술한다
- 조인 조건 외 다른 조건은 WHERE 절에 기술한다

### ANSI 내부조인

- 기존 문법과 ANSI 문법을 비교해보면 다음과 같은 차이가 있다

-- 기존 문법
SELECT a.employee_id emp_id,
	a.department_id a_dept_id,
	b.department_id b_dept_id,
	b.department_name dept_name
FROM employees a, departments b
WHERE a.department_id = b.department_id
ORDER BY a.department_id;

-- ANSI 문법 (조건을 FROM절에)
SELECT a.employee_id emp_id,
	a.department_id a_dept_id,
	b.department_id b_dept_id,
	b.department_name dept_name
FROM employees a 
	inner join departments b
	ON a.department_id = b.department_id
ORDER BY a.department_id;


### ANSI 외부조인

- 외부조인 역시 기존 문법과 차이가 있다
- 종류는 LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN으로 조인의 기준이 되는 테이블이 다르다

-- 기존 문법
SELECT a.employee_id emp_id,
	a.department_id a_dept_id,
	b.department_id b_dept_id,
	b.department_name dept_name
FROM employees a, departments b
WHERE a.department_id = b.department_id(+)
ORDER BY a.employee_id;

-- ANSI 외부조인 (LEFT OUTER JOIN) -> 기준이 되는 테이블을 왼쪽에.
SELECT a.employee_id emp_id,
	a.department_id a_dept_id,
	b.department_id b_dept_id,
	b.department_name dept_name
FROM employees a 
	LEFT OUTER JOIN departments b
	ON a.department_id = b.department_id
ORDER BY a.employee_id;

-- 기존 문법
SELECT a.employee_id emp_id,
	a.department_id a_dept_id,
	b.department_id b_dept_id,
	b.department_name dept_name
FROM employees a, departments b
WHERE a.department_id(+) = b.department_id
ORDER BY a.employee_id;

-- ANSI 외부조인(RIGHT OUTER JOIN) -> 기준이 되는 테이블이 오른쪽.
SELECT a.employee_id emp_id,
	a.department_id a_dept_id,
	b.department_id b_dept_id,
	b.department_name dept_name
FROM employees a
	RIGHT OUTER JOIN departments b
	ON a.department_id = b.department_id
ORDER BY a.employee_id;

-- FULL OUTER JOIN은 기존문법에는 없기 때문에 반드시 ANSI 문법으로 써야 한다
-- FULL OUTER JOIN은 말 그대로 조인 조건에 맞지 않아도 모든 데이터를 가져온다
SELECT a.employee_id emp_id,
	a.department_id a_dept_id,
	b.department_id b_dept_id,
	b.department_name dept_name
FROM employees a
	FULL OUTER JOIN departments b
	ON a.department_id = b.department_id
ORDER BY a.employee_id
	b. department_id;
	

### 일반조인과 ANSI 조인 문법

- 어떤 조인 문법을 써야 편리한지는 내부조인과 외부조인을 할 때 각각 다르다
- 내부조인의 경우 가독성 측면에서 WHERE절에 조건을 기술하는 일반 조인 문법을 쓰는 것이 좋다
- 외부조인의 경우에는 ANSI조인이 가독성이 더 좋기 때문에 ANSI 조인 문법을 써주는 것이 좋다

    (+) 는 오라클 고유의 문법이기 때문에 다른 DBMS에서 사용이 불가하다

- 또한 FULL OUTER JOIN은 ANSI 문법만 가능하다

## Cartesian Product

- 조인 조건이 없는 조인을 Cartesian Product라고 한다
- 조인조건이 없으므로 WHERE절에 조건을 기술하지 않고, 두 테이블 기준 모든 조합(경우의 수)의 로우가 조회된다
- ANSI 문법으로는 CROSS JOIN이라고 한다
- 하지만 Cartesian Product는 실제 사용될 일이 거의 없다
- 사용이 되었다면 조인 조건이 누락되지는 않았는지 생각해봐야 한다

## 셀프 조인(Self Join)

- 자기 자신과 조인하는 것을 말한다
- 동일한 테이블끼리 조인
- 셀프 조인의 사용 예는 다음과 같다


-- manager_id에 해당하는 사원명을 가져오기 위해 셀프 조인

SELECT a.employee_id
	,a.first_name || ' ' || a.last_name emp_name
	,a.manager_id
	,b.first_name || ' ' || b.last_name manager_name
FROM employees a
	,employees b
WHERE a.manager_id = b.employee_id
ORDER BY 1;

-- ANSI 조인 문법으로도 가능
SELECT a.employee_id
	,a.first_name || ' ' || a.last_name emp_name
	,a.manager_id
	,b.first_name || ' ' || b.last_name manager_name
FROM employees a
	INNER JOIN employees b
	ON a.manager_id = b.employee_id
ORDER BY 1;

