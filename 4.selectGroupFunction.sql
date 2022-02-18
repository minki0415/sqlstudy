--4.selectGroupFunction.sql
-- 그룹함수란? 다수의 행 데이터를 한번에 처리
-- 장점 : 함수 연산시 null 데이터를 함수 내부적으로 사전에 고려해서 null값 보유한 field는 함수 로직 연산시 제외, sql 문장 작업 용이
/*
1. count() : 개수 확인 함수
2. sum() : 합계 함수
3. avg() : 평균
4. max(), min() : 최대값, 최소값 
*/
 
/* 기본 문법
1. select절
2. from 절
3. where절 

 * 그룹함수시 사용되는 문법
1. select절 : 검색하고자 하는 속성
2. from절	: 검색 table
3. group by 절 : 특정 조건별 그룹화하고자 하는 속성
4. having 절 : 그룹함수 사용시 조건절
5. order by절 : 검색된 데이터를 정렬
*/
  
--1. count() : 개수 확인 함수
-- emp table의 직원이 몇명?
select count(*) from emp;
select count(empno) from emp;

--? comm 받는 직원 수만 검색
select count(comm) from emp;
select count(empno) from emp where comm is not null;


--2. sum() : 합계 함수
-- ? 모든 사원의 월급여(sal)의 합
select sum(sal) from emp;


--? 모든 직원이 받는 comm 합
select sum(comm) from emp;


--?  MANAGER인 직원들의  월급여의 합 
select sum(sal) from emp where job = 'MANAGER';



--? job 종류 counting[절대 중복 불가 = distinct]
-- 데이터 job 확인
select job from emp;
select distinct job from emp;
select count(distinct job) from emp;

-- 논리적인 오류 : 집계 이후에 distinct 는 의미 없음
select distinct count(job) from emp; -- 출력값 : 12 / 문법은 맞지만 논리적으로 맞지않음



--3. avg() : 평균
--? emp table의 모든 직원들의 급여(sal) 평균 검색
select avg(sal) from emp;


--? 커미션 받는 사원수, 총 커미션 합, 커미션 평균 구하기
select count(comm), sum(comm), avg(comm) from emp;



--4. max(), min() : 최대값, 최소값
-- 숫자, date 타입에 사용 가능


--최대 급여, 최소 급여 검색
select sal from emp;
select max(sal), min(sal) from emp;


--?최근 입사한 사원의 입사일과, 가장 오래된 사원의 입사일 검색
-- 오라클의 date 즉 날짜를 의미하는 타입도 연산 가능
-- max(), min() 함수 사용해 보기
select max(hiredate) as 막내, min(hiredate) as 고참 from emp;


--*** 
/* group by절
- 특정 컬럼값을 기준으로 그룹화
	가령, 10번 부서끼리, 20번 부서끼리..
*/
-- 부서별 커미션 받는 사원수 
-- select deptno, count(comm) from emp; -- 오류
-- 함수를 미 적용하는 컬럼까지 검색 시에는 반드시 group by절에 명시
select deptno, count(comm) from emp group by deptno;



--? 부서별(group by deptno) (월급여) 평균 구함(avg())(그룹함수 사용시 부서 번호별로 그룹화 작업후 평균 연산)
select deptno, avg(sal) from emp group by deptno;

-- deptno 오름차순(asc) 정렬 추가
-- 존재하는 table 에서 부서별 그룹핑 후에 부서별 커미션 개수 파악 후에 부서번호 정렬
select deptno, avg(sal) from emp group by deptno order by deptno asc;


--? 소속 부서별 급여 총액과 평균 급여 검색[deptno 오름차순 정렬]
select deptno, sum(sal), avg(sal) from emp group by deptno order by deptno asc;



--? 소속 부서별 최대 급여와 최소 급여 검색[deptno 오름차순 정렬]
-- 컬럼명 별칭에 여백 포함한 문구를 사용하기 위해서는 쌍따옴표로만 처리
select deptno ,max(sal) "최대급여" ,min(sal) "최소급여" from emp group by deptno order by deptno asc;


-- *** having절 *** [ 조건을 주고 검색하기 ]
-- 그룹함수 사용시 조건문

--1. ? 부서별(group by) 사원의 수(count(*))와 커미션(count(comm)) 받는 사원의 수
select deptno, count(*), count(comm) from emp group by deptno;


-- 조건 추가
--2. ? 부서별 그룹을 지은후(group by deptno), 
-- 부서별(deptno) 평균 급여(avg())가 2000 이상(>=)부서의 번호와 평균 급여 검색 
select deptno, count(*), count(comm), avg(sal) from emp group by deptno; 

-- group 함수 문장 속 조건문은 having 절로 적용
-- 실행 순서 : from -> group by -> having -> select -> order by
select deptno, count(*), count(comm), avg(sal) from emp group by deptno having avg(sal) >= 2000; 
select deptno, count(*), count(comm), avg(sal) from emp group by deptno having avg(sal) >= 2000 order by deptno asc;

-- 정상
select deptno as 부서번호, count(*), count(comm), avg(sal) from emp group by deptno having avg(sal) >= 2000 order by 부서번호 asc;

-- 오류
select deptno, count(*), count(comm), avg(sal) as 평균 from emp group by deptno having 평균 >= 2000;




/* 오류 : 기존 조건절 where 사용 불가능
select deptno, count(*), count(comm), avg(sal) from emp group by deptno where avg(sal) >= 2000; 
*/


--3. 부서별 급여중 최대값(max)과 최소값(min)을 구하되 최대 급여가 2900이상(having)인 부서만 출력
select deptno, max(sal), min(sal) from emp group by deptno having max(sal) >= 2900;

