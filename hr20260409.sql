SELECT * FROM TAB;

--------------------------------------------------
SUBQUERY : SQL 문안에 SQL 문을 넣어서 실행한 방법
         : 반드시 () 안에 있어야한다
         : () 안에는 ORDER BY 사용불가
         : WHERE 조건에 맞도록 작성한다
         : 쿼리실행하는 순서가 필요할때 
--------------------------------------------------

 -- IT 부서의 직원정보를 출력하시오
1) IT 부서의 부서번호를 찾는다   -- 60
SELECT   DEPARTMENT_ID
 FROM    DEPARTMENTS
 WHERE   DEPARTMENT_NAME = 'IT'
 ;


2) 60번 부서의 직원정보를 출력
SELECT    EMPLOYEE_ID                        사번, 
          FIRST_NAME  || ' ' || LAST_NAME    이름, 
          DEPARTMENT_ID                      부서번호
 FROM     EMPLOYEES 
 WHERE    DEPARTMENT_ID = 60
 ;

1) + 2)
   SELECT    EMPLOYEE_ID                        사번, 
             FIRST_NAME  || ' ' || LAST_NAME    이름, 
             DEPARTMENT_ID                      부서번호
    FROM     EMPLOYEES 
    WHERE    DEPARTMENT_ID = (
         SELECT   DEPARTMENT_ID
             FROM    DEPARTMENTS
             WHERE   DEPARTMENT_NAME = 'IT'
    )
    ;


   SELECT    EMPLOYEE_ID                        사번, 
             FIRST_NAME  || ' ' || LAST_NAME    이름, 
             DEPARTMENT_ID                      부서번호
    FROM     EMPLOYEES 
    WHERE    DEPARTMENT_ID IN  ( 
         SELECT   DEPARTMENT_ID
             FROM    DEPARTMENTS
             WHERE   DEPARTMENT_NAME IN ( 'IT', 'Sales')                 
    )
    ;


-- 평균월급보다 않은 월급을 받는 사람의 명단
1) 평균월급   -- 6461.831775700934579439252336448598130841
SELECT   AVG( SALARY )
 FROM    EMPLOYEES 
 ;

2) 월급이  6461.831775700934579439252336448598130841 보다 많은 직원
SELECT   EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
 FROM    EMPLOYEES
 WHERE   SALARY >= 6461.831775700934579439252336448598130841
 ;

1) + 2)

SELECT   EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
 FROM    EMPLOYEES
 WHERE   SALARY >= (
    SELECT   AVG( SALARY )  FROM    EMPLOYEES 
 )
 ;

-- IT 부서의 평균월급보다 않은 월급을 받는 사람의 명단
1)  IT 부서의 부서번호 -- 60
SELECT   DEPARTMENT_ID
 FROM    DEPARTMENTS
 WHERE   DEPARTMENT_NAME = 'IT'
 ;

2)  60번 부서의 평균월급   -- 5760
SELECT   AVG(SALARY)
 FROM    EMPLOYEES
 WHERE   DEPARTMENT_ID  = 60
 ;
 

3)  2)번 보다 월급이 많은 사원의 정보를 출력
SELECT   EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
 FROM    EMPLOYEES
 WHERE   SALARY  >= 5760
 ;



1) + 2)
   SELECT   AVG(SALARY)
    FROM    EMPLOYEES
    WHERE   DEPARTMENT_ID  = (
        SELECT   DEPARTMENT_ID
         FROM    DEPARTMENTS
         WHERE   DEPARTMENT_NAME = 'IT'  
    )
 ;
1) + 2) + 3)

SELECT   EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
 FROM    EMPLOYEES
 WHERE   SALARY  >= (
   SELECT   AVG(SALARY)
    FROM    EMPLOYEES
    WHERE   DEPARTMENT_ID  = (
        SELECT   DEPARTMENT_ID
         FROM    DEPARTMENTS
         WHERE   DEPARTMENT_NAME = 'IT'  
    ) 
 );


