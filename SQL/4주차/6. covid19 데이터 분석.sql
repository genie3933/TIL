-- 데이터 정제
-- countrycode가 'OWID'로 시작하는 데이터 삭제
select countrycode, count(*)
from covid19_data
where countrycode LIKE 'OWID%'
group by countrycode;

delete covid19_data
where countrycode like 'OWID%';

select count(*)
from covid19_data
where countrycode like 'OWID%';

commit;

-- null을 가진 cases의 값을 0으로 수정
update covid19_data
set cases = 0
where cases is null;

update covid19_data
set new_cases_per_million = 0
where new_cases_per_million is null;

update covid19_data
set deaths = 0
where deaths is null;

update covid19_data
set icu_patients = 0
where icu_patients is null;

update covid19_data
set hosp_patients = 0
where hosp_patients is null;

update covid19_data
set tests = 0
where tests is null;

update covid19_data
set reproduction_rate = 0
where reproduction_rate is null;

update covid19_data
set new_vaccinations = 0
where new_vaccinations is null;

update covid19_data
set stringency_index = 0
where stringency_index is null;

commit;


-- 2020년 월별, 대륙별, 국가별 감염수

select to_char(b.issue_date, 'yyyy-mm') months, 
    a.continent, a.countryname, sum(b.cases) case_num
from covid19_country a,
covid19_data b
where a.countrycode = b.countrycode
and to_char(b.issue_date, 'yyyy') = '2020'
group by to_char(b.issue_date, 'yyyy-mm'), a.continent, a.countryname
order by 1, 2, 3;


-- 2020년 월별, 대륙별, 국가별 감염수, 대륙 기준 감염수 비율
with covid1 as (
		select to_char(b.issue_date, 'yyyy-mm') months, 
		       a.continent, a.countryname, sum(b.cases) case_num
		from covid19_country a,
		 covid19_data b
		where a.countrycode = b.countrycode
		and to_char(b.issue_date, 'yyyy') = '2020'
		group by to_char(b.issue_date, 'yyyy-mm'), a.continent, a.countryname
)
select months, continent, countryname, 
    case_num,
    round(ratio_to_report(case_num) over (partition by months, continent)*100,2) rates
from covid1
order by 1, 2, 3;


-- 2020년 한국의 월별 검사 수, 확진자 수, 확진율
select to_char(issue_date, 'yyyy-mm') months,
    sum(tests) 검사수,
    sum(cases) 확진자수,
    case when sum(tests) = 0 then 0 
        else round(sum(cases)/sum(tests) * 100,2) 
        end 확진율
from covid19_data 
where to_char(issue_date, 'yyyy') = '2020'
and countrycode = 'KOR'
group by to_char(issue_date, 'yyyy-mm')
order by 1;


-- 2020년 가장 많은 확진자가 나온 상위 5개 국가
SELECT *
FROM (SELECT A.COUNTRYNAME, SUM(CASES) CASES_NUM
    FROM COVID19_COUNTRY A,
    COVID19_DATA B
    WHERE A.COUNTRYCODE = B.COUNTRYCODE
    AND TO_CHAR(B.ISSUE_DATE, 'YYYY') = '2020'
    GROUP BY A.COUNTRYNAME
    ORDER BY 2 DESC)
WHERE ROWNUM <= 5
ORDER BY 2 DESC;


-- 2020년 인구 대비 사망률이 높은 20개 국가
select *
from (select a.countryname, max(a.population) popu,
            sum(b.deaths) death_num,
            decode(max(a.population), 0, 0,
            round(sum(b.deaths)/max(a.population) * 100, 4)) death_ratio
      from covid19_country a,
        covid19_data b
      where a.countrycode = b.countrycode
      and to_char(b.issue_date, 'yyyy') = '2020'
      group by a.countryname
      order by death_ratio desc)
where rownum <= 20;
