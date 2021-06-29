-- 현재 일자 기준 익월 1일(다음달 1일)을 반환하는 select 문
select round(sysdate, 'mm')
from dual;

select last_day(sysdate) + 1
from dual;

-- EMPLOYEES 테이블에서 사번이 110번 이하인 사원의 입사일자가 현재일자 기준으로 몇 개월이나 지났는지 구하는 문장
select round(months_between(sysdate, hire_date)) over_month
from employees
where employee_id <= 110;

-- MPLOYEES 테이블의 PHONE_NUMBER 컬럼에는 사원의 전화번호가 111.111.1111 형태로 저장되어 있는데,
-- 이를 111-111-1111로 바꿔 조회하는 문장을 작성
select replace(phone_number, '.', '-') phone_number2
from employees;

-- 2023년 8월 20일을 기준으로 그 달의 마지막 날짜의 요일을 구하는 쿼리를 작성
select to_char(last_day(to_date('2023-08-20', 'yyyy-mm-dd')),'day')
from dual;

-- 다음 문장에서 CASE 표현식 부분을 NVL 함수로 변환
SELECT employee_id, first_name, last_name, salary, commission_pct
,CASE WHEN commission_pct IS NULL THEN salary
ELSE salary + (salary * commission_pct)
END real_salary
FROM employees

-- nvl 함수
select employee_id, first_name, last_name, salary, commission_pct,
	salary + salary * nvl(commission_pct, 0) real_salary
from employees;

-- nvl2 함수
select employee_id, first_name, last_name, salary, commission_pct
,nvl2(commission_pct,salary+(salary*commission_pct), salary) real_salary
from employees;

-- 앞의 CASE 표현식을 이번에는 decode 함수를 사용해 동일한 결과를 반환
select employee_id, first_name, last_name, salary, commission_pct,
    decode(commission_pct, null, salary, salary+(salary * commission_pct)) real_salary
from employees;

-- 현재 일자 기준 1년 후의 날짜 조회
select add_months(sysdate,12) next_year
from dual;

-- 현재 일자 기준 3년 후의 날짜를 조회
select add_months(sysdate,36) next_year
from dual;

-- 2021년 6월 30일은 서기가 시작된 후 몇 일이나 지났는지 계산
SELECT TO_DATE('2021-06-30','YYYY-MM-DD') - TO_DATE('0001-01-01','YYYY-MM-DD')
FROM DUAL;


-- 서기가 시작된 1월 1일부터 오늘까지 1조원을 쓰려면 매일 얼마를 써야 할까 (최종 결과는 소수점 첫째 자리에서 반올림)
select round(1000000000000/(((to_char(to_date(sysdate), 'yyyy')-1)*365) 
        + (to_char(to_date(sysdate), 'ddd'))),0)
from dual;

-- 524288 이란 숫자가 있다. 이 수는 2의 몇 승일까?
select log(2, 524288)
from dual;

-- 2050년 2월의 마지막 날은 무슨 요일?
select to_char(last_day(to_date('20500201', 'yyyymmdd')), 'day')
from dual;

-- 현재일자(2021-06-14) 기준 ROUND(SYSDATE, 'YYYY') 를 실행하면 2021-01-01이 반환된다. 그럼 언제 시점부터 2022-01-01이 반환될까?
select round(to_date('2021-06-14', 'yyyy-mm-dd HH24:MI:SS'), 'yyyy') last_year,
    round(to_date('2021-07-01', 'yyyy-mm-dd HH24:MI:SS'), 'yyyy') next_year
from dual;
--→ sysdate가 7월이 되었을 때 다음년도를 반환한다

-- 각 국가별 지역사무소의 수 조회
select country_id, count(*)
from locations
group by country_id;

-- employees 테이블에서 년도에 상관 없이 분기별로 몇 명의 사원이 입사했는지 구하는 쿼리 작성
-- 1
select '1Q' quarter, count(*)
from employees
where to_char(hire_date, 'mm') between 01 and 03
union all
select '2Q' quarter, count(*)
from employees
where to_char(hire_date, 'mm') between 04 and 06
union all
select '3Q' quarter, count(*)
from employees
where to_char(hire_date, 'mm') between 07 and 09
union all
select '4Q' quarter, count(*)
from employees
where to_char(hire_date, 'mm') between 10 and 12;

