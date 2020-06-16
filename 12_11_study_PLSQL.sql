/* PL/SQL ���� */

-- ���� ����
--IS
--    DECLARE
--    BEGIN
--    EXCEPTION
--END;

-- PL/SQL �� ����� ���� ����
SET SERVEROUTPUT ON; 

DECLARE
    vs_emp_name emp.ename%TYPE; -- PL/SQL �� ����� ���� ����
BEGIN
    SELECT ename INTO vs_emp_name
        FROM emp WHERE empno = 7900;
    DBMS_OUTPUT.PUT_LINE('����� : ' || vs_emp_name);
END;
/

--�ݺ���
-- ������ ���� (LOOP)
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

-- ������ ���� (WHILE)
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

-- ������ ���� (FOR)
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


--���ǹ�
-- IF��
DECLARE
    vs_a NUMBER := 1;
    vs_b NUMBER := 2;
BEGIN
    IF vs_a = vs_b THEN SYS.DBMS_OUTPUT.PUT_LINE('a�� b�� �����ϴ�');
    ELSIF vs_a = 3 THEN SYS.DBMS_OUTPUT.PUT_LINE('a�� 3�Դϴ�');
    ELSE SYS.DBMS_OUTPUT.PUT_LINE('a�� 3�� �ƴմϴ�');
    END IF;
END;
/

-- CASE ��
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


-- �� ��
-- GOTO �ϰ����� ��ġ�Ƿ� ������ ��
DECLARE
  vs_gugu_line number := 0;
BEGIN
  FOR i IN 1..9
  LOOP
    DBMS_OUTPUT.PUT_LINE( i || '�� �Դϴ�.');
    IF i = 5 THEN 
        vs_gugu_line := i; 
        GOTO printing;
    -- ELSE NULL; �ƹ��͵� �������� ���� ��
    END IF;
    FOR j IN 1..9
    LOOP 
        DBMS_OUTPUT.PUT_LINE(i || ' * ' || j || ' = ' || (i * j));
        END LOOP;
  END LOOP;

  <<printing>>
  DBMS_OUTPUT.PUT_LINE('GOTO�� �̵��� ������ ' || vs_gugu_line || ' �Դϴ�');
  
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
    
    -- p_var1�� ���Ҵ��ڷ� ��� �Ұ�
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
    -- '=>'��� ��ȣ�� ���� �Ű����� ���� �� �ʱ�ȭ ����
    -- EXEC �Ǵ� EXCUTE ��ɾ ����Ͽ� ���ν����� �����Ѵ�.


-- EXCEPTION ó��
-- ����
-- EXCEPTION WHEN ���ܸ�1 THEN ����ó�� ����1
--      WHEN ���ܸ�2 THEN ����ó�� ����2
--   ..
--      WHEN OTHERS THEN ����ó�� ����n;
CREATE OR REPLACE PROCEDURE exception_test_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10/0;
    DBMS_OUTPUT.PUT_LINE('����!');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('���� �ڵ� : '|| SQLCODE);  -- ������ �ش��ϴ� �ڵ� ��ȯ
    DBMS_OUTPUT.PUT_LINE('���� �޼��� : '|| SQLERRM); -- ������ ���� �޼��� ��ȯ(�Ű������� �ָ� �ش� �ڵ��� ���� ������ ��ȯ)
    DBMS_OUTPUT.PUT_LINE('�� �����޽��� : ' || SYS.dbms_utility.format_call_stack);      -- �� ������ ��ȯ
    DBMS_OUTPUT.PUT_LINE('�� �����޽��� : ' || SYS.dbms_utility.format_error_stack);     -- ���� ���� ���� ��ȯ
    DBMS_OUTPUT.PUT_LINE('�� �����޽��� : ' || SYS.dbms_utility.format_error_backtrace); -- ���� ������ ��� ��ȯ
    DBMS_OUTPUT.PUT_LINE('���� �߻�!');
END;
/

BEGIN
    exception_test_proc();
    DBMS_OUTPUT.PUT_LINE('���� �߻� ������ ����.'); -- ����ó���� �� �� ���� ������ ���������� �۵��Ѵ�.
END;
/

-- ����� ���� ����
CREATE OR REPLACE PROCEDURE exception_test_proc2(vs_empno emp.empno%TYPE)
IS
    vn_cnt NUMBER := 0;
    ex_not_exist_phone EXCEPTION;
     PRAGMA EXCEPTION_INIT (ex_not_exist_phone, -1802); --�ý��� ���ܿ� ����� ���� ������ ����
