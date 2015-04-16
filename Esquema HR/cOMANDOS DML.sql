/*CREAR TABLAS DE PROVEEDOR, PRODUCTO, FACTURA, CLIENTE */
CREATE SEQUENCE SQ_PROVEEDOR
  MINVALUE 1
  MAXVALUE 99999999999
  START WITH 1
  INCREMENT BY 1
  CACHE 20;
----------
DROP SEQUENCE SQ_PROVEEDOR ;
CREATE sequence SQ_PROVEEDOR;
----------
select SQ_PROVEEDOR.nextval from dual;
select SQ_PROVEEDOR.currval from dual;
alter sequence SQ_PROVEEDOR increment by -11;
select SQ_PROVEEDOR.nextval from dual;
alter sequence SQ_PROVEEDOR increment by 1;
alter sequence  SQ_PROVEEDO increment by 1 minvalue 0;
------
create or replace procedure SQ_PROVEEDOR_RESET( SQ_PRO in varchar2 ) is
PRO_VAL number;
begin
        execute immediate
        'select ' || SQ_PRO || '.nextval from dual' INTO PRO_VAL;
        execute immediate
        'alter sequence ' || SQ_PRO || ' increment by -' || PRO_VAL || ' minvalue 0';
        execute immediate
        'select ' || SQ_PRO || '.nextval from dual' INTO PRO_VAL;
        execute immediate
        'alter sequence ' || SQ_PRO || ' increment by 1 minvalue 0';

end;
--------------------llamar para resetear la secuencia------------------------------
begin  
  SQ_PROVEEDOR_RESET('SQ_PROVEEDOR');
end;
--------------------------------------------TABLA PROVEEDOR---------------------------------------------
CREATE TABLE IROUTE.TB_PROVEEDOR(
ID_PROVEEDOR NUMBER PRIMARY KEY  NOT NULL ,
PRO_NOMBRE VARCHAR2(20) NOT NULL,
PRO_APELLIDO VARCHAR2(20) NOT NULL,
PRO_DIRECCION VARCHAR2(50) NOT NULL,
PRO_TELEFONO VARCHAR2 (10) NOT NULL,
PRO_CORREO VARCHAR2(30) NOT NULL,
PRO_PAGINA_WEB VARCHAR2(50) default 'NO DISPONIBLE'
);
-------------------------------------------------INSERCIONES----------------------------------------------------
truncate table IROUTE.TB_PROVEEDOR;
INSERT INTO IROUTE.TB_PROVEEDOR  (ID_PROVEEDOR, PRO_NOMBRE, PRO_APELLIDO,PRO_DIRECCION, PRO_TELEFONO,PRO_CORREO,PRO_PAGINA_WEB) 
VALUES (SQ_PROVEEDOR.NEXTVAL,'XAVIER','TIPANGUANO','DURAN','0940587637','THEXAVI313@HOTMAIL.COM','WWW.FARRUKO.COM');
-------------------------------------------------
INSERT INTO IROUTE.TB_PROVEEDOR
VALUES (SQ_PROVEEDOR.NEXTVAL,'JOSE','PEREZ','GUAYAQUIL','0940587','JOSE@HOTMAIL.COM','WWW.PEREZ.COM');
COMMIT;
-------------------------------------------------
SELECT * FROM TB_PROVEEDOR;
--------------------------------------TABLA PRODUCTO--------------------------------------------------
CREATE TABLE IROUTE.TB_PRODUCTO(
ID_PROUCTO NUMBER PRIMARY KEY NOT NULL,
ID_PROVEEDOR NUMBER NOT NULL,
PR_NOMBRE VARCHAR2(20) NOT NULL,
PR_DESCRIPCION VARCHAR2(30),
PR_PRECIO_UNITARIO NUMBER(5,2),
PR_DISPONIBLE VARCHAR2(2)
);
SELECT * FROM TB_PRODUCTO;
-----------------------------------------TABLA FACTURA-------------------------------------------------
CREATE TABLE SYSTEM.TB_FACTURA(
ID_FACTURA NUMBER PRIMARY KEY NOT NULL,
ID_PRODUCTO NUMBER NOT NULL,
ID_CLIENTE NUMBER NOT NULL,
FACT_FECHA_PEDIDO DATE,
FACT_FECHA_ENVIO  DATE,
FACT_CANTIDAD NUMBER default 0 
);

CREATE TABLE SYSTEM.TB_CLIENTES(

);


SELECT SYSDATE FROM DUAL;
