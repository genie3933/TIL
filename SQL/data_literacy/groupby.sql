-- 추가 연습문제 1번
-- 데이터 확인
SELECT * FROM `ls-data-literacy-319006.practice.item` LIMIT 100;

-- item_id와 product_name 별 총 주문수 및 총 매출액
select item_id, product_name, count(item_id) as tot_ord,
    sum(price) as tot_price
from `ls-data-literacy-319006.practice.item`
group by item_id, product_name;
