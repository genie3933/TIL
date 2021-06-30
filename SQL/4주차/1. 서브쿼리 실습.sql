-- 사원의 급여를 회사 전체 평균 급여와 해당 사원이 속한 부서 평균 급여와 비교 
select a.employee_id,
        a.first_name||' '||a.last_name emp_name,
        a.department_id,
        b.dept_avg_sal,
        c.tot_avg_sal
from employees a,
    (select department_id, 
            round(avg(salary),0) dept_avg_sal -- 부서별 평균 급여
    from employees 
    group by department_id) b,
    (select round(avg(salary),0) tot_avg_sal -- 회사 전체 평균 급여
    from employees) c
where a.department_id = b.department_id
order by 1;


-- 가장 급여가 많은 사원과 가장 적은 사원 이름, 급여 구하기
select a.employee_id,
        a.first_name||' '||a.last_name emp_name,
        a.salary
from employees a
where a.salary in (select min(salary) min_sal
                    from employees)
or    a.salary in (select max(salary) max_sal
                    from employees);

-- inner join으로도 같은 결과를 얻을 수 있다
select a.employee_id,
        a.first_name||' '||a.last_name emp_name,
        a.salary
from employees a
inner join (select min(salary) min_sal, max(salary) max_sal
          from employees) b
on a.salary = b.min_sal
or a.salary = b.max_sal;


-- 사원에 할당되지 않은 부서 정보 조회
select *
from departments
where department_id not in
                (select a.department_id
                from employees a); -- null 값이 있어서 데이터 출력 불가능
select *
from departments a
where not exists(select 1
                from employees b
                where a.department_id = b.department_id)
order by 1;


-- 입사년도별 사원들의 급여 총액과 전년 대비 증가율
-- 입사년도 별 사원들의 급여 총액
select to_char(hire_date, 'yyyy') years,
        sum(salary)
from employees
group by to_char(hire_date, 'yyyy'); 

-- 금년, 전년도 급여 총액
select ty.years, ty.sal, ly.years, ly.sal
from (select to_char(hire_date, 'yyyy') years,
        sum(salary) sal
        from employees
        group by to_char(hire_date, 'yyyy')
        ) ty
left join
    (select to_char(hire_date, 'yyyy') years,
        sum(salary) sal
        from employees
        group by to_char(hire_date, 'yyyy')
        ) ly
on ty.years - 1 = ly.years
order by 1;

-- 전년 대비 증가율
select ty.years, ty.sal, nvl(ly.sal,0) pre_sal,
        case when nvl(ly.sal,0) = 0 then 0
            else round((ty.sal-ly.sal)/ly.sal * 100,2)
            end rates
from (select to_char(hire_date, 'yyyy') years,
        sum(salary) sal
        from employees
        group by to_char(hire_date, 'yyyy')
        ) ty
left join
    (select to_char(hire_date, 'yyyy') years,
        sum(salary) sal
        from employees
        group by to_char(hire_date, 'yyyy')
        ) ly
on ty.years - 1 = ly.years
order by 1;