-- 50 번의 부서의 최고 월급자의 이름을 출력
1)   50 번의 부서의 최고 월급
     SELECT    MAX(SALARY)  
      FROM     EMPLOYEES   
      WHERE    DEPARTMENT_ID   = 50
      ;
2)   최고 월급자의 이름
    SELECT     EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
     FROM      EMPLOYEES
     WHERE     SALARY     =  8200
     ;
     
 1) + 2)
      SELECT     EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
       FROM      EMPLOYEES
       WHERE     SALARY     =  (
          SELECT    MAX(SALARY)  
          FROM     EMPLOYEES   
          WHERE    DEPARTMENT_ID   = 50
       )
       AND        DEPARTMENT_ID   = 50
     ;
     

--  SALES 부서의 평균월급보다 많은 월급을 받는 사람의 명단
1)  SALES 부서의 부서번호
SELECT    DEPARTMENT_ID
 FROM     DEPARTMENTS
 WHERE    UPPER(DEPARTMENT_NAME) = 'SALES'
;

2)  !) 부서의 평균월급    -- 8955.882352941176470588235294117647058824
SELECT    AVG(SALARY)
 FROM     EMPLOYEES
 WHERE    DEPARTMENT_ID = 80
;


3)  2) 보다 많은 월급자의 명단 
SELECT   EMPLOYEE_ID, FIRST_NAME , LAST_NAME, SALARY
 FROM    EMPLOYEES 
 WHERE   SALARY >= 8955.882352941176470588235294117647058824
 ;
 
1) + 2) + 3)

SELECT   EMPLOYEE_ID, FIRST_NAME , LAST_NAME, SALARY
 FROM    EMPLOYEES 
 WHERE   SALARY >= (
    SELECT    AVG(SALARY)
     FROM     EMPLOYEES
     WHERE    DEPARTMENT_ID = (
        SELECT    DEPARTMENT_ID
         FROM     DEPARTMENTS
         WHERE    UPPER(DEPARTMENT_NAME) = 'SALES'
     ) 
 )
;

-- 다중 열  SUBQUERY
-- employees 테이블에서 job_id별로 가장 낮은 salary가 얼마인지 찾아보고,
-- 찾아낸 job_id별 salary에 해당하는 직원이 누구인지
SELECT *
FROM employees A
WHERE (A.job_id, A.salary) IN (
         SELECT job_id, MIN(salary) 그룹별급여
           FROM employees
           GROUP BY job_id
         )
 ORDER BY A.salary DESC;

-- 상관 서브 쿼리 CORELATIVE SUBQUERY
--  job_history에 있는 부서번호와 DEPARTMENTS 에 있는 부서번호가 같은 부서를 찾아서
--  DEPARTMENTS 에 있는 부서번호와 부서명을 출력
SELECT a.department_id, a.department_name
      FROM departments a
     WHERE EXISTS ( SELECT 1
                      FROM job_history b
                     WHERE a.department_id = b.department_id );


---- SHIPPING 부서의 직원명단

SELECT   EMPLOYEE_ID, FIRST_NAME, LAST_NAME
 FROM    EMPLOYEES
 WHERE   DEPARTMENT_ID = (
    SELECT  DEPARTMENT_ID     FROM  DEPARTMENTS
     WHERE  UPPER(DEPARTMENT_NAME) = 'SHIPPING'
 )
 ;    

------------------------------------------------------------------------
join
------------------------------------------------------------------------
직원이름,  부서명  --  출력줄수 109줄

SELECT 109*27 FROM DUAL;

ORCALE OLD 문법
1) 카티션프로덕트 :  109* 27 = 2943 -> CROSS JOIN , 조건이 없는
SELECT  FIRST_NAME || ' ' || LAST_NAME    직원이름,  
        DEPARTMENT_NAME                   부서명
 FROM   EMPLOYEES, DEPARTMENTS
;

2) 내부조인  : 양쪽다 존재한 DATA , NULL 제외
  : 109 - 3(부서번호 NULL) = 106    -> INNER JOIN
   비교 조건 필수