BEGIN
    SELECT COUNT(*) INTO vn_cnt
        FROM emp WHERE vs_empno = empno;
    
    IF vn_cnt > 0 THEN
        DBMS_OUTPUT.PUT_LINE('��ϵ� �����ȣ�Դϴ�.');
    ELSE
        RAISE ex_not_exist_phone; -- RAISE : ���ܸ� ���������� �߻���Ŵ
        -- RAISE_APPLICATION_ERROR(-20200, '��ϵ� ��ȣ�� �����ϴ�. �����ڵ� 20200'); --���� �ڵ�� ���� �ޤ����� ���� ������ �� ����
    END IF;
    EXCEPTION
        WHEN ex_not_exist_phone THEN
            DBMS_OUTPUT.PUT_LINE('��ϵ��� ���� �����ȣ�Դϴ�.');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
EXEC exception_test_proc2(369);


--TRANSACTION
    -- COMMIT : �����ͺ��̽��� ������ ��Ȯ�ϰ� ����Ǿ� ���泻���� ���� �����ͺ��̽��� �ݿ�
    -- ROLLBACK : ���� ���� ������ �߻��Ͽ��� �� ������ COMMIT�������� �ǵ���
    -- SAVEPOINT : ROLLBACK�� �ÿ� SAVEPOINT�� �����Ͽ� �� �κб��� Ʈ�������� ����� "ROLLBACK TO ���̺�����Ʈ��" ���·� ����


-- Cursor (�����Ϳ� ������)
-- ������ Ŀ��(Implicit cursor)
DECLARE
    v_emp_name emp.ename%TYPE;
    v_emp_hiredate emp.hiredate%TYPE;
BEGIN
    SELECT ename, hiredate INTO v_emp_name, v_emp_hiredate
        FROM emp WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(v_emp_name);
    DBMS_OUTPUT.PUT_LINE(v_emp_hiredate);
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT); -- ���� ���� ��� ������ ROW �� ��ȯ
    
    IF SQL%FOUND THEN -- ��ġ ROW�� 1�� �̻��̸� TRUE, �ƴϸ� FALSE
        DBMS_OUTPUT.PUT_LINE('��ġ ROW ���� 1�� �̻�');
    END IF;
    
    IF SQL%NOTFOUND THEN -- FOUND�� �ݴ�
        DBMS_OUTPUT.PUT_LINE('��ġ ROW ���� 0��');
    END IF;
    
    IF SQL%ISOPEN THEN --Ŀ���� ���� ������ TRUE, ���� ������ FALSE (������ Ŀ���� �׻� FALSE ��ȯ)
        DBMS_OUTPUT.PUT_LINE('Ŀ���� ����');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ŀ���� ����');
    END IF;
END;
/

-- ����� Ŀ��
DECLARE 
    v_emp_name emp.ename%TYPE;
    v_emp_hiredate emp.hiredate%TYPE;
    
    CURSOR cur_emp -- Ŀ�� ����
    IS
        SELECT ename, hiredate FROM emp
            WHERE empno between 7500 AND 8000;
BEGIN
    OPEN cur_emp(); -- Ŀ�� ����
    LOOP
        FETCH cur_emp INTO v_emp_name, v_emp_hiredate; -- ��ġ(������ Ÿ���� ��ġ���Ѿ� ��)
        EXIT WHEN cur_emp%NOTFOUND; -- ��ġ ���� ���� �� �ݺ��� ����
        DBMS_OUTPUT.PUT_LINE(v_emp_name || ' ' || v_emp_hiredate);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(cur_emp%ROWCOUNT);
    IF cur_emp%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Cursor is Opend');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cursor is Closed');
    END IF;
    
    CLOSE cur_emp; -- Ŀ�� �ݱ�
    
    IF cur_emp%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Cursor is Opend');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cursor is Closed');
    END IF;
END;
/

-- FOR ����
DECLARE
    CURSOR cur_emp
    IS
    SELECT * FROM emp WHERE empno BETWEEN 7700 AND 7900;
BEGIN
    FOR v_emp_rec IN cur_emp()  -- Ŀ�� ���� �� ��ġ (v_emp_rec�� ���� ����ü�� �����ϴ� ��ó�� ��� ����)
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_emp_rec.ename || ' ' || v_emp_rec.hiredate || ' ' || v_emp_rec.sal);
    END LOOP;
END;
/

-- Ŀ�� ����
-- TYPE dep_curtype IS REF CURSOR RETURN department%ROWTYPE; --���� Ÿ��
/* PL/SQL ���� */

-- ���� ����
--IS
--    DECLARE
--    BEGIN
--    EXCEPTION
--END;

-- PL/SQL �� ����� ���� ����
SET SERVEROUTPUT ON; 

DECLARE
    vs_emp_name emp.ename%TYPE; -- PL/SQL �� ����� ���� ����
