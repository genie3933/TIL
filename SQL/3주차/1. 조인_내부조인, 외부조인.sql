- 조인(Join)
- 내부 조인(Inner Join)
- 외부 조인(Outer Join)
    - 외부조인을 사용하는 이유?

---

## 조인(Join)

- 테이블 간 연결 작업을 조인이라고 한다
- 조인에 참여하는 테이블에는 같은 값을 가진 칼럼들이 존재하는데, 이것을 조인 컬럼이라고 한다
- 조인 컬럼명이 동일할 필요는 없지만 동일하게 만드는 것이 좋다
- 조인 컬럼은 한 개 이상으로 구성될 수 있으며 뷰(view)도 조인이 가능하다
- 조인은 방식에 따라 내부조인과 외부조인으로 나뉜다

## 내부 조인(Inner Join)

- 가장 기본적인 조인 방식으로, 조인 조건을 만족한 데이터만 조회되는 것을 내부조인이라고 한다
- 조인 조건은 where절에서 각 테이블의 조인 컬럼과 연산자를 사용해 조건을 명시하는데, 내부조인은 조인 조건에 동등 연산자 (=)를 사용한다
- 동등 연산자를 사용해서 조인 컬럼 값이 같은 건이 조회되는 것이다 (컬럼 값이 같지 않으면 조회되지 않는다)
- 내부 조인의 사용 예는 다음과 같다

select a.employee_id,
	a.first_name,
	a.department_id,
	b.department_name
from employees a,
	departments b
where a.department_id = b.department_id
order by a.department_id;


- 각 테이블에 alias를 주는 것이 좋고, 모든 컬럼은 테이블명.컬럼명 형태를 지켜주는 것이 좋다
- where 절에서는 조인 조건과 일반 조건을 함께 사용할 수 있다

select a.employee_id,
	a.first_name || ' ' || a.last_name emp_names,
	b.job_title,
	c.department_id,
	c.department_name
from employees a,
	jobs b,
	departments c
where a.job_id = b.job_id
and a.department_id = c.department_id
and c.department_id = 30
order by 1;


- 조인조건이 여러개이면 and 연산자를 사용해 나열하면 된다

select a.employee_id, a.first_name || ' ' || a.last_name emp_names,
	b.job_title,
	c.department_id ,
	c.department_name
from employees a,
	jobs b,
	departments c
where a.job_id = b.job_id
and a.department_id = c.department_id
order by 1;


## 외부 조인(Outer Join)

- 조인 조건을 만족하는 것은 물론 만족하지 않는 데이터까지 포함해서 조회하는 것을 외부조인이라고 한다
- A, B 두 테이블 기준, 조인 조건에 부합하지 않는 상대방 테이블의 데이터도 조회된다
- 조인조건에 (+)를 붙여야 한다 (오라클 전용 문법)
- 조인 조건을 만족하지 않는 a 테이블의 데이터까지 조회할 때
: where a.department_id = b.department_id (+)

- 조인 조건을 만족하지 않는 b 테이블의 데이터까지 조회할 때
 : where a.department_id (+) = b.department_id

- 외부 조인의 사용 예는 다음과 같다

SELECT a.employee_id emp_id,
	a.department_id a_dept_id,
	b.department_id b_dept_id,
	b.department_name dept_name
FROM employees a, departments b
WHERE a.department_id = b.department_id (+)
ORDER BY a.department_id;

-- 이렇게 하면 결과는 부서번호가 null인 데이터도 있는 a테이블의 데이터까지 조회가 된다.


- 오라클 외부 조인의 제약사항

    : 조인 컬럼이 여러 개일 경우, 조인 조건에서 (+) 기호를 모두 붙여야 제대로 조회된다
    : 조인 조건 양쪽에 (+) 기호를 붙일 수 없다

### 외부 조인을 사용하는 이유?

- 현실에서 테이블 설계를 완벽히 할 수는 없다
- 설계를 제대로 하더라도 업무가 변경되면 수정은 필수 불가결하다
- 데이터 입력시 오류로 인해 잘못된 데이터를 입력하거나 누락 데이터가 발생할 수 있기 때문이다
