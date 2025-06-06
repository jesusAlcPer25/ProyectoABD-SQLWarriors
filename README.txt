INDICE DE ARCHIVOS:

- NivelFisico1: Son archivos hechos conforme se planteó en las practicas de grupo.
- NivelFisico2: Son archivos hechos conforme se planteó en las practicas de grupo.
- PLSQL1: Aqui se desarrolla el paquete PKG_ADMIN_PRODUCTOS.
- PLSQL2: Aqui se desarrolla el paquete PKG_ADMIN_PRODUCTOS_AVANZADO, y al final deL script estan los JOBS.
- Seguridad: En este archivo creamos los roles asignándoles los permisos necesarios a cada uno y tambien creamos las políticas VPD (politicas de seguridad). También se crea el contexto, un perfil para el usuario estándar y la auditoria.
- Miscelánea: Se encarga de cubrir el punto de miscelánea de la rúbrica.
- CreacionBD_estructura: Se crean los Tablespaces, el usuario plytix, todas las tablas, indices, el cifrado de columnas, la tabla externa, las vistas y los triggers.
- InsertarDatosBD: Es la copia de la exportación de los datos de la base de datos.
- ReinicioBD: Es un archivo que sirve para eliminar toda la base de datos para empezar de cero.

Enlace a github: https://github.com/jesusAlcPer25/ProyectoABD-SQLWarriors

INFORME DE ERRORES:

-- En general, con las funciones y los procedimientos hay un problema interno con las políticas que hacen que las funciones no se puedan probar
-- y no funcionen. La solución no la hemos podido encontrar, pero sabemos que puede estar ahí el error.

-- F_VALIDAR_PLAN_SUFICIENTE -- El error está en la función. Llama a otra función de otro paquete y hay algún problema con las políticas internas
-- y hemos intentado buscar una solución pero no hemos encontrado ninguna.

DECLARE
  v_resultado VARCHAR2(100);
BEGIN
  v_resultado := PKG_ADMIN_PRODUCTOS_AVANZADO.F_VALIDAR_PLAN_SUFICIENTE(1);
  DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/

-- F_LISTA_CATEGORIAS_PRODUCTO -- Comprobando nos dimos cuenta que la función no devolvía el tipo correcto.

DECLARE
  v_categorias SYS_REFCURSOR;
  v_nombre_categoria VARCHAR2(100);
BEGIN
  v_categorias := PKG_ADMIN_PRODUCTOS_AVANZADO.F_LISTA_CATEGORIAS_PRODUCTO('1234567890123', 1);

  LOOP
    FETCH v_categorias INTO v_nombre_categoria;
    EXIT WHEN v_categorias%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Categoría: ' || v_nombre_categoria);
  END LOOP;

  CLOSE v_categorias;
END;
/
-- P_MIGRAR_PRODUCTOS_A_CATEGORIA -- Hemos estado probando pero no encontramos el error.

BEGIN
  PKG_ADMIN_PRODUCTOS_AVANZADO.P_MIGRAR_PRODUCTOS_A_CATEGORIA(1, 10, 10);
  DBMS_OUTPUT.PUT_LINE('Migración completada.');
END;
/
-- P_REPLICAR_ATRIBUTOS -- No logramos solucionar el error

BEGIN
  PKG_ADMIN_PRODUCTOS_AVANZADO.P_REPLICAR_ATRIBUTOS(
    p_origen_gtin => '1234567890123',
    p_destino_gtin => '9876543210987',
    p_cuenta_id => 1
  );
  DBMS_OUTPUT.PUT_LINE('Atributos replicados.');
END;
/
-- J_ACTUALIZA_PRODUCTOS --

BEGIN
  DBMS_SCHEDULER.RUN_JOB('J_ACTUALIZA_PRODUCTOS');
  DBMS_OUTPUT.PUT_LINE('Job J_ACTUALIZA_PRODUCTOS ejecutado manualmente.');
END;
/
-- ERROR --

Informe de error -
ORA-01031: privilegios insuficientes
ORA-06512: en "SYS.DBMS_SESSION", línea 141
ORA-06512: en línea 2
01031. 00000 -  "insufficient privileges"
*Cause:    An attempt was made to perform a database operation without
           the necessary privileges.
*Action:   Ask your database administrator or designated security
           administrator to grant you the necessary privileges