BEGIN
    SELECT ename INTO vs_emp_name
        FROM emp WHERE empno = 7900;
    DBMS_OUTPUT.PUT_LINE('����� : ' || vs_emp_name);
END;
/

--�ݺ���
-- ������ ���� (LOOP)
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

-- ������ ���� (WHILE)
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

-- ������ ���� (FOR)
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


--���ǹ�
-- IF��
DECLARE
    vs_a NUMBER := 1;
    vs_b NUMBER := 2;
BEGIN
    IF vs_a = vs_b THEN SYS.DBMS_OUTPUT.PUT_LINE('a�� b�� �����ϴ�');
    ELSIF vs_a = 3 THEN SYS.DBMS_OUTPUT.PUT_LINE('a�� 3�Դϴ�');
    ELSE SYS.DBMS_OUTPUT.PUT_LINE('a�� 3�� �ƴմϴ�');
    END IF;
END;
/

-- CASE ��
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


-- �� ��
-- GOTO �ϰ����� ��ġ�Ƿ� ������ ��
DECLARE
  vs_gugu_line number := 0;
BEGIN
  FOR i IN 1..9
  LOOP
    DBMS_OUTPUT.PUT_LINE( i || '�� �Դϴ�.');
    IF i = 5 THEN 
        vs_gugu_line := i; 
        GOTO printing;
    -- ELSE NULL; �ƹ��͵� �������� ���� ��
    END IF;
    FOR j IN 1..9
    LOOP 
        DBMS_OUTPUT.PUT_LINE(i || ' * ' || j || ' = ' || (i * j));
        END LOOP;
  END LOOP;

  <<printing>>
  DBMS_OUTPUT.PUT_LINE('GOTO�� �̵��� ������ ' || vs_gugu_line || ' �Դϴ�');
  
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
    
    -- p_var1�� ���Ҵ��ڷ� ��� �Ұ�
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
    -- '=>'��� ��ȣ�� ���� �Ű����� ���� �� �ʱ�ȭ ����
    -- EXEC �Ǵ� EXCUTE ��ɾ ����Ͽ� ���ν����� �����Ѵ�.


-- EXCEPTION ó��
-- ����
-- EXCEPTION WHEN ���ܸ�1 THEN ����ó�� ����1
--      WHEN ���ܸ�2 THEN ����ó�� ����2
--   ..
--      WHEN OTHERS THEN ����ó�� ����n;
CREATE OR REPLACE PROCEDURE exception_test_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10/0;
    DBMS_OUTPUT.PUT_LINE('����!');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('���� �ڵ� : '|| SQLCODE);  -- ������ �ش��ϴ� �ڵ� ��ȯ
    DBMS_OUTPUT.PUT_LINE('���� �޼��� : '|| SQLERRM); -- ������ ���� �޼��� ��ȯ(�Ű������� �ָ� �ش� �ڵ��� ���� ������ ��ȯ)
    DBMS_OUTPUT.PUT_LINE('�� �����޽��� : ' || SYS.dbms_utility.format_call_stack);      -- �� ������ ��ȯ
    DBMS_OUTPUT.PUT_LINE('�� �����޽��� : ' || SYS.dbms_utility.format_error_stack);     -- ���� ���� ���� ��ȯ
    DBMS_OUTPUT.PUT_LINE('�� �����޽��� : ' || SYS.dbms_utility.format_error_backtrace); -- ���� ������ ��� ��ȯ
    DBMS_OUTPUT.PUT_LINE('���� �߻�!');
END;
/

BEGIN
    exception_test_proc();
    DBMS_OUTPUT.PUT_LINE('���� �߻� ������ ����.'); -- ����ó���� �� �� ���� ������ ���������� �۵��Ѵ�.
END;
/

-- ����� ���� ����
CREATE OR REPLACE PROCEDURE exception_test_proc2(vs_empno emp.empno%TYPE)
IS
    vn_cnt NUMBER := 0;
    ex_not_exist_phone EXCEPTION;
     PRAGMA EXCEPTION_INIT (ex_not_exist_phone, -1802); --�ý��� ���ܿ� ����� ���� ������ ����
BEGIN
    SELECT COUNT(*) INTO vn_cnt
        FROM emp WHERE vs_empno = empno;
    
    IF vn_cnt > 0 THEN
        DBMS_OUTPUT.PUT_LINE('��ϵ� �����ȣ�Դϴ�.');
    ELSE
        RAISE ex_not_exist_phone; -- RAISE : ���ܸ� ���������� �߻���Ŵ
        -- RAISE_APPLICATION_ERROR(-20200, '��ϵ� ��ȣ�� �����ϴ�. �����ڵ� 20200'); --���� �ڵ�� ���� �ޤ����� ���� ������ �� ����
    END IF;
    EXCEPTION
        WHEN ex_not_exist_phone THEN
            DBMS_OUTPUT.PUT_LINE('��ϵ��� ���� �����ȣ�Դϴ�.');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
