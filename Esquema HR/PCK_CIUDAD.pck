create or replace package PCK_CIUDAD is

PROCEDURE PR_PRINCIPAL( PV_MENSAJE_ERROR out VARCHAR2);
PROCEDURE pr_insertar_ciudad( pn_id_ciudad  number, pn_id_region  number, pv_nombre  varchar2, pv_estado  varchar2,
                             pd_fecha_ingreso  date, PV_MENSAJE_ERROR out VARCHAR2);
                             
PROCEDURE PR_ELIMINAR_CIUDAD(pn_id_ciudad	number,pn_id_region	number,pv_nombre	varchar2, pv_estado  varchar2,
                  pd_fecha_ingreso	date, PV_MENSAJE_ERROR out  VARCHAR2);
                  
PROCEDURE PR_ACTUALIZAR_CIUDAD(pn_id_ciudad	number,pn_id_region	number,pv_nombre	varchar2, pv_estado  varchar2,
                  pd_fecha_ingreso	date, PV_MENSAJE_ERROR  out VARCHAR2);
end PCK_CIUDAD;
/
create or replace package body PCK_CIUDAD is
/*PROCEDIMIENTO PRINCIPAL*/
PROCEDURE PR_PRINCIPAL( PV_MENSAJE_ERROR  out VARCHAR2)IS
  TYPE L_VARIABLES IS RECORD (
    COD_CIUDAD V_CIUDAD.ID_CIUDAD%TYPE,
    COD_REGION V_CIUDAD.ID_REGION%TYPE,
    CI_NOMBRE V_CIUDAD.NOMBRE%TYPE,
    CI_ESTADO V_CIUDAD.ESTADO%TYPE,
    CI_F_INGRESO V_CIUDAD.FECHA_INGRESO%TYPE
  );
  TYPE VAR_PARAMETROS IS TABLE OF L_VARIABLES;
  LV_VIDEO_DATOS VAR_PARAMETROS;
  lv_mensaje_error varchar2(20);
  LV_NOMBRE_PROCESO VARCHAR2(30);
  LV_MENSAJE_ERRORes varchar2(2000);
  contar number;
  le_exception exception;
 BEGIN
   LV_NOMBRE_PROCESO:='PCK_CIUDAD.PR_PRINCIPAL';
   
   select count(id_ciudad)into contar  from v_ciudad_v1;
   if contar is   null then       
       SELECT C.ID_CIUDAD, C.ID_REGION, C.NOMBRE, C.ESTADO, C.FECHA_INGRESO
       BULK COLLECT INTO LV_VIDEO_DATOS
       FROM V_CIUDAD C;
       FOR i IN LV_VIDEO_DATOS.FIRST ..  LV_VIDEO_DATOS.LAST LOOP 
       pr_insertar_ciudad( pn_id_ciudad =>LV_VIDEO_DATOS(i).COD_CIUDAD,
                    pn_id_region =>LV_VIDEO_DATOS(i).COD_REGION,
                    pv_nombre =>   LV_VIDEO_DATOS(i).CI_NOMBRE,
                    pv_estado =>   LV_VIDEO_DATOS(i).CI_ESTADO,
                    pd_fecha_ingreso => LV_VIDEO_DATOS(i).CI_F_INGRESO,
                    pv_mensaje_error =>LV_MENSAJE_ERRORes );
       END LOOP; 
       --dbms_output.put_line('dato insertado..');
       if LV_MENSAJE_ERRORes is not null then 
        raise le_exception;
       end if;
   else 
       SELECT C.ID_CIUDAD, C.ID_REGION, C.NOMBRE, C.ESTADO, C.FECHA_INGRESO
       BULK COLLECT INTO LV_VIDEO_DATOS
       FROM V_CIUDAD C;
       FOR i IN LV_VIDEO_DATOS.FIRST ..  LV_VIDEO_DATOS.LAST LOOP 
       pck_ciudad.pr_eliminar_ciudad(pn_id_ciudad => LV_VIDEO_DATOS(i).COD_CIUDAD,
                                     pn_id_region => LV_VIDEO_DATOS(i).COD_REGION,
                                     pv_nombre => LV_VIDEO_DATOS(i).CI_NOMBRE,
                                     pv_estado => LV_VIDEO_DATOS(i).CI_ESTADO,
                                     pd_fecha_ingreso => LV_VIDEO_DATOS(i).CI_F_INGRESO,
                                     pv_mensaje_error => LV_MENSAJE_ERRORes);
       end loop;
      -- dbms_output.put_line('dato eliminado..');
        if LV_MENSAJE_ERRORes is not null then 
          raise le_exception;
        end if;
    end if;
 EXCEPTION
    when le_exception then 
   PV_MENSAJE_ERROR:='error: '||LV_MENSAJE_ERRORes;
    WHEN OTHERS THEN
       PV_MENSAJE_ERROR:='error en el proceso: '||LV_NOMBRE_PROCESO||substr(sqlerrm,1,500);
