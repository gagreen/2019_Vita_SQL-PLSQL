/* PL/SQL 공부 */

-- 블럭의 형태
--IS
--    DECLARE
--    BEGIN
--    EXCEPTION
--END;

-- PL/SQL 블럭 출력을 위한 설정
SET SERVEROUTPUT ON; 

DECLARE
    vs_emp_name emp.ename%TYPE; -- PL/SQL 블럭 출력을 위한 설정
BEGIN
    SELECT ename INTO vs_emp_name
        FROM emp WHERE empno = 7900;
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || vs_emp_name);
END;
/

--반복문
-- 구구단 예제 (LOOP)
DECLARE
    vs_line NUMBER := 1;
    vs_col NUMBER := 1;
BEGIN
    LOOP
        vs_col := 1;
        LOOP
            DBMS_OUTPUT.PUT_LINE( vs_line || ' * ' || vs_col || ' = ' || vs_line*vs_col);
            vs_col := vs_col + 1;
            EXIT WHEN vs_col > 9;
        END LOOP;
        vs_line := vs_line + 1;
        DBMS_OUTPUT.PUT_LINE('');
        EXIT WHEN vs_line > 9;
    END LOOP;
END;
/

-- 구구단 예제 (WHILE)
DECLARE
    vs_line NUMBER := 1;
    vs_col NUMBER := 1;
BEGIN
    WHILE vs_line <= 9 LOOP
        vs_col := 1;
        WHILE vs_col <= 9 LOOP
            DBMS_OUTPUT.PUT_LINE( vs_line || ' * ' || vs_col || ' = ' || vs_line*vs_col);
            vs_col := vs_col + 1;
        END LOOP;
        vs_line := vs_line + 1;
        DBMS_OUTPUT.PUT_LINE('');      
    END LOOP;
END;
/

-- 구구단 예제 (FOR)
BEGIN
    FOR vs_line IN /*REVERSE*/ 1..9 LOOP    
        FOR vs_col IN 1..9 LOOP
            -- CONTINUE WHEN ~~;
            DBMS_OUTPUT.PUT_LINE( vs_line || ' * ' || vs_col || ' = ' || vs_line*vs_col);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/


--조건문
-- IF문
DECLARE
    vs_a NUMBER := 1;
    vs_b NUMBER := 2;
BEGIN
    IF vs_a = vs_b THEN SYS.DBMS_OUTPUT.PUT_LINE('a는 b와 같습니다');
    ELSIF vs_a = 3 THEN SYS.DBMS_OUTPUT.PUT_LINE('a는 3입니다');
    ELSE SYS.DBMS_OUTPUT.PUT_LINE('a는 3이 아닙니다');
    END IF;
END;
/

-- CASE 문
DECLARE
    vs_a NUMBER := 1;
    vs_b NUMBER := 2;
BEGIN
    CASE
        WHEN vs_a = vs_b THEN DBMS_OUTPUT.PUT_LINE('a == 1');
        WHEN vs_a = 3 THEN DBMS_OUTPUT.PUT_LINE('a == 3');
        ELSE DBMS_OUTPUT.PUT_LINE('NOTHING');
    END CASE;
END;
/


-- 그 외
-- GOTO 일관성을 해치므로 지양할 것
DECLARE
  vs_gugu_line number := 0;
BEGIN
  FOR i IN 1..9
  LOOP
    DBMS_OUTPUT.PUT_LINE( i || '단 입니다.');
    IF i = 5 THEN 
        vs_gugu_line := i; 
        GOTO printing;
    -- ELSE NULL; 아무것도 지정하지 않을 때
    END IF;
    FOR j IN 1..9
    LOOP 
        DBMS_OUTPUT.PUT_LINE(i || ' * ' || j || ' = ' || (i * j));
        END LOOP;
  END LOOP;

  <<printing>>
  DBMS_OUTPUT.PUT_LINE('GOTO로 이동한 라인은 ' || vs_gugu_line || ' 입니다');
  
END;
/


--SUB-PROGRAM
-- FUNCTION
CREATE OR REPLACE FUNCTION fu_sum_gugu( vn_row NUMBER )
RETURN NUMBER
IS
  vn_gugu_sum NUMBER := 0;