SELECT    EMPLOYEES.FIRST_NAME || ' ' || EMPLOYEES.LAST_NAME    직원이름,  
          DEPARTMENTS.DEPARTMENT_NAME                   부서명
 FROM     EMPLOYEES, DEPARTMENTS
 WHERE    EMPLOYEES.DEPARTMENT_ID =  DEPARTMENTS.DEPARTMENT_ID
;

SELECT    E.FIRST_NAME || ' ' || E.LAST_NAME    직원이름,  
          D.DEPARTMENT_NAME                   부서명
 FROM     EMPLOYEES   E, DEPARTMENTS   D
 WHERE    E.DEPARTMENT_ID =  D.DEPARTMENT_ID
;  

3) LEFT OUTER JOIN   -- 기준을 정해서 
   모든 직원을 출력하라   : 109 줄
  직원의 부서번호가 NULL 이라도 출력해야한다
  (+) : 기준(직원)이 되는 조건의 반대방향에 붙인다
        NULL 이 출력될 돗
 
 SELECT    E.FIRST_NAME || ' ' || E.LAST_NAME  이름,
           D.DEPARTMENT_NAME                   부서명
  FROM     EMPLOYEES  E,    DEPARTMENTS D  
  WHERE    E.DEPARTMENT_ID  =  D.DEPARTMENT_ID(+)
  ;
 
 
 4) RIGHT OUTER JOIN  -- 109   -- 기준을 정해서 
 SELECT    E.FIRST_NAME || ' ' || E.LAST_NAME  이름,
           D.DEPARTMENT_NAME                   부서명
  FROM     EMPLOYEES  E,    DEPARTMENTS D  
  WHERE    D.DEPARTMENT_ID(+) =  E.DEPARTMENT_ID  
  ;
 
 
4) RIGHT OUTER JOIN    
  모든 부서를 출력하라     -- 122 : (109 - 3) + (27 - 11)
  직원정보가 없더라고 출력해야한다

 SELECT    E.FIRST_NAME || ' ' || E.LAST_NAME  이름,
           D.DEPARTMENT_NAME                   부서명
  FROM     EMPLOYEES  E,    DEPARTMENTS D  
  WHERE    E.DEPARTMENT_ID(+)  =  D.DEPARTMENT_ID
  ;

5) FULL OUTER JOIN  - OLD 문법에 존재하지 않는 명령
   모든 직원과 모든 부서를 출력

-------------------------------------------------------------------
표준 SQL 문법
1.  CROSS JOIN   : 2943
SELECT   E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
 FROM    EMPLOYEES E  CROSS JOIN DEPARTMENTS D
 ;

2. (INNER) JOIN   -- 106

SELECT   E.FIRST_NAME , E.LAST_NAME, D.DEPARTMENT_NAME
 FROM    EMPLOYEES  E INNER JOIN DEPARTMENTS D 
   ON    E.DEPARTMENT_ID = D.DEPARTMENT_ID 
 ;


3. OUTER JOIN
1) LEFT  ( OUTER )  JOIN  -- 109
SELECT   E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
 FROM    EMPLOYEES E LEFT JOIN  DEPARTMENTS D
  ON     E.DEPARTMENT_ID =  D.DEPARTMENT_ID
;  

2) RIGHT ( OUTER )  JOIN  -- 122
SELECT   E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
 FROM    EMPLOYEES E RIGHT JOIN  DEPARTMENTS D
  ON     E.DEPARTMENT_ID =  D.DEPARTMENT_ID
;  

3) FULL  ( OUTER )  JOIN  -- 125 : 109 + 27 - 16

SELECT   E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
 FROM    EMPLOYEES E FULL JOIN  DEPARTMENTS D
  ON     E.DEPARTMENT_ID =  D.DEPARTMENT_ID
;  

 -- 직원이름, 담당업무(JOB_TITLE) : 109
SELECT      FIRST_NAME, LAST_NAME, 
            JOB_TITLE
 FROM       EMPLOYEES  E,  JOBS   J
 WHERE      E.JOB_ID  =  J.JOB_ID
 ORDER BY   FIRST_NAME, LAST_NAME;
  