END PR_PRINCIPAL;
/*FIN DEL PROCEDIMIENTO PRINCIPAL*/
------/*insertar registro*/
PROCEDURE pr_insertar_ciudad(
                  pn_id_ciudad	number,
                  pn_id_region	number,
                  pv_nombre	varchar2,
                  pv_estado  varchar2,
                  pd_fecha_ingreso	date, 
                  PV_MENSAJE_ERROR out VARCHAR2
      ) IS
      sql_query VARCHAR2(1000);
      lv_mensaje_error varchar2(2000);
      lv_nombre_proceso varchar2(50);
      lv_error_mensajes exception;
      BEGIN
        lv_nombre_proceso:= 'PCK_CIUDAD.pr_insertar_ciudad';
        sql_query := 'INSERT INTO V_CIUDAD_V1 (id_ciudad, id_region, nombre, estado, fecha_ingreso)
                      VALUES(:pn_id_ciudad,:pn_id_region,:pv_nombre,:pv_estado,:pd_fecha_ingreso )';
        execute immediate sql_query using pn_id_ciudad, pn_id_region, pv_nombre, pv_estado, pd_fecha_ingreso;
        commit;
      exception
       when others then
        PV_MENSAJE_ERROR:= 'Existio un error en el proceso: '||lv_nombre_proceso||substr(sqlerrm,9,500); 
END pr_insertar_ciudad;
---------/*eliminar registro*/
PROCEDURE PR_ELIMINAR_CIUDAD(pn_id_ciudad	number,pn_id_region	number,pv_nombre	varchar2, pv_estado  varchar2,
                  pd_fecha_ingreso	date, PV_MENSAJE_ERROR out  VARCHAR2) IS
      sql_str VARCHAR2(1000);
      lv_mensaje_error varchar2(2000);
      lv_nombre_proceso varchar2(50);
      lv_error_mensaje exception;
      BEGIN
        lv_nombre_proceso:= 'PCK_CIUDAD.PR_ELIMINAR_CIUDAD';
        sql_str := 'delete v_ciudad_v1 where id_ciudad  =:pn_id_ciudad and id_region=:pn_id_region   ';
        execute immediate sql_str using pn_id_ciudad, pn_id_region ;
        COMMIT;
      exception
        when others then
          PV_MENSAJE_ERROR:= 'Existio un error en el proceso: '||lv_nombre_proceso||substr(sqlerrm,9,500); 
          rollback;
END PR_ELIMINAR_CIUDAD;
---------/*actualizar registro*/
PROCEDURE PR_ACTUALIZAR_CIUDAD(pn_id_ciudad	number,pn_id_region	number,pv_nombre	varchar2, pv_estado  varchar2,
                  pd_fecha_ingreso	date, PV_MENSAJE_ERROR out VARCHAR2) IS
      sql_str2 VARCHAR2(1000);
      lv_mensaje_error varchar2(2000);
      lv_nombre_proceso varchar2(50);
      lv_error_mensaje exception;
      BEGIN
        lv_nombre_proceso:= 'PCK_CIUDAD.PR_ACTUALIZAR_REGISTRO';
        sql_str2 :='update v_ciudad_v1  
                    set id_region = :pn_id_region,
                        nombre = :pv_nombre,
                        estado = :pv_estado,
                        fecha_ingreso = :pd_fecha_ingreso
                    where id_ciudad = :pn_id_ciudad ' ;
        execute immediate sql_str2 using  pn_id_region, pv_nombre, pv_estado,pd_fecha_ingreso,pn_id_ciudad;
        COMMIT;
      exception
        when others then
          PV_MENSAJE_ERROR:= 'Existio un error en el proceso: '||lv_nombre_proceso||' '||substr(sqlerrm,1,500); 
          rollback;
END PR_ACTUALIZAR_CIUDAD;
---------/*fin actualizar registro*/
end PCK_CIUDAD;
/