BEGIN
  FOR i in 1..9
    LOOP
     vn_gugu_sum := vn_gugu_sum + (vn_row * i);
    END LOOP;
    RETURN vn_gugu_sum;
END;
/
SELECT fu_sum_gugu(1) FROM dual;

-- PROCEDURE
CREATE OR REPLACE PROCEDURE my_parameter_test_proc(
    p_var1 VARCHAR2,
    p_var2 OUT VARCHAR2,
    p_var3 IN OUT VARCHAR2 )
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('p_var1 value = ' || p_var1);
    DBMS_OUTPUT.PUT_LINE('p_var2 value = ' || p_var2);
    DBMS_OUTPUT.PUT_LINE('p_var3 value = ' || p_var3);
    
    -- p_var1은 피할당자로 사용 불가
    p_var2 := 'B2';
    p_var3 := 'C2';
 
END;
/
DECLARE
    v_var1 VARCHAR2(10) := 'A';
    v_var2 VARCHAR2(10) := 'B';
    v_var3 VARCHAR2(10) := 'C';
BEGIN
    my_parameter_test_proc (v_var1, v_var2, v_var3);
    DBMS_OUTPUT.PUT_LINE('-------------------');
    DBMS_OUTPUT.PUT_LINE('v_var1 = ' || v_var1);
    DBMS_OUTPUT.PUT_LINE('v_var2 = ' || v_var2);
    DBMS_OUTPUT.PUT_LINE('v_var3 = ' || v_var3);
END;
/
    -- '=>'라는 기호를 통해 매개변수 전달 시 초기화 가능
    -- EXEC 또는 EXCUTE 명령어를 사용하여 프로시저를 실행한다.


-- EXCEPTION 처리
-- 형태
-- EXCEPTION WHEN 예외명1 THEN 예외처리 구문1
--      WHEN 예외명2 THEN 예외처리 구문2
--   ..
--      WHEN OTHERS THEN 예외처리 구문n;
CREATE OR REPLACE PROCEDURE exception_test_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10/0;
    DBMS_OUTPUT.PUT_LINE('성공!');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('에러 코드 : '|| SQLCODE);  -- 오류에 해당하는 코드 반환
    DBMS_OUTPUT.PUT_LINE('에러 메세지 : '|| SQLERRM); -- 오류에 대한 메세지 반환(매개변수를 주면 해당 코드의 에러 정보를 반환)
    DBMS_OUTPUT.PUT_LINE('상세 에러메시지 : ' || SYS.dbms_utility.format_call_stack);      -- 콜 스택을 반환
    DBMS_OUTPUT.PUT_LINE('상세 에러메시지 : ' || SYS.dbms_utility.format_error_stack);     -- 에러 스택 내용 반환
    DBMS_OUTPUT.PUT_LINE('상세 에러메시지 : ' || SYS.dbms_utility.format_error_backtrace); -- 오류 역추적 결과 반환
    DBMS_OUTPUT.PUT_LINE('오류 발생!');
END;
/

BEGIN
    exception_test_proc();
    DBMS_OUTPUT.PUT_LINE('예외 발생 지점을 지남.'); -- 예외처리를 한 곳 뒤의 로직은 정상적으로 작동한다.
END;
/

-- 사용자 정의 예외
CREATE OR REPLACE PROCEDURE exception_test_proc2(vs_empno emp.empno%TYPE)
IS
    vn_cnt NUMBER := 0;
    ex_not_exist_phone EXCEPTION;
     PRAGMA EXCEPTION_INIT (ex_not_exist_phone, -1802); --시스템 예외와 사용자 정의 예외의 연결
BEGIN
    SELECT COUNT(*) INTO vn_cnt
        FROM emp WHERE vs_empno = empno;
    
    IF vn_cnt > 0 THEN
        DBMS_OUTPUT.PUT_LINE('등록된 사원번호입니다.');
    ELSE
        RAISE ex_not_exist_phone; -- RAISE : 예외를 강제적으로 발생시킴
        -- RAISE_APPLICATION_ERROR(-20200, '등록된 번호가 없습니다. 에러코드 20200'); --예외 코드와 예외 메ㅣ지를 지접 정의할 수 있음
    END IF;
    EXCEPTION
        WHEN ex_not_exist_phone THEN
            DBMS_OUTPUT.PUT_LINE('등록되지 않은 사원번호입니다.');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