-- 2
select to_char(hire_date, 'Q'), count(*)
from employees
group by to_char(hire_date, 'Q')
order by 1;


-- 다음 쿼리는 employees 테이블에서 job_id별로 평균 급여를 구한 것인데, 여기서 평균을 직접 계산하는 avg_salary1 이란 가상컬럼을 추가하기. ( 평균 = 총 금액 / 사원수)
SELECT job_id, ROUND(AVG(salary),0) avg_salary
FROM employees
GROUP BY job_id
ORDER BY 1;**

select job_id, round(sum(salary)/count(employee_id),0)
from employees
group by job_id
order by 1;

-- COVID19_TEST 테이블에서 한국(ISO_CODE 값이 KOR)의 월별 코로나 확진자 수를 조회
select to_char(dates, 'yyyy-mm'), sum(new_cases)
from covid19_test
where iso_code = 'KOR'
group by to_char(dates, 'yyyy-mm')
order by 1;

-- COVID19_TEST 테이블에서 한국 데이터에 대해 다음 결과가 나오도록 문장을 작성
select to_char(dates, 'yyyy-mm') MONTHS
,sum(new_cases) 확진자수
,sum(new_deaths) 사망자수
,decode(sum(new_cases),0,0, round(sum(new_deaths) / sum(new_cases) * 100,2)) 사망율
from covid19_test
where iso_code = 'KOR'
group by to_char(dates, 'yyyy-mm')
order by 1;

-- COVID19_TEST 테이블에서 2020년 10월에 가장 많은 확진자가 나온 상위 5개 국가
select country, nvl(sum(new_cases),0)
from covid19_test
where 1=1
and dates between to_date('20201001', 'yyyymmdd') and to_date('20201031', 'yyyymmdd')
and country <> 'World'
group by country
order by 2 desc;

-- 집합 연산자를 사용해 employees 테이블에서 2001과 2003년에 입사한 사원의 사원번호와 입사일자를 조회하는 쿼리
select employee_id, hire_date
from employees
where to_char(hire_date, 'yyyy') = '2001'
union
select employee_id, hire_date
from employees
where to_char(hire_date, 'yyyy') = '2003'
order by 2;

-- employees 테이블에서 job_id 별로 급여(salary)의 합계를 구하고, 마지막에 전체 급여 합계를 구하는 쿼리를 UNION 연산자를 사용해 작성
-- UNION 연산자 사용
select job_id, sum(salary)
from employees
group by job_id
union 
select null job_id, sum(salary)
from employees;

-- ROLLUP을 쓰면 위의 쿼리보다 간단한 쿼리로 같은 결과를 얻을 수 있다.
select job_id, sum(salary)
from employees
group by rollup(job_id);

-- COVID19_TEST 테이블에서 2020년 전반기(1월~6월)에는 월별 확진자가 10000명 이상이었는데, 
-- 후반기(7월~10월)에는 월별 확진자가 1000명 이하로 떨어진 적이 있는 국가를 구하는 문장을 작성(힌트: INTERSECT 연산자 사용)
-- 방법1
select country
from covid19_test
where to_char(dates, 'mm') between '01' and '06'
group by country, to_char(dates, 'mm')
having sum(new_cases) >= 10000
intersect
select country
from covid19_test
where to_char(dates, 'mm') between '07' and '10'
group by country, to_char(dates, 'mm')
having sum(new_cases) <= 1000;

-- 방법 2
SELECT country
FROM covid19_test
WHERE DATES BETWEEN TO_DATE('20200101','YYYYMMDD') AND TO_DATE('20200630','YYYYMMDD')
GROUP BY TO_CHAR(dates, 'YYYY-MM'), COUNTRY
HAVING NVL(SUM(new_cases),0) >= 10000
INTERSECT
SELECT COUNTRY
FROM covid19_test
WHERE DATES BETWEEN TO_DATE('20200701','YYYYMMDD') AND TO_DATE('20201031','YYYYMMDD')
GROUP BY TO_CHAR(dates, 'YYYY-MM') , COUNTRY
HAVING NVL(SUM(new_cases),0) <= 1000 ;
