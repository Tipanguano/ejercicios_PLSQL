CREATE OR REPLACE PROCEDURE INSERTAR_PROVEEDOR
(--VARIABLES
  COD_PRO VARCHAR2(20),PRO_NOM IN VARCHAR2(20), PRO_APE IN VARCHAR2(20), PRO_DIR IN VARCHAR2(20), PRO_TEL IN VARCHAR2(10), 
  PRO_CORR IN VARCHAR2(30),PRO_PAG_W IN VARCHAR2(50)
)
 
DECLARE
(COD_PRO IN VARCHAR) IS  PRO_I NUMBER
set PRO_I SELECT SQ_PROVEEDOR.nextval FROM DUAL
BEGIN
  INSERT INTO SYSTEM.TB_PROVEEDOR 
  VALUES (PRO_I,PRO_NOM,PRO_APE,PRO_DIR,PRO_TEL,PRO_CORR,PRO_PAG_W );
  COMMIT;
END SYSTEM.TB_PROVEEDOR;
-------------------------INSERCIONES------------------
BEGIN 
 INSERTAR_PROVEEDOR(0,'MARIA','GOMEZ','CENTRO DE LA CIUDAD','0987542132','MARIA@HOTMAIL.COM','WWW.GOMEZ_M.COM');
END;
select SQ_PROVEEDOR.nextval from dual;

CREATE OR REPLACE PROCEDURE PR
DECLARE
(COD_PRO IN VARCHAR) IS  PRO_I NUMBER
set PRO_I = (SELECT SQ_PROVEEDOR.nextval FROM DUAL)
BEGIN
 DBMS_OUTPUT.put_line('NUM ' ||PRO_I)
 END;
 
 
 DECLARE
   CURSOR COD_PRO IS 
   SELECT SQ_PROVEEDOR.nextval FROM DUAL;
  
BEGIN
  DBMS_OUTPUT.put_line ('EL PROMEDIO DE LOS ESTUDIANTES ES: ' ||COD_PRO);
END;