EXEC exception_test_proc2(369);


--TRANSACTION
    -- COMMIT : 데이터베이스에 연산이 정확하게 종료되어 변경내욕을 실제 데이터베이스에 반영
    -- ROLLBACK : 연산 도중 문제가 발생하였을 때 직전의 COMMIT지점으로 되돌림
    -- SAVEPOINT : ROLLBACK할 시에 SAVEPOINT를 지정하여 그 부분까지 트랜젝션을 취소함 "ROLLBACK TO 세이브포인트명" 형태로 실행


-- Cursor (포인터와 유사함)
-- 묵시적 커서(Implicit cursor)
DECLARE
    v_emp_name emp.ename%TYPE;
    v_emp_hiredate emp.hiredate%TYPE;
BEGIN
    SELECT ename, hiredate INTO v_emp_name, v_emp_hiredate
        FROM emp WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(v_emp_name);
    DBMS_OUTPUT.PUT_LINE(v_emp_hiredate);
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT); -- 영향 받은 결과 집합의 ROW 수 반환
    
    IF SQL%FOUND THEN -- 패치 ROW가 1개 이상이면 TRUE, 아니면 FALSE
        DBMS_OUTPUT.PUT_LINE('패치 ROW 수가 1개 이상');
    END IF;
    
    IF SQL%NOTFOUND THEN -- FOUND와 반대
        DBMS_OUTPUT.PUT_LINE('패치 ROW 수가 0개');
    END IF;
    
    IF SQL%ISOPEN THEN --커서가 열려 있으면 TRUE, 닫혀 있으면 FALSE (묵시적 커서는 항상 FALSE 반환)
        DBMS_OUTPUT.PUT_LINE('커서가 열림');
    ELSE
        DBMS_OUTPUT.PUT_LINE('커서가 닫힘');
    END IF;
END;
/

-- 명시적 커서
DECLARE 
    v_emp_name emp.ename%TYPE;
    v_emp_hiredate emp.hiredate%TYPE;
    
    CURSOR cur_emp -- 커서 선언
    IS
        SELECT ename, hiredate FROM emp
            WHERE empno between 7500 AND 8000;
BEGIN
    OPEN cur_emp(); -- 커서 열기
    LOOP
        FETCH cur_emp INTO v_emp_name, v_emp_hiredate; -- 패치(개수와 타입을 일치시켜야 함)
        EXIT WHEN cur_emp%NOTFOUND; -- 패치 값이 없을 때 반복문 종료
        DBMS_OUTPUT.PUT_LINE(v_emp_name || ' ' || v_emp_hiredate);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(cur_emp%ROWCOUNT);
    IF cur_emp%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Cursor is Opend');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cursor is Closed');
    END IF;
    
    CLOSE cur_emp; -- 커서 닫기
    
    IF cur_emp%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Cursor is Opend');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cursor is Closed');
    END IF;
END;
/

-- FOR 형태
DECLARE
    CURSOR cur_emp
    IS
    SELECT * FROM emp WHERE empno BETWEEN 7700 AND 7900;
BEGIN
    FOR v_emp_rec IN cur_emp()  -- 커서 열기 및 패치 (v_emp_rec를 통해 구조체를 참조하는 것처럼 사용 가능)
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_emp_rec.ename || ' ' || v_emp_rec.hiredate || ' ' || v_emp_rec.sal);
    END LOOP;
END;
/

-- 커서 변수
-- TYPE dep_curtype IS REF CURSOR RETURN department%ROWTYPE; --강한 타입
/* PL/SQL 공부 */

-- 블럭의 형태
--IS
--    DECLARE
--    BEGIN
--    EXCEPTION
--END;

-- PL/SQL 블럭 출력을 위한 설정
SET SERVEROUTPUT ON; 

DECLARE
    vs_emp_name emp.ename%TYPE; -- PL/SQL 블럭 출력을 위한 설정
BEGIN
    SELECT ename INTO vs_emp_name
        FROM emp WHERE empno = 7900;
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || vs_emp_name);
END;
/

--반복문
-- 구구단 예제 (LOOP)
DECLARE
    vs_line NUMBER := 1;
    vs_col NUMBER := 1;