EXEC exception_test_proc2(369);


--TRANSACTION
    -- COMMIT : �����ͺ��̽��� ������ ��Ȯ�ϰ� ����Ǿ� ���泻���� ���� �����ͺ��̽��� �ݿ�
    -- ROLLBACK : ���� ���� ������ �߻��Ͽ��� �� ������ COMMIT�������� �ǵ���
    -- SAVEPOINT : ROLLBACK�� �ÿ� SAVEPOINT�� �����Ͽ� �� �κб��� Ʈ�������� ����� "ROLLBACK TO ���̺�����Ʈ��" ���·� ����


-- Cursor (�����Ϳ� ������)
-- ������ Ŀ��(Implicit cursor)
DECLARE
    v_emp_name emp.ename%TYPE;
    v_emp_hiredate emp.hiredate%TYPE;
BEGIN
    SELECT ename, hiredate INTO v_emp_name, v_emp_hiredate
        FROM emp WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(v_emp_name);
    DBMS_OUTPUT.PUT_LINE(v_emp_hiredate);
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT); -- ���� ���� ��� ������ ROW �� ��ȯ
    
    IF SQL%FOUND THEN -- ��ġ ROW�� 1�� �̻��̸� TRUE, �ƴϸ� FALSE
        DBMS_OUTPUT.PUT_LINE('��ġ ROW ���� 1�� �̻�');
    END IF;
    
    IF SQL%NOTFOUND THEN -- FOUND�� �ݴ�
        DBMS_OUTPUT.PUT_LINE('��ġ ROW ���� 0��');
    END IF;
    
    IF SQL%ISOPEN THEN --Ŀ���� ���� ������ TRUE, ���� ������ FALSE (������ Ŀ���� �׻� FALSE ��ȯ)
        DBMS_OUTPUT.PUT_LINE('Ŀ���� ����');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ŀ���� ����');
    END IF;
END;
/

-- ����� Ŀ��
DECLARE 
    v_emp_name emp.ename%TYPE;
    v_emp_hiredate emp.hiredate%TYPE;
    
    CURSOR cur_emp -- Ŀ�� ����
    IS
        SELECT ename, hiredate FROM emp
            WHERE empno between 7500 AND 8000;
BEGIN
    OPEN cur_emp(); -- Ŀ�� ����
    LOOP
        FETCH cur_emp INTO v_emp_name, v_emp_hiredate; -- ��ġ(������ Ÿ���� ��ġ���Ѿ� ��)
        EXIT WHEN cur_emp%NOTFOUND; -- ��ġ ���� ���� �� �ݺ��� ����
        DBMS_OUTPUT.PUT_LINE(v_emp_name || ' ' || v_emp_hiredate);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(cur_emp%ROWCOUNT);
    IF cur_emp%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Cursor is Opend');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cursor is Closed');
    END IF;
    
    CLOSE cur_emp; -- Ŀ�� �ݱ�
    
    IF cur_emp%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Cursor is Opend');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cursor is Closed');
    END IF;
END;
/

-- FOR ����
DECLARE
    CURSOR cur_emp
    IS
    SELECT * FROM emp WHERE empno BETWEEN 7700 AND 7900;
BEGIN
    FOR v_emp_rec IN cur_emp()  -- Ŀ�� ���� �� ��ġ (v_emp_rec�� ���� ����ü�� �����ϴ� ��ó�� ��� ����)
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_emp_rec.ename || ' ' || v_emp_rec.hiredate || ' ' || v_emp_rec.sal);
    END LOOP;
END;
/

-- Ŀ�� ����
-- TYPE dep_curtype IS REF CURSOR RETURN department%ROWTYPE; -- ���� Ÿ��
-- TYPE dep_curtype IS REF CURSOR;                           -- ���� Ÿ��
-- SYS_REFCURSOR                                             -- ���� Ÿ��
-- OPEN ������ FOR select��
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

-- �������� Ŀ��
DECLARE
    CURSOR test_cur IS
        SELECT d.dname,
            CURSOR(SELECT e.ename
                FROM emp e
                WHERE e.deptno = d.deptno) AS emp_name
            FROM dept d
            WHERE d.deptno = 10;
    
    vs_dept_name dept.dname%TYPE; -- �μ� ����
    c_emp_name SYS_REFCURSOR; -- �̸��� ��� ����ϱ� ���� Ŀ�� ����
    vs_emp_name emp.ename%TYPE; -- �̸� ����

BEGIN
    OPEN test_cur;
        