- 트랜잭션 처리
- Merge 문
- 뷰
    - 뷰의 용도
    - 생성, 수정, 삭제
- 데이터 딕셔너리
    - 주요 사용자 객체 정보 뷰

---

## 트랜잭션 처리

- COMMIT, ROLLBACK으로 트랜잭션이 처리된다
- COMMIT : 변경된 데이터 최종 저장

    ROLLBACK: 변경 이전 상태로 회귀

- INSERT, UPDATE, DELETE, MERGE문 실행 후 오류가 없다면 반드시 COMMIT을 지정해야 데이터가 최종으로 저장된다
- COMMIT, ROLLBACK은 마지막 COMMIT, ROLLBACK 문을 실행한 이후 내역에 적용된다

    
    INSERT INTO 테이블1
    ...;
    COMMIT; -- 테이블1에 대한 INSERT 반영

    UPDATE 테이블1
    SET 컬럼1 = 값1
    WHERE ...;
    ROLLBACK; -- 테이블1에 대한 UPDATE 작업 취소, 하지만 INSERT 작업은 커밋 완료했으므로 이미 반영
    

## MERGE 문

- INSERT, UPDATE 한 번에 처리
- 일반적으로 테이블의 주요 키 값을 체크하고 해당 값이 존재하면 UPDATE, 존재하지 않으면 INSERT를 수행한다
- 구문

    MERGE INTO 대상테이블명
    USING 참조테이블 혹은 서브쿼리
    ON 조인 조건
    WHEN MATCHED THEN
    	UPDATE SET 컬럼1=값1, 컬럼2=값2, ...
    WHEN NOT MATCHED THEN
    	INSERT(컬럼1, 컬럼2, ...)
    	VALUES(값1, 값2, ...);

- 실습

    -- 테이블 복제
    CREATE TABLE DEPT_MGR AS
    SELECT *
    FROM DEPARTMENTS;

    -- 제약조건 설정
    ALTER TABLE DEPT_MGR
    ADD CONSTRAINTS DEPT_MGR_PK PRIMARY KEY(DEPARTMENT_ID);

    -- MERGE 문으로 2개의 ROW 병합
    MERGE INTO DEPT_MGR A
    USING (SELECT 280 DEPT_ID, '영업부(MERGE)' DEPT_NAME
            FROM DUAL
            UNION ALL
            SELECT 285 DEPT_ID, '경리부(MERGE)' DEPT_NAME
            FROM DUAL
            ) B
    ON (A.DEPARTMENT_ID = B.DEPT_ID)
    WHEN MATCHED THEN
    UPDATE SET A.DEPARTMENT_NAME = B.DEPT_NAME
    WHEN NOT MATCHED THEN
    INSERT (A.DEPARTMENT_ID, A.DEPARTMENT_NAME)
    VALUES (B.DEPT_ID, B.DEPT_NAME);

    -- 데이터 확인
    SELECT *
    FROM DEPT_MGR;
 
## 뷰

- 하나 이상의 다른 테이블이나 뷰로 구성된 논리적 객체
- 테이블처럼 동작하는 것이 특징이다
- 뷰 자체에는 데이터가 저장되어있지 않다

### 뷰의 용도

- 테이블 데이터의 보안 강화: 컬럼, 로우에 대한 접근 제한

    ex) 사원들의 개인정보보호를 위해 민감한 정보는 빼고 나머지 정보가 담긴 테이블을 뷰로 만들어 뷰의 조회 권한을 부여하는 경우

- 데이터 복잡성 숨김: 복잡하게 얽힌 쿼리를 뷰로 만들어 사용
- 테이블 구조 변경에 따른 영향 감소: 뷰를 만들어 놓을 경우 신규 컬럼을 추가해도 영향을 받지 않는다
- 모든 객체를 참조하기 위해서는 소유자명.객체명 형태로 사용해야 한다 (부여된 권한이 다르기 때문)

    ex) hr.employees, hr.departments ...

### 생성, 수정, 삭제

-- 생성
CREATE OR REPLACE VIEW 뷰이름 AS
SELECT 문;

-- 수정(생성할 때와 마찬가지 문법)
-- 생성된 뷰에 덮어쓴다고 생각하면 된다
CREATE OR REPLACE VIEW 뷰이름 AS
SELECT 문;

-- 삭제
DROP VIEW 뷰이름;

-- 뷰 생성
CREATE OR REPLACE VIEW EMP_DEPT_V AS
SELECT A.EMPLOYEE_ID,
		A.FIRST_NAME||' '||A.LAST_NAME EMP_NAMES,
		B.DEPARTMENT_ID, B.DEPARTMENT_NAME
FROM EMPLOYEES A
		DEPARTMENTS B
WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
ORDER BY 1;

-- 조회
SELECT *
FROM EMP_DEPT_V;


## 데이터 딕셔너리

- 오라클에서 제공하는 데이터베이스 객체에 대한 메타정보를 담은 뷰
- 접두어로 용도를 구분한다

    DBA: 데이터베이스 관리자의 뷰

    ALL: 현재 로그인한 사용자가 접근할 수 있는 뷰

    USER: 현재 로그인한 사용자가 소유자인 데이터베이스 객체

- 데이터 딕셔너리를 통해 DB객체의 다양한 정보를 조회할 수 있다

### 주요 사용자 객체 정보 뷰

- USER_OBJECTS: 모든 객체 정보
- USER_TABLE: 테이블 정보
- USER_INDEX: 인덱스 정보
- USER_CONSTRAINTS: 제약조건 정보
- USER_TAB_COLS: 테이블과 해당 컬럼의 정보
- USER_VIEWS: 뷰 정보

⇒ 모두 SELECT 문으로 조회 가능