BEGIN
    LOOP
        vs_col := 1;
        LOOP
            DBMS_OUTPUT.PUT_LINE( vs_line || ' * ' || vs_col || ' = ' || vs_line*vs_col);
            vs_col := vs_col + 1;
            EXIT WHEN vs_col > 9;
        END LOOP;
        vs_line := vs_line + 1;
        DBMS_OUTPUT.PUT_LINE('');
        EXIT WHEN vs_line > 9;
    END LOOP;
END;
/

-- 구구단 예제 (WHILE)
DECLARE
    vs_line NUMBER := 1;
    vs_col NUMBER := 1;
BEGIN
    WHILE vs_line <= 9 LOOP
        vs_col := 1;
        WHILE vs_col <= 9 LOOP
            DBMS_OUTPUT.PUT_LINE( vs_line || ' * ' || vs_col || ' = ' || vs_line*vs_col);
            vs_col := vs_col + 1;
        END LOOP;
        vs_line := vs_line + 1;
        DBMS_OUTPUT.PUT_LINE('');      
    END LOOP;
END;
/

-- 구구단 예제 (FOR)
BEGIN
    FOR vs_line IN /*REVERSE*/ 1..9 LOOP    
        FOR vs_col IN 1..9 LOOP
            -- CONTINUE WHEN ~~;
            DBMS_OUTPUT.PUT_LINE( vs_line || ' * ' || vs_col || ' = ' || vs_line*vs_col);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/


--조건문
-- IF문
DECLARE
    vs_a NUMBER := 1;
    vs_b NUMBER := 2;
BEGIN
    IF vs_a = vs_b THEN SYS.DBMS_OUTPUT.PUT_LINE('a는 b와 같습니다');
    ELSIF vs_a = 3 THEN SYS.DBMS_OUTPUT.PUT_LINE('a는 3입니다');
    ELSE SYS.DBMS_OUTPUT.PUT_LINE('a는 3이 아닙니다');
    END IF;
END;
/

-- CASE 문
DECLARE
    vs_a NUMBER := 1;
    vs_b NUMBER := 2;
BEGIN
    CASE
        WHEN vs_a = vs_b THEN DBMS_OUTPUT.PUT_LINE('a == 1');
        WHEN vs_a = 3 THEN DBMS_OUTPUT.PUT_LINE('a == 3');
        ELSE DBMS_OUTPUT.PUT_LINE('NOTHING');
    END CASE;
END;
/


-- 그 외
-- GOTO 일관성을 해치므로 지양할 것
DECLARE
  vs_gugu_line number := 0;
BEGIN
  FOR i IN 1..9
  LOOP
    DBMS_OUTPUT.PUT_LINE( i || '단 입니다.');
    IF i = 5 THEN 
        vs_gugu_line := i; 
        GOTO printing;
    -- ELSE NULL; 아무것도 지정하지 않을 때
    END IF;
    FOR j IN 1..9
    LOOP 
        DBMS_OUTPUT.PUT_LINE(i || ' * ' || j || ' = ' || (i * j));
        END LOOP;
  END LOOP;

  <<printing>>
  DBMS_OUTPUT.PUT_LINE('GOTO로 이동한 라인은 ' || vs_gugu_line || ' 입니다');
  
END;
/


--SUB-PROGRAM
-- FUNCTION
CREATE OR REPLACE FUNCTION fu_sum_gugu( vn_row NUMBER )
RETURN NUMBER
IS
  vn_gugu_sum NUMBER := 0;
BEGIN
  FOR i in 1..9
    LOOP
     vn_gugu_sum := vn_gugu_sum + (vn_row * i);
    END LOOP;
    RETURN vn_gugu_sum;
END;
/
SELECT fu_sum_gugu(1) FROM dual;

-- PROCEDURE
CREATE OR REPLACE PROCEDURE my_parameter_test_proc(
    p_var1 VARCHAR2,
    p_var2 OUT VARCHAR2,
    p_var3 IN OUT VARCHAR2 )
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('p_var1 value = ' || p_var1);
    DBMS_OUTPUT.PUT_LINE('p_var2 value = ' || p_var2);
    DBMS_OUTPUT.PUT_LINE('p_var3 value = ' || p_var3);
    
    -- p_var1은 피할당자로 사용 불가
    p_var2 := 'B2';
    p_var3 := 'C2';
 