SELECT      FIRST_NAME, LAST_NAME, 
            JOB_TITLE
 FROM       EMPLOYEES  E   JOIN  JOBS   J  
   ON       E.JOB_ID  =  J.JOB_ID
 ORDER BY   FIRST_NAME, LAST_NAME;
 
 SELECT      FIRST_NAME, LAST_NAME, 
             JOB_TITLE
 FROM        EMPLOYEES  E   FULL JOIN  JOBS   J  
   ON        E.JOB_ID  =  J.JOB_ID
 ORDER BY    FIRST_NAME, LAST_NAME;
 

 -- 부서명, 부서위치(CITY, STREE_ADDRESS)
 
 SELECT       D.DEPARTMENT_NAME, 
              CITY, 
              STREET_ADDRESS
  FROM        DEPARTMENTS   D     JOIN    LOCATIONS  L     
    ON        D.LOCATION_ID   =   L.LOCATION_ID
  ORDER  BY   D.DEPARTMENT_NAME
  ;
  
   SELECT       D.DEPARTMENT_NAME, 
              CITY, 
              STREET_ADDRESS
  FROM        DEPARTMENTS   D    LEFT JOIN    LOCATIONS  L     
    ON        D.LOCATION_ID   =   L.LOCATION_ID
  ORDER  BY   D.DEPARTMENT_NAME
  ;
  
 -- 직원명, 부서명, 부서위치(CITY, STREE_ADDRESS) : 106
 SELECT       E.FIRST_NAME || ' ' || E.LAST_NAME    직원명, 
              D.DEPARTMENT_NAME                     부서명, 
              L.CITY || ' ' || L.STREET_ADDRESS     부서위치 
  FROM        EMPLOYEES  E,  DEPARTMENTS  D,  LOCATIONS  L
  WHERE       E.DEPARTMENT_ID  =  D.DEPARTMENT_ID
   AND        D.LOCATION_ID    =  L.LOCATION_ID
   ORDER BY   직원명 ASC
   ;
 
 -- INNER JOIN
 SELECT       E.FIRST_NAME || ' ' || E.LAST_NAME    직원명, 
              D.DEPARTMENT_NAME                     부서명, 
              L.CITY || ' ' || L.STREET_ADDRESS     부서위치 
  FROM        EMPLOYEES  E  
              JOIN  DEPARTMENTS  D  ON   E.DEPARTMENT_ID  =  D.DEPARTMENT_ID
              JOIN  LOCATIONS    L  ON   D.LOCATION_ID    =  L.LOCATION_ID
   ORDER BY   직원명 ASC;   -- 106 
 
 -- LEFT OUTER JOIN   -- 109
 SELECT       E.FIRST_NAME || ' ' || E.LAST_NAME    직원명, 
              D.DEPARTMENT_NAME                     부서명, 
              L.CITY || ' ' || L.STREET_ADDRESS     부서위치 
  FROM        EMPLOYEES  E  
              LEFT JOIN  DEPARTMENTS  D  ON   E.DEPARTMENT_ID  =  D.DEPARTMENT_ID
              LEFT JOIN  LOCATIONS    L  ON   D.LOCATION_ID    =  L.LOCATION_ID
   ORDER BY   직원명 ASC;   -- 106 
 

 -- 직원명, 부서명, 국가, 부서위치(CITY, STREE_ADDRESS) 
 SELECT       E.FIRST_NAME || ' ' || E.LAST_NAME     직원명, 
              D.DEPARTMENT_NAME                      부서명, 
              C.COUNTRY_NAME                         국가, 
              L.CITY || ' ' ||  L.STREET_ADDRESS     부서위치
  FROM        EMPLOYEES   E   
              JOIN   DEPARTMENTS  D   ON    E.DEPARTMENT_ID  =  D.DEPARTMENT_ID
              JOIN   LOCATIONS    L   ON    D.LOCATION_ID    =  L.LOCATION_ID
              JOIN   COUNTRIES    C   ON    L.COUNTRY_ID     =  C.COUNTRY_ID
  ORDER BY    직원명, 부서명;    -- 106     
 
 SELECT       E.FIRST_NAME || ' ' || E.LAST_NAME     직원명, 
              D.DEPARTMENT_NAME                      부서명, 
              C.COUNTRY_NAME                         국가, 
              L.CITY || ' ' ||  L.STREET_ADDRESS     부서위치
  FROM        EMPLOYEES   E   
              LEFT  JOIN   DEPARTMENTS  D   ON    E.DEPARTMENT_ID  =  D.DEPARTMENT_ID
              LEFT  JOIN   LOCATIONS    L   ON    D.LOCATION_ID    =  L.LOCATION_ID
              LEFT  JOIN   COUNTRIES    C   ON    L.COUNTRY_ID     =  C.COUNTRY_ID
  ORDER BY    직원명, 부서명;    -- 109
 
 SELECT       E.FIRST_NAME || ' ' || E.LAST_NAME     직원명, 
              D.DEPARTMENT_NAME                      부서명, 
              C.COUNTRY_NAME                         국가, 
              L.CITY || ' ' ||  L.STREET_ADDRESS     부서위치
  FROM        EMPLOYEES   E   
              FULL  JOIN   DEPARTMENTS  D   ON    E.DEPARTMENT_ID  =  D.DEPARTMENT_ID
              FULL  JOIN   LOCATIONS    L   ON    D.LOCATION_ID    =  L.LOCATION_ID
              FULL  JOIN   COUNTRIES    C   ON    L.COUNTRY_ID     =  C.COUNTRY_ID
  ORDER BY    직원명, 부서명;    
 

 -- 부서명 , 국가 : 모든 부서 : 27줄이상 
 SELECT     D.DEPARTMENT_ID      부서명, 
            C.COUNTRY_NAME       국가
  FROM      DEPARTMENTS     D 
   JOIN     LOCATIONS       L   ON   D.LOCATION_ID  =  L.LOCATION_ID
   JOIN     COUNTRIES       C   ON   L.COUNTRY_ID   =  C.COUNTRY_ID
  ORDER BY  부서명, 국가
   ;
  
 
  -- 직원명, 부서위치 단 it 부서만
 SELECT       E.FIRST_NAME     || ' '   ||  E.LAST_NAME                           직원명, 
              L.STATE_PROVINCE || ', '  ||  L.CITY  || ', ' || L.STREET_ADDRESS   부서위치
  FROM        EMPLOYEES     E
   JOIN       DEPARTMENTS   D   ON  E.DEPARTMENT_ID   =   D.DEPARTMENT_ID
   JOIN       LOCATIONS     L   ON  D.LOCATION_ID     =   L.LOCATION_ID
  WHERE       D.DEPARTMENT_NAME  =  'IT' 
   ORDER BY   직원명
   ;
   
  SELECT  *
   FROM   EMPLOYEES
   WHERE  JOB_ID = 'IT_PROG'  ;
   
  -- 부서명별 월급평균
  1) 부서번호, 월급평균
  SELECT      DEPARTMENT_ID           부서번호, 
              ROUND(AVG(SALARY), 2)   월급평균
   FROM       EMPLOYEES  E  
   GROUP BY   DEPARTMENT_ID   
   ORDER BY   DEPARTMENT_ID  
  ;
  
 2) 부서명, 월급평균   --  11 INNER JOIN
  SELECT      D.DEPARTMENT_NAME         부서명, 
              ROUND(AVG(E.SALARY), 2)   월급평균
   FROM       EMPLOYEES    E 
     JOIN     DEPARTMENTS  D  ON  E.DEPARTMENT_ID = D.DEPARTMENT_ID
   GROUP BY   D.DEPARTMENT_NAME 
   ORDER BY   D.DEPARTMENT_NAME
  ;
  
  3) 모든 부서를 출력  -- 27 개 OUTER JOIN
     월급평균이 NULL  ->  '직원없음'
  SELECT      D.DEPARTMENT_NAME                            부서명, 
              -- NVL( ROUND(AVG(E.SALARY), 2), 0')             월급평균  -- 0 으로 정상춣력
              -- NVL( ROUND(AVG(E.SALARY), 2), '직원없음')     월급평균  -- ORA-01722: 수치가 부적합합니다
              DECODE( AVG(E.SALARY), NULL, '직원없음', 
                                           ROUND(AVG(E.SALARY), 2) )  월급평균
   FROM       EMPLOYEES    E  RIGHT  JOIN  DEPARTMENTS  D  ON  E.DEPARTMENT_ID = D.DEPARTMENT_ID
   GROUP BY   D.DEPARTMENT_NAME 
   ORDER BY   D.DEPARTMENT_NAME
  ;
 
  SELECT LAST_DAY(SYSDATE) FROM DUAL;
  
  -- 직원의 근무연수
  --  MONTH_BETWEEN(날짜1, 날짜2) :   날짜1 -  날짜2 : 월단위로
  --  ADD_MONTH(날짜, n) : 날짜+n개월 / 날짜-n개월
  SELECT   FIRST_NAME || ' ' || LAST_NAME                     직원명, 
           TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')                   입사일,
           TO_CHAR(TRUNC(HIRE_DATE, 'MONTH'), 'YYYY-MM-DD')   입사월의첫번째날,
           TO_CHAR(LAST_DAY(HIRE_DATE), 'YYYY-MM-DD')         입사월의마지막날,
           TRUNC(SYSDATE - HIRE_DATE)                         근무일수, 
           TRUNC( (SYSDATE - HIRE_DATE) / 365.2422)           근무연수,
           TRUNC(MONTHS_BETWEEN( SYSDATE, HIRE_DATE ) / 12 )  근무연수
          -- 근무연수
   FROM    EMPLOYEES;
     
  
  -- 60번 부서 최소월급과 같은 월급자의 명단출력
  1)  60번 부서의 최소월급   -- 2100
     SELECT  MIN(SALARY)
      FROM   EMPLOYEES;
   
  2)  1)  월급을 받는 사람의 이름
     SELECT  FIRST_NAME , LAST_NAME, SALARY
      FROM   EMPLOYEES
      WHERE  SALARY = 2100;
  3)
    SELECT  FIRST_NAME , LAST_NAME, SALARY
      FROM   EMPLOYEES
      WHERE  SALARY = (
          SELECT  MIN(SALARY)
          FROM   EMPLOYEES
      );  
  
  -- 부서명, 부서장의 이름
 1) INNER JOIN : 양쪽 다 존재하는 데이터만 출력 --  11
  SELECT    D.DEPARTMENT_NAME                    부서명, 
            E.FIRST_NAME || ' ' || E.LAST_NAME   부서장의이름
   FROM     DEPARTMENTS   D
    JOIN    EMPLOYEES     E   ON  D.MANAGER_ID = E.EMPLOYEE_ID ;  -- 11
 
 2) 모든 부서에 대해 출력 -- 27
  SELECT    D.DEPARTMENT_NAME                    부서명, 
            E.FIRST_NAME || ' ' || E.LAST_NAME   부서장의이름
   FROM     DEPARTMENTS   D  LEFT JOIN  EMPLOYEES   E   ON  D.MANAGER_ID = E.EMPLOYEE_ID ;  -- 11
 
  
  ------------------------------------------------------------------
  결합연산자 - 줄 단위 결합
   조건 -- 두테이블의 칸수와 타입이 동일해야한다
   1) UNION        중복 제거
   2) UNION ALL    중복 포함
   3) INTERSECT    교집합 : 곹오부분
   4) MINUS        차집합 a - b
   
   SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80;  -- 34
   SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;  -- 45
   
   SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80
   UNION
   SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;  -- 79
  
  -- 칼럼수와 칼럼들의 TYPE 이 같으면 합쳐진다 -> 주의할 것 : 의미없는 결합가능 
   SELECT  EMPLOYEE_ID,    FIRST_NAME      FROM EMPLOYEES
   UNION
   SELECT  DEPARTMENT_ID, DEPARTMENT_NAME  FROM DEPARTMENTS;
   

  
  -- 직원정보, 담당업무
  
  
  -- 직원명, 담당업무, 담당업무 히스토리
   
  -- 사번,   업무시작일,  업무종료일, 담당업무, 부서번호
  
  
  
   
  
  
