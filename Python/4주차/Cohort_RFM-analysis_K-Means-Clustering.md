- Cohort
- RFM
- K-means Clustering

---

## Cohort

- 동질 집단 분석 (고객 세분화의 역할)
- 특정 기간동안 비슷한 특성 또는 경험을 가지는 사용자 집단을 '코호트 집단'이라고 한다
- 사용자의 특성: 연령, 성별, 지역, 방문페이지, 구매횟수, 구매상품 등이 해당
- 이러한 특성의 적절한 조합으로 사용자를 세분화한다
- 기본적으로 시간의 흐름에 따른 사용자의 유지, 이탈을 파악하는 역할
- 코호트 분석을 하는 이유?
    ⇒ 궁극적으로는 '비즈니스 인사이트'를 얻기 위해서
    ⇒ 단순히 표면적으로 드러나는 부분으로는 알 수 없는 디테일한 부분을 알 수 있다

참고문서: [https://01s2-min.tistory.com/63](https://01s2-min.tistory.com/63)

## RFM

- RFM 분석은 Recency(최근성), Frequency(행동빈도), Monetary(구매금액)의  3가지 관점에서 고객의 가치를 분석하는 방법이다
- Recency: 마지막 구매날로부터 얼마의 시간이 지났는가
 Frequency: 특정 기간에 몇 번 구매가 이루어졌는가
 Monetary: 특정 기간동안의 구매 금액
 ⇒ 이를 통해 고객에 대해 수치화가 가능

- RFM 분석 결과를 통해서 얻어진 등급을 가지고 고객을 분류할 수 있다 (Segment)
    ⇒ 마케터들이 고객 유형을 파악할 수 있게 되고 그에 맞는 전략을 짤 수 있다
    ⇒ 고객 지표: a×최근성 등급 ＋ b×행동빈도 등급 ＋ c×구매금액 등급

참고문서:  [https://zephyrus1111.tistory.com/12](https://zephyrus1111.tistory.com/12)

## K-Means Clustering

- 비지도 학습의 클러스터링 모델 중 하나
- 비슷한 특성을 가진(가까운 위치) 데이터끼리의 묶음을 '클러스터링'이라고 한다
- 클러스터의 구분이 없는 데이터들도 클러스팅을 해줌으로써 서로 같은 클러스터끼리 그루핑이 된다
- 클러스터의 중심을 Centroid라고 한다
- K-means Clustering에서 K는 클러스터의 개수를 뜻한다
  즉, K-means Clustering은 K개의 Centroid를 기반으로 K개의 클러스터를 만들어주는 것이다

- K-means Clustering의 목적은 유사한 데이터 포인트끼리 그루핑하여 패턴을 찾아내는 것이다
- 프로세스는 다음과 같다
    1. 클러스터의 개수 결정 (K 결정)
    2. 초기 Centroid 결정
    3. 각 데이터마다 가장 가까운 Centroid가 있는 클러스터로 assign
    4. Centroid를 클러스터의 중심으로 이동
    5. 클러스터에 assign 되는 데이터가 없을때까지 3, 4 과정을 계속 반복

출처: [https://bkshin.tistory.com/entry/머신러닝-7-K-평균-군집화-K-means-Clustering](https://bkshin.tistory.com/entry/%EB%A8%B8%EC%8B%A0%EB%9F%AC%EB%8B%9D-7-K-%ED%8F%89%EA%B7%A0-%EA%B5%B0%EC%A7%91%ED%99%94-K-means-Clustering)