END;
/
DECLARE
    v_var1 VARCHAR2(10) := 'A';
    v_var2 VARCHAR2(10) := 'B';
    v_var3 VARCHAR2(10) := 'C';
BEGIN
    my_parameter_test_proc (v_var1, v_var2, v_var3);
    DBMS_OUTPUT.PUT_LINE('-------------------');
    DBMS_OUTPUT.PUT_LINE('v_var1 = ' || v_var1);
    DBMS_OUTPUT.PUT_LINE('v_var2 = ' || v_var2);
    DBMS_OUTPUT.PUT_LINE('v_var3 = ' || v_var3);
END;
/
    -- '=>'라는 기호를 통해 매개변수 전달 시 초기화 가능
    -- EXEC 또는 EXCUTE 명령어를 사용하여 프로시저를 실행한다.


-- EXCEPTION 처리
-- 형태
-- EXCEPTION WHEN 예외명1 THEN 예외처리 구문1
--      WHEN 예외명2 THEN 예외처리 구문2
--   ..
--      WHEN OTHERS THEN 예외처리 구문n;
CREATE OR REPLACE PROCEDURE exception_test_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10/0;
    DBMS_OUTPUT.PUT_LINE('성공!');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('에러 코드 : '|| SQLCODE);  -- 오류에 해당하는 코드 반환
    DBMS_OUTPUT.PUT_LINE('에러 메세지 : '|| SQLERRM); -- 오류에 대한 메세지 반환(매개변수를 주면 해당 코드의 에러 정보를 반환)
    DBMS_OUTPUT.PUT_LINE('상세 에러메시지 : ' || SYS.dbms_utility.format_call_stack);      -- 콜 스택을 반환
    DBMS_OUTPUT.PUT_LINE('상세 에러메시지 : ' || SYS.dbms_utility.format_error_stack);     -- 에러 스택 내용 반환
    DBMS_OUTPUT.PUT_LINE('상세 에러메시지 : ' || SYS.dbms_utility.format_error_backtrace); -- 오류 역추적 결과 반환
    DBMS_OUTPUT.PUT_LINE('오류 발생!');
END;
/

BEGIN
    exception_test_proc();
    DBMS_OUTPUT.PUT_LINE('예외 발생 지점을 지남.'); -- 예외처리를 한 곳 뒤의 로직은 정상적으로 작동한다.
END;
/

-- 사용자 정의 예외
CREATE OR REPLACE PROCEDURE exception_test_proc2(vs_empno emp.empno%TYPE)
IS
    vn_cnt NUMBER := 0;
    ex_not_exist_phone EXCEPTION;
     PRAGMA EXCEPTION_INIT (ex_not_exist_phone, -1802); --시스템 예외와 사용자 정의 예외의 연결
BEGIN
    SELECT COUNT(*) INTO vn_cnt
        FROM emp WHERE vs_empno = empno;
    
    IF vn_cnt > 0 THEN
        DBMS_OUTPUT.PUT_LINE('등록된 사원번호입니다.');
    ELSE
        RAISE ex_not_exist_phone; -- RAISE : 예외를 강제적으로 발생시킴
        -- RAISE_APPLICATION_ERROR(-20200, '등록된 번호가 없습니다. 에러코드 20200'); --예외 코드와 예외 메ㅣ지를 지접 정의할 수 있음
    END IF;
    EXCEPTION
        WHEN ex_not_exist_phone THEN
            DBMS_OUTPUT.PUT_LINE('등록되지 않은 사원번호입니다.');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
EXEC exception_test_proc2(369);


--TRANSACTION
    -- COMMIT : 데이터베이스에 연산이 정확하게 종료되어 변경내욕을 실제 데이터베이스에 반영
    -- ROLLBACK : 연산 도중 문제가 발생하였을 때 직전의 COMMIT지점으로 되돌림
    -- SAVEPOINT : ROLLBACK할 시에 SAVEPOINT를 지정하여 그 부분까지 트랜젝션을 취소함 "ROLLBACK TO 세이브포인트명" 형태로 실행


-- Cursor (포인터와 유사함)
-- 묵시적 커서(Implicit cursor)
DECLARE
    v_emp_name emp.ename%TYPE;
    v_emp_hiredate emp.hiredate%TYPE;
BEGIN
    SELECT ename, hiredate INTO v_emp_name, v_emp_hiredate
        FROM emp WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(v_emp_name);
    DBMS_OUTPUT.PUT_LINE(v_emp_hiredate);
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT); -- 영향 받은 결과 집합의 ROW 수 반환
    
    IF SQL%FOUND THEN -- 패치 ROW가 1개 이상이면 TRUE, 아니면 FALSE
        DBMS_OUTPUT.PUT_LINE('패치 ROW 수가 1개 이상');
    END IF;
    
    IF SQL%NOTFOUND THEN -- FOUND와 반대
        DBMS_OUTPUT.PUT_LINE('패치 ROW 수가 0개');
    END IF;
    
    IF SQL%ISOPEN THEN --커서가 열려 있으면 TRUE, 닫혀 있으면 FALSE (묵시적 커서는 항상 FALSE 반환)
        DBMS_OUTPUT.PUT_LINE('커서가 열림');
    ELSE
        DBMS_OUTPUT.PUT_LINE('커서가 닫힘');
    END IF;
END;
/

-- 명시적 커서
DECLARE 
    v_emp_name emp.ename%TYPE;
    v_emp_hiredate emp.hiredate%TYPE;
    
    CURSOR cur_emp -- 커서 선언
    IS
        SELECT ename, hiredate FROM emp
            WHERE empno between 7500 AND 8000;
BEGIN
    OPEN cur_emp(); -- 커서 열기
    LOOP
        FETCH cur_emp INTO v_emp_name, v_emp_hiredate; -- 패치(개수와 타입을 일치시켜야 함)
        EXIT WHEN cur_emp%NOTFOUND; -- 패치 값이 없을 때 반복문 종료
        DBMS_OUTPUT.PUT_LINE(v_emp_name || ' ' || v_emp_hiredate);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(cur_emp%ROWCOUNT);
    IF cur_emp%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Cursor is Opend');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cursor is Closed');
    END IF;
    
    CLOSE cur_emp; -- 커서 닫기
    
    IF cur_emp%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Cursor is Opend');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cursor is Closed');
    END IF;
END;
/

-- FOR 형태
DECLARE
    CURSOR cur_emp
    IS
    SELECT * FROM emp WHERE empno BETWEEN 7700 AND 7900;
BEGIN
    FOR v_emp_rec IN cur_emp()  -- 커서 열기 및 패치 (v_emp_rec를 통해 구조체를 참조하는 것처럼 사용 가능)
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_emp_rec.ename || ' ' || v_emp_rec.hiredate || ' ' || v_emp_rec.sal);
    END LOOP;
END;
/

-- 커서 변수
-- TYPE dep_curtype IS REF CURSOR RETURN department%ROWTYPE; -- 강한 타입
-- TYPE dep_curtype IS REF CURSOR;                           -- 약한 타입
-- SYS_REFCURSOR                                             -- 약한 타입
-- OPEN 변수명 FOR select문
DECLARE
    TYPE emp_curtype IS REF CURSOR RETURN emp%ROWTYPE;
    emp_curvar /*emp_curtype*/ SYS_REFCURSOR;
    vr_emp emp%ROWTYPE;
BEGIN
    OPEN emp_curvar FOR SELECT * FROM emp WHERE empno BETWEEN 7500 AND 7700;

    LOOP
        FETCH emp_curvar INTO vr_emp;
        DBMS_OUTPUT.PUT_LINE(vr_emp.hiredate || ' ' || vr_emp.ename);
        EXIT WHEN emp_curvar%NOTFOUND;
    END LOOP;
END;
/

-- 서브쿼리 커서
DECLARE
    CURSOR test_cur IS
        SELECT d.dname,
            CURSOR(SELECT e.ename
                FROM emp e
                WHERE e.deptno = d.deptno) AS emp_name
            FROM dept d
            WHERE d.deptno = 10;
    
    vs_dept_name dept.dname%TYPE; -- 부서 지정
    c_emp_name SYS_REFCURSOR; -- 이름을 모두 출력하기 위한 커서 변수
    vs_emp_name emp.ename%TYPE; -- 이름 지정

BEGIN
    OPEN test_cur;
        