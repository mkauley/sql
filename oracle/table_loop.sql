SET SERVEROUTPUT ON
 
DECLARE
  v_table  VARCHAR2(100);
  v_owner  VARCHAR2(100);
  v_column  VARCHAR2(100);
  v_data  VARCHAR2(500);
  v_col_list  VARCHAR2(4000);
  v_statement  VARCHAR2(4000);
  cur_rows  SYS_REFCURSOR;
 
CURSOR cur_table IS 
   SELECT owner, object_name
   FROM dba_objects
   WHERE owner NOT IN ('ANONYMOUS', 'APEX_PUBLIC_USER', 'APPQOSSYS', 'AUDSYS', 'CTXSYS', 'DBFUSER', 'DIP', 'DBSYS', 'DVF', 'FLOW_FILES', 'GGSYS', 'GSADMIN_INTERNAL', 'GSMCATUSER', 'GSMUSER', 'HR', 'LBACSyS', 'MDDATA', 'MDSYS', 'ORDPLUGINS', 'ORDSYS', 'ORDDATA', 'OUTLN', 'ORACLE_OCM', 'REMOTE_SCHEDULER_AGENT','SI_INFORMTN_SCHEMA','SPATIAL_CSW_ADMIN_USR','SYS','SYSTEM','SYSBACKUP','SYSKM','SYSDB','SYSRAC','SYS$UMF','WMSYS','XDB')
   AND owner NOT IN(SELECT owner FROM dba_objects WHERE oracle_maintained = 'Y' GROUP BY owner)
   AND object_Type = 'TABLE'
   AND owner = 'xxxxxxx'
 GROUP BY owner, object_name
 ORDER BY owner, object_name;
 
BEGIN
dbms_output.put_line('Set Heading Off');
OPEN cur_table;
   LOOP
   FETCH cur_table INTO v_owner, v_table;
   EXIT WHEN cur_table%NOTFOUND;
 
   v_col_list := '';
 
  OPEN cur_rows FOR SELECT column_name FROM dba_tab_cols WHERE owner = v_owner and table_name = v_table;
         LOOP
 
         FETCH cur_rows INTO v_column;
         EXIT WHEN cur_rows%NOTFOUND;
 
         if v_col_list IS NULL THEN
                 v_col_list := lower(v_column);
         ELSE
                v_col_list := v_col_list || ' || '',''|| ' || lower(v_column);
         END IF;
         END LOOP;
         CLOSE cur_rows;
   v_statement := 'SELECT '||v_col_list||' FROM ' || v_owner ||'.'||v_column||';''
   dbms_output.putline('spool ' || lower(v_table) || '.csv');
   dbms_output.putline(v_statement);
   dbms_output.putline('spool off');
   v_data := '';
   END LOOP;
CLOSE cur_table;
END;
/