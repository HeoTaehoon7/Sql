SELECT SYSDATE  FROM DUAL;

SELECT  EMPLOYEE_ID, HIRE_DATE
 FROM   EMPLOYEES
 WHERE  HIRE_DATE = '15/09/21';
 
ALTER SESSION SET NLS_DATE_FORMAT = "YYYY-MM-DD HH24:MI:SS"; 

SELECT  EMPLOYEE_ID, HIRE_DATE
 FROM   EMPLOYEES
 WHERE  HIRE_DATE = '2015-09-21';
 
 --------------------------------------------------------
 -- 앞으로 날짜 표현은 다음과 같이 표현하지
 
 SELECT  EMPLOYEE_ID, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')
 FROM    EMPLOYEES
 --WHERE   TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') = '2015-09-21';
 WHERE   TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') = '2026-04-07';

-- 입사후 일주일이내인 직원명단 
SELECT      EMPLOYEE_ID,  TO_DATE(HIRE_DATE, 'YYYY-MM-DD')
 FROM       EMPLOYEES
 WHERE      HIRE_DATE >= SYSDATE - 7;


--  08월 입사자의  사번, 이름, 입사일를 입사일 순으로
SELECT     EMPLOYEE_iD                        "사 번", 
           FIRST_NAME || ' '|| LAST_NAME      이름, 
           TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')   입사일
 FROM      EMPLOYEES
 WHERE     TO_CHAR( HIRE_DATE, 'MM') = '08';

 
 --   부서번호 80 이 아닌 직원
 SELECT     EMPLOYEE_ID, DEPARTMENT_ID
  FROM      EMPLOYEES
  WHERE     DEPARTMENT_ID  <>  80  --   !=   같지않다
   ; 
 
  --  =, <>, >, >=, <, <= , BETWEEN ~AND
  --  +, -, *, /, MOD(7, 2)
  

  
 -- 2026년 04 월 07일  10 시 05 분 04 초 오전 수요일
 -- 한자로 출력
  
 
  
  -- 오전/오후  오전(午前)과 오후(午後)
  -- 년월일시분초   年月日時分秒
  -- 일월화수목금토  日, 月, 火, 水, 木, 金, 土
  -- 요일 曜日
  
 SELECT   TO_CHAR(SYSDATE, 'YYYY') || '年 ' 
      ||  TO_CHAR(SYSDATE, 'MM')   || '月 '
      ||  TO_CHAR(SYSDATE, 'DD')   || '日 ' 
      ||  TO_CHAR(SYSDATE, 'HH12') || '時 ' 
      ||  TO_CHAR(SYSDATE, 'MI')   || '分 ' 
      ||  TO_CHAR(SYSDATE, 'SS')   || '秒 ' 
      ||  CASE TO_CHAR(SYSDATE, 'DY')  
            WHEN  '일'   THEN  '日'
            WHEN  '월'   THEN  '月'   
            WHEN  '화'   THEN  '火'
            WHEN  '수'   THEN  '水'
            WHEN  '목'   THEN  '木'
            WHEN  '금'   THEN  '金'
            WHEN  '토'   THEN  '土'
          END                      || '曜日 ' 
      ||  DECODE( TO_CHAR(SYSDATE, 'AM') ,'오전', '午前', '午後')
  FROM    DUAL;
  
 
 -- 1)  TO_CHAR 활용
 SELECT SYSDATE,
        TO_CHAR( SYSDATE, 'YYYY-MM-DD HH24:MI:SS DAY AM')  날짜1 ,
    --    TO_CHAR( SYSDATE, 'YYYY년MM월DD일 HH24시MI분SS초 DAY AM')  날짜2,  -- ORA-01821: 날짜 형식이 부적합합니다
        TO_CHAR( SYSDATE, 'YYYY"년"MM"월"DD"일" HH24"시"MI"분"SS"초" DAY AM')  날짜2, 
        TO_CHAR( SYSDATE, 'YYYY"年"MM"月"DD"日" HH24"時"MI"分"SS"秒" DAY AM')  날짜3, 
        TO_CHAR( SYSDATE, 'AM')
  FROM  DUAL;
 
 -- 2)  IF를 구현  
 -- 2-1) NVL(), NVL2() : NULL VALUE 
 ---- 사번,이름, 월급, COMMISION_PCT( 단 NULL 이면 0으로 출력)
 SELECT     EMPLOYEE_ID                                                       사번,
            FIRST_NAME || ' ' || LAST_NAME                                    이름, 
            SALARY                                                            월급, 
            NVL( COMMISSION_PCT, 0)                                           COMMISSION_PCT,
            NVL2( COMMISSION_PCT, SALARY+(SALARY*COMMISSION_PCT), SALARY  )   보너스
  FROM      EMPLOYEES
  ;
  
 -- 2-2) NULLIF expr1, expr2 ) 
-- 들을 비교해서 같으면 null, 같지않으면  expr1

 
 -- 2-3)DECODE (expr, search1, result1, 
 --                   search2, result2, 
 --                   …,
 --                   default)
---- DECODE는 expr과 search1을 비교해 두 값이 같으면 result1을, 
--       같지 않으면 다시 search2와 비교해 값이 같으면 result2를 반환하고, 
--       이런 식으로 계속 비교한 뒤 최종적으로 같은 값이 없으면 default 값을 반환한다.
 
 -- 사번, 부서번호 (단 부서번호가 NULL 이면 '부서없음')
 SELECT   EMPLOYEE_ID                       사번, 
         -- NVL(DEPARTMENT_ID, '부서없음')    부서번호  -- ORA-01722: 수치가 부적합합니다 두 TYPE 같아야함
          DECODE(DEPARTMENT_ID, NULL, '부서없음',
                                      DEPARTMENT_ID ) 부서번호 
  FROM    EMPLOYEES
 ;
 

 SELECT   TO_CHAR( SYSDATE, 'AM' ),
          DECODE( TO_CHAR( SYSDATE, 'AM' ), '오전',  '午前',
                                                     '午後' )  
  FROM    DUAL;
  
  
  
  --------------------------------------------------------------------
  /*
10	Administration
20	Marketing
30	Purchasing
40	Human Resources
50	Shipping
60	IT
70	Public Relations
80	Sales
90	Executive
100	Finance
110	Accounting
*/
  -- DECODE 로  
  -- 사번, 이름, 부서명
   SELECT    DEPARTMENT_ID                     사번, 
             FIRST_NAME || ' ' || LAST_NAME    이름, 
             DECODE(DEPARTMENT_ID,  60, 'IT',
                                    90, 'Executive', 
                                    80,	'Sales'
                                      , '그외'
             )                                 부서명
   FROM      EMPLOYEES;

 -- 사번, 이름, 부서명 : 모든 부서명, NULL : 부서없음
  SELECT     EMPLOYEE_ID                     사번, 
             FIRST_NAME || ' ' || LAST_NAME    이름, 
             DECODE(DEPARTMENT_ID,  10,	 'Administration',
                                    20,	 'Marketing',
                                    30,	 'Purchasing',
                                    40,	 'Human Resources',
                                    50,	 'Shipping',
                                    60,	 'IT',
                                    70,	 'Public Relations',
                                    80,	 'Sales',
                                    90,	 'Executive',
                                    100, 'Finance',
                                    110, 'Accounting',
                                         '부서없음'
             )                                 부서명
   FROM      EMPLOYEES;
 
 --  NULL 이 계산에 포함되면 결과는 NULL 
  -- 직원명단, 직원의 월급, 보너스 출력 연봉출력
   SELECT    EMPLOYEE_ID                                                    사번, 
             FIRST_NAME || ' ' || LAST_NAME                                 이름, 
             SALARY                                                         "직원의 월급", 
             NVL(SALARY*COMMISSION_PCT, 0)                                  "보너스",
             SALARY * 13 + SALARY*COMMISSION_PCT                            "연봉출력",
             SALARY * 13 + NVL(SALARY*COMMISSION_PCT, 0)                    "연봉출력"
    FROM     EMPLOYEES;
    
 
 -------------------------------------------------------------------
 -- 3)  CASE WHEN THEN END
 -- WHEN   SCORE  BETWEEN  90 AND 100     THEN 'A'
 -- WHEN   90 < = SCORE  AND SCORE <= 100 THEN 'A'
 
 -- 사번, 이름, 부서명`
 SELECT     EMPLOYEE_ID                        사번, 
            FIRST_NAME || ' ' || LAST_NAME     이름, 
            CASE  DEPARTMENT_ID
               WHEN   60     THEN   'IT'
               WHEN   80     THEN   'Sales'
               WHEN   90     THEN   'Executive'
               ELSE                 '그외'
            END                                부서명
  FROM      EMPLOYEES
  ;
 
  SELECT    EMPLOYEE_ID                        사번, 
            FIRST_NAME || ' ' || LAST_NAME     이름, 
            CASE
               WHEN   DEPARTMENT_ID = 60     THEN   'IT'
               WHEN   DEPARTMENT_ID = 80     THEN   'Sales'
               WHEN   DEPARTMENT_ID = 90     THEN   'Executive'
               ELSE                                 '그외'
            END                                부서명
  FROM      EMPLOYEES
  ;
  
  -------------------------------------------------------------------
  -- 집계함수 : AGGREGATE 함수
  -- 모든 집계함수는 NULL 갑은 포함하지 않는다
  -- SUM(), AVG(), MIN(). MAX(), COUNT(), STDDEV(), VARIANCE()
  -- 합계   평균   최소   최대   줄수    표준편차   분산 
  -- 그루핑 : GROUP BY 
  -- ~ 별 인원수
  
  SELECT  *                      FROM EMPLOYEES;
  SELECT  COUNT(*)               FROM EMPLOYEES;   -- 109 : ROW  줄 수
  SELECT  COUNT(EMPLOYEE_ID)     FROM EMPLOYEES;   -- 109
  SELECT  COUNT(DEPARTMENT_ID)   FROM EMPLOYEES;   -- 106
  
  SELECT  EMPLOYEE_ID            FROM EMPLOYEES
   WHERE  DEPARTMENT_ID    IS  NULL;
  
  SELECT  COUNT(EMPLOYEE_ID)           FROM EMPLOYEES
   WHERE  DEPARTMENT_ID    IS  NULL;
  
  
  -- 전체 직원의 월급합 : 세로합 ( NULL 제외)
  SELECT  COUNT(SALARY)    FROM EMPLOYEES;      -- 107
  SELECT  SUM(SALARY)      FROM EMPLOYEES;      -- 691416
  SELECT  AVG(SALARY)      FROM EMPLOYEES;      -- 6461.831775700934579439252336448598130841
  SELECT  MAX(SALARY)      FROM EMPLOYEES;      -- 24000
  SELECT  MIN(SALARY)      FROM EMPLOYEES;      -- 2100
  
  SELECT  SUM(SALARY) / COUNT(SALARY) FROM  EMPLOYEES;  -- 6461.831775700934579439252336448598130841
  SELECT  SUM(SALARY) / COUNT(*) FROM  EMPLOYEES;       -- 6343.266055045871559633027522935779816514 
  
   -- 60번 부서의 평균월급
   SELECT     AVG(SALARY)
    FROM      EMPLOYEES
    WHERE     DEPARTMENT_ID  =  60;  -- 5760
   
   -- EMPLOYEES 테이블의 부서수를 알고 싶다 
   SELECT     COUNT( DEPARTMENT_ID )
    FROM      EMPLOYEES;              -- 106
   
   SELECT     DEPARTMENT_ID  
    FROM      EMPLOYEES;              -- 109  
   
    
   -- 중복을 제거(DISTINCT )한 부서의 수를 출력
   -- 중복을 제거한 부서번호 리스트 : NULL 출력됨
   SELECT     DISTINCT  DEPARTMENT_ID  
    FROM      EMPLOYEES;              -- 12 줄 
  
   SELECT     COUNT(DISTINCT  DEPARTMENT_ID)  
    FROM      EMPLOYEES;              -- 11
        
 
 --   직원이 근무하는 부서의 수 : 부서장이 있는 부서수 : DEPARTMENTS
 SELECT     COUNT( DEPARTMENT_ID )
  FROM      DEPARTMENTS  
  WHERE     MANAGER_ID   IS  NOT NULL;   -- 11
 

--
  SELECT    7 / 2,
           ROUND(156.456, 2),  ROUND(156.456, -2),
           TRUNC(156.456, 2),  TRUNC(156.456, -2)
   FROM    DUAL;         
 
 --   직원수, 월급합, 월급평균, 최대월급, 최소월급
 SELECT    COUNT(EMPLOYEE_ID)       직원수, 
           SUM( SALARY  )           월급합, 
           ROUND( AVG( SALARY ), 3)   월급평균, 
           MIN( SALARY  )           최대월급, 
           MAX( SALARY  )           최소월급
  FROM     EMPLOYEES

---------------------------------------
SQL  문의 실행 순서
1. FROM
2. WHERE
3. SELECT
4. ORDER BY
---------------------------------------
  
 --   부서 60번 부서 인원수, 월급합, 월급평균
 SELECT    COUNT( DEPARTMENT_ID )  부서인원수, 
           SUM(   SALARY  )        월급합, 
           AVG(   SALARY  )        월급평균  
  FROM     EMPLOYEES  
  WHERE    DEPARTMENT_ID  =  60;
 
 
 
 --   부서 50, 60, 80번 부서가 아닌 인원수, 월급합, 월급평균
 
 -- 22	194716	8850.73 -  NULL  3명 제외
 SELECT      COUNT( DEPARTMENT_ID )        인원수, 
             SUM(  SALARY  )               월급합, 
             ROUND( AVG(  SALARY  ), 2 )   월급평균
  FROM       EMPLOYEES
  WHERE    ( DEPARTMENT_ID <> 50
   AND      DEPARTMENT_ID   <> 60
   AND      DEPARTMENT_ID   <> 80  ); 
   
 SELECT      COUNT( DEPARTMENT_ID )        인원수, 
             SUM(  SALARY  )               월급합, 
             ROUND( AVG(  SALARY  ), 2 )   월급평균
  FROM       EMPLOYEES
  WHERE     DEPARTMENT_ID  NOT IN (50, 60, 80) ; 
  
 SELECT   COUNT(*)  
  FROM    EMPLOYEES
  WHERE   DEPARTMENT_ID = 80;
  
 -- 전체 109
 -- 50  : 45명
 -- 60  : 5명
 -- 80  : 34
 -- NULL : 3 명
 
 SELECT 109 - (45+5+34+3) FROM DUAL;  -- 22
  
 ----------------------------------------------------------------------------------
  부서별 사원수
 SELECT    DEPARTMENT_ID         부서번호,  
           COUNT( EMPLOYEE_ID )  사원수
  FROM     EMPLOYEES
 ;   -- ORA-00937: 단일 그룹의 그룹 함수가 아닙니다
     -- GROUP BY 절이 필요하다
     -- 일반칼럼과 집걔함수를 동시에 사용하면 ~별 통계롤 해석
 
 
  SELECT      DEPARTMENT_ID         부서번호,  
              COUNT( EMPLOYEE_ID )  사원수
  FROM        EMPLOYEES
--  WHERE
 -- GROUP BY    DEPARTMENT_ID  
  GROUP BY    ROLLUP( DEPARTMENT_ID  )
 --  HAVING    
  ORDER BY    DEPARTMENT_ID;
  
 -- 부서별 월급합, 월급 평균
 SELECT       DEPARTMENT_ID           부서번호, 
              SUM(SALARY)             월급합, 
              ROUND(AVG(SALARY), 2)   월급평균
  FROM        EMPLOYEES
  GROUP BY    DEPARTMENT_ID
  ORDER BY    DEPARTMENT_ID
  ;
 
  -- 부서별 사원수 통계
  SELECT      DEPARTMENT_ID,  COUNT(EMPLOYEE_ID)
   FROM       EMPLOYEES 
   GROUP BY   DEPARTMENT_ID
   ORDER BY   DEPARTMENT_ID
   ;  
  
  -- 부서별 인원수, 월급합
  SELECT       DEPARTMENT_ID, COUNT(EMPLOYEE_ID), SUM(SALARY)
   FROM        EMPLOYEES
   GROUP BY    DEPARTMENT_ID
   ORDER BY    DEPARTMENT_ID
  ; 
    
  -- 부서별 인원수가 5명이상인 부서번호
  SELECT       DEPARTMENT_ID 부서번호,  
               COUNT(EMPLOYEE_ID) 부서별인원수
   FROM        EMPLOYEES
   -- WHERE       부서별인원수 >= 5            --  ORA-00904: "부서별인원수": 부적합한 식별자
   -- WHERE       COUNT(EMPLOYEE_ID)  >= 5     --  ORA-00934: 그룹 함수는 허가되지 않습니다
   GROUP BY    DEPARTMENT_ID
    HAVING      COUNT(EMPLOYEE_ID)  >= 5  
   ORDER BY    DEPARTMENT_ID 
 ;  
      
 -- 부서별 월급총계가 20000 이상인 부서번호
 SELECT       DEPARTMENT_ID       부서번호, 
              SUM(SALARY)         월급총계
  FROM        EMPLOYEES
  GROUP BY    DEPARTMENT_ID  
   HAVING     SUM(SALARY)  >= 20000      -- 집계칼럼 조건
  ORDER BY    DEPARTMENT_ID
 ;   
 
  -- JOB_ID 별 인원수 
 SELECT      JOB_ID,  COUNT(EMPLOYEE_ID)
  FROM       EMPLOYEES
  GROUP BY   JOB_ID
  ORDER BY   JOB_ID
 ; 
  
  --  JOB_TITLE 별 인원수 
  
 
 --  입사일기준 월별 인원수, 2017년 기준
 SELECT      TO_CHAR(HIRE_DATE, 'MM')   입사월,
             COUNT(EMPLOYEE_ID)         월별인원수
  FROM       EMPLOYEES
  WHERE      TO_CHAR(HIRE_DATE, 'YYYY') = '2017'    -- 일반칼럼 조건
  GROUP BY   TO_CHAR(HIRE_DATE, 'MM')
  ORDER BY   TO_CHAR(HIRE_DATE, 'MM')
 ;
  
 -- 부서별 최대월급이 14000 이상인 부서의 부서번호와 최대월급
SELECT      DEPARTMENT_ID       부서,   
            MAX(SALARY)         최대월급
 FROM       EMPLOYEES 
 GROUP BY   DEPARTMENT_ID     
  HAVING    MAX(SALARY) >= 14000   -- 최대월급이 14000 이상    
 ORDER BY   DEPARTMENT_ID 
 ;
 
 -- 부서별 모우고 같은부서는 직업별 인원수, 월급평균
 SELECT      DEPARTMENT_ID               부서번호,  -- 부서명
             JOB_ID                      업무id,    -- JOB_TITLE
             COUNT( JOB_ID  )            인원수,   
             ROUND( AVG( SALARY ), 2)    월급평균
  FROM       EMPLOYEES
 -- GROUP BY   DEPARTMENT_ID, JOB_ID 
 -- GROUP BY   ROLLUP( DEPARTMENT_ID, JOB_ID )
  GROUP BY   CUBE( DEPARTMENT_ID, JOB_ID )
  ORDER BY   DEPARTMENT_ID, JOB_ID
  ;
  
 
 
 
 
 
 
 
 
 
 