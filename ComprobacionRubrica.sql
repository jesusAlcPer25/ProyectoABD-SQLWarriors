SET ECHO ON; -- Muestra la operacion ejecutada antes del resultado

-- ############################################################################################### --
-- #################################### PARTE OBLIGATORIA ######################################## --
-- ############################################################################################### --

----------------------------------------------------------------------------------------------------
----------------------------- 1. Esquema distinto para el trabajo ----------------------------------
----------------------------------------------------------------------------------------------------

-- Tablespaces TS_PLYTIX y TS_INDICES --

SELECT COUNT(*) FROM DBA_TABLESPACES WHERE TABLESPACE_NAME = 'TS_PLYTIX' OR TABLESPACE_NAME = 'TS_INDICES';
SELECT COUNT(*) FROM V$DATAFILE WHERE UPPER(NAME) LIKE '%PLYTIX%' OR UPPER(NAME) LIKE '%INDICES%';

-- ¿Qué pasaría si no asignaras el tablespace al crear las tablas o índices?
-- "Si no lo especifico, se crea en el tablespace por defecto del usuario. Esto puede provocar problemas de rendimiento o dificultad para gestionar almacenamiento, especialmente si se mezclan datos e índices."

-- Cómo comprobaste que los tablespaces TS_PLYTIX y TS_INDICES se crearon correctamente?
-- Respuesta: Usé la vista DBA_TABLESPACES para verificar su existencia, y V$DATAFILE para confirmar que los datafiles están correctamente asociados.

-- ¿Por qué separar índices y datos en distintos tablespaces?
-- Respuesta: Mejora el rendimiento y la gestión del almacenamiento.
----------------------------------------

-- 1.2. Comprobación índices
SELECT index_name, index_type, table_owner, table_name, uniqueness, tablespace_name 
FROM DBA_INDEXES 
WHERE TABLE_OWNER = 'PLYTIX';

-- ¿Un índice puede ralentizar el sistema?
-- "Sí. Aunque mejoran la lectura, pueden ralentizar las escrituras (INSERT, UPDATE, DELETE) porque deben mantenerse sincronizados."

-- ¿Cómo sabrías si un índice no está siendo utilizado por el optimizador?
-- "Usando el plan de ejecución (EXPLAIN PLAN o AUTOTRACE) puedo ver si se usa un índice o no."

-- ¿Qué tipo de índices hay y por qué se eligieron esos?
-- Respuesta: Pueden ser NORMAL, BITMAP, etc. La elección depende del tipo de consultas y volumen de datos.

-- ¿Dónde se almacenan los índices?
-- Respuesta: En el tablespace TS_INDICES, como se ve en la columna tablespace_name.
----------------------------------------

-- 1.3. Comprobación creación tablas e importacion
SELECT * FROM CUENTA;
SELECT * FROM PLAN;
SELECT * FROM USER_EXTERNAL_TABLES WHERE TABLE_NAME = PRODUCTOS_EXT;
SELECT * FROM PRODUCTOS_EXT;

-- ¿Qué pasa si el archivo de la tabla externa no existe o tiene un formato incorrecto?
-- "La tabla no da error al crearse, pero al hacer SELECT da un error de acceso a archivo o formato incorrecto."

-- ¿Puedes hacer un INSERT o DELETE sobre una tabla externa?
-- "No. Solo permiten lectura. Son de solo lectura, no se puede modificar su contenido desde SQL."

-- ¿Cómo comprobaste que la tabla externa PRODUCTOS_EXT está correctamente creada?
-- Respuesta: Usé la vista USER_EXTERNAL_TABLES. Además, probé con un SELECT para asegurarme de que puede leerse correctamente.
----------------------------------------

-- 1.4. Comprobación tabla TRAZA
SELECT * FROM TRAZA;
----------------------------------------

-- 2. Seguridad
-- 2.1. Cifrado de columnas
SELECT * FROM DBA_ENCRYPTED_COLUMNS;

-- 2.2 Política VPD
SELECT * FROM DBA_POLICIES WHERE OBJECT_OWNER = 'PLYTIX';   -- Muestra las políticas existentes

-- ¿Qué columnas están cifradas?
--Respuesta: Consultando DBA_ENCRYPTED_COLUMNS, se pueden ver todas las columnas cifradas.

--¿Qué es VPD y cómo lo aplicaste?
--Respuesta: VPD (Virtual Private Database) aplica políticas de seguridad a nivel de fila. Se verifica con DBA_POLICIES.
----------------------------------------

-- 3. Vistas
-- 3.1. Crear V_PRODUCTO_PUBLICO
SELECT * FROM V_PRODUCTO_PUBLICO;

-- 3.2. VM_PRODUCTOS
SELECT * FROM VM_PRODUCTOS;

--¿Qué datos se muestran en V_PRODUCTO_PUBLICO?
--Respuesta: Una vista que filtra atributos sensibles del producto para mostrar solo los públicos.

--¿Cuál es la diferencia entre una vista simple y una vista materializada como VM_PRODUCTOS?
--Respuesta: La materializada almacena físicamente los datos y puede ser actualizada periódicamente.

-- ¿Qué ventaja tiene usar una vista en lugar de consultar directamente la tabla?
-- "Puedo controlar qué datos expongo, simplificar consultas complejas y aplicar seguridad a nivel de columnas."

-- ¿Una vista siempre refleja los datos actualizados? ¿Y una materializada?
-- "Las vistas normales sí, siempre. Las materializadas solo después de refrescarse, por eso pueden estar desactualizadas."
----------------------------------------

-- 4. Permisos
-- 4.1. Gestión productos -> Usuario Estandar
-- 4.2. Gestion Productos, Activos y Categorias
-- 4.3. Gestion Atributos, Relación entre Productos
-- 4.4. Gestión de las cuentas
-- 4.5. Gestión de los planes

SELECT ROLE FROM DBA_ROLES WHERE ORACLE_MAINTAINED = 'N';   -- Muestra los roles creados por el usuario

-- ¿Cómo se aseguran de que cada usuario solo pueda hacer lo que debe?
-- Respuesta: Se crean roles con permisos específicos y se asignan según el perfil del usuario.

-- ¿Cómo se consulta qué privilegios tiene un usuario?
-- Respuesta: Con DBA_TAB_PRIVS, DBA_SYS_PRIVS y DBA_ROLE_PRIVS.

-- ¿Qué diferencia hay entre un permiso de sistema y uno de objeto?
-- "Permisos de sistema permiten realizar operaciones generales (CREATE TABLE, CREATE USER). Los de objeto son sobre objetos concretos (SELECT ON tabla1)."

-- ¿Puede un usuario sin permiso directo acceder a una tabla si tiene el rol que sí lo tiene?
-- "Depende. Si el rol no está marcado como DEFAULT, no se activa automáticamente. También puede depender del tipo de ejecución: directa vs. dentro de procedimientos."
----------------------------------------

-- 5. Paquetes PL/SQL

-- Especificación
SELECT text
FROM dba_source
WHERE name = 'PKG_ADMIN_PRODUCTOS'
  AND type = 'PACKAGE'
ORDER BY line;

-- Cuerpo
SELECT text
FROM dba_source
WHERE name = 'PKG_ADMIN_PRODUCTOS'
  AND type = 'PACKAGE BODY'
ORDER BY line;

-- ¿Qué diferencia hay entre la especificación y el cuerpo del paquete?
-- Respuesta: La especificación declara las funciones y procedimientos disponibles, el cuerpo los implementa.

-- ¿Por qué usar paquetes?
-- Respuesta: Por organización, encapsulamiento, reutilización de código y mejora de rendimiento.

-- ¿Puede una función PL/SQL devolver un tipo BOOLEAN y usarse directamente en SQL?
-- "No. BOOLEAN no es un tipo SQL válido. Si quiero usar el resultado en SQL, tengo que devolver un tipo como VARCHAR2 o NUMBER."

-- ¿Qué pasa si olvidas capturar una excepción personalizada en un procedimiento?
-- "Se propaga al bloque superior. Si no hay manejo ahí tampoco, la sesión lanza error y se cancela la operación."
----------------------------------------


-- 6. PKG_ADMIN_PRODUCTOS --

SET SERVEROUTPUT ON;

-- 6.1. F_OBTENER_PLAN_CUENTA
DECLARE
  v_plan PLAN%ROWTYPE;
BEGIN
  v_plan := PKG_ADMIN_PRODUCTOS.F_OBTENER_PLAN_CUENTA(1);
  DBMS_OUTPUT.PUT_LINE('Plan ID: ' || v_plan.ID || ', Nombre: ' || v_plan.NOMBRE);
EXCEPTION
  WHEN PKG_ADMIN_PRODUCTOS.EXCEPTION_PLAN_NO_ASIGNADO THEN
    DBMS_OUTPUT.PUT_LINE('Error: Plan no asignado a la cuenta.');
END;
/
-- 6.2. F_CONTAR_PRODUCTOS_CUENTA
DECLARE
  v_total NUMBER;
BEGIN
  v_total := PKG_ADMIN_PRODUCTOS.F_CONTAR_PRODUCTOS_CUENTA(1);
  DBMS_OUTPUT.PUT_LINE('Total de productos: ' || v_total);
END;
/
-- 6.3. F_VALIDAR_ATRIBUTOS_PRODUCTO
DECLARE
  v_valido BOOLEAN;
BEGIN
  v_valido := PKG_ADMIN_PRODUCTOS.F_VALIDAR_ATRIBUTOS_PRODUCTO('1234567890123', 1);
  IF v_valido THEN
    DBMS_OUTPUT.PUT_LINE('Producto válido.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Producto inválido.');
  END IF;
EXCEPTION
  WHEN PKG_ADMIN_PRODUCTOS.INVALID_DATA THEN
    DBMS_OUTPUT.PUT_LINE('Error: Datos inválidos.');
END;
/

-- ERROR --
/*
Informe de error -
ORA-06503: PL/SQL: La función no ha devuelto ningún valor
ORA-06512: en "PLYTIX.PKG_ADMIN_PRODUCTOS", línea 131
ORA-06512: en línea 4
06503. 00000 -  "PL/SQL: Function returned without value"
*Cause:    A call to PL/SQL function completed, but no RETURN statement was
           executed.
*Action:   Rewrite PL/SQL function, making sure that it always returns
           a value of a proper type.

-- 6.4. F_NUM_CATEGORIAS_CUENTA
DECLARE
  v_categorias NUMBER;
BEGIN
  v_categorias := PKG_ADMIN_PRODUCTOS.F_NUM_CATEGORIAS_CUENTA(1);
  DBMS_OUTPUT.PUT_LINE('Número de categorías: ' || v_categorias);
END;
/
*/
----------------------------------------

-- 7. Triggers
SELECT * FROM user_triggers;                         -- Muestras los triggers existentes

SELECT trigger_body FROM user_triggers;               -- Muestra el código del trigger

-- ¿Qué triggers hay y qué hacen?
-- Respuesta: Consulta user_triggers para identificarlos. Ej.: podrían actualizar la tabla TRAZA con auditoría.

-- ¿Cuándo se ejecutan?
-- Respuesta: Dependiendo de si son BEFORE, AFTER o INSTEAD OF.

-- ¿Puede un trigger realizar un COMMIT?
-- "No. No se permite hacer COMMIT dentro de un trigger. Da error ORA-04092."

-- ¿Qué problemas puede causar un trigger mal diseñado?
-- "Puede crear recursividad infinita, afectar el rendimiento o introducir errores de lógica difíciles de depurar."
----------------------------------------

----------------------------------------------------------------------------------------------------
-------------------------------------- 8. Transacciones --------------------------------------------
----------------------------------------------------------------------------------------------------

SELECT * FROM DBA_SOURCE
WHERE NAME = 'PKG_ADMIN_PRODUCTOS_AVANZADO' AND TYPE = 'PACKAGE BODY';

-- Y buscar las lineas que pone COMMIT para demostrarlo.
-- Expoliacion para el profesor:
  -- Control de los COMMIT y ROLLBACK en los procedimientos y funciones para
  -- mantener las transacciones

-- ¿Qué ventaja tiene controlar los COMMIT desde los procedimientos?
-- "Permite asegurar la atomicidad. Si algo falla, puedo hacer rollback de todo en vez de dejar cambios parciales."

-- ¿Qué pasa si se lanza una excepción y no hago rollback?
-- "Depende de si hubo un commit antes. Si no, los cambios quedan pendientes y se pueden deshacer."

-- ¿Dónde se usan COMMIT o ROLLBACK?
-- Respuesta: En los procedimientos del paquete PKG_ADMIN_PRODUCTOS_AVANZADO. Se busca en el PACKAGE BODY.

-- ¿Por qué es importante el control de transacciones?
-- Respuesta: Para asegurar la atomicidad y consistencia de los datos.
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-------------------------------------- 9. Excepciones ----------------------------------------------
----------------------------------------------------------------------------------------------------

SELECT * FROM DBA_SOURCE
WHERE NAME = 'PKG_ADMIN_PRODUCTOS' AND TYPE = 'PACKAGE BODY';

-- O --

SELECT * FROM DBA_SOURCE
WHERE NAME = 'PKG_ADMIN_PRODUCTOS_AVANZADO' AND TYPE = 'PACKAGE BODY';

-- Y buscar la parte de excepciones, lo mejor es buscar el primer procedimiento que es que el usan
-- todas las funciones y procedimientos

-- ¿Qué excepciones personalizadas existen?
-- Respuesta: Ej.: EXCEPTION_PLAN_NO_ASIGNADO, EXCEPTION_ASOCIACION_DUPLICADA. Se definen en el paquete.

-- ¿Cómo se gestionan las excepciones?
-- Respuesta: Mediante bloques EXCEPTION WHEN ... THEN.
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
---------------------------------- 10. Creación de datos coherentes --------------------------------
----------------------------------------------------------------------------------------------------

-- P_ACTUALIZAR_NOMBRE_PRODUCTO --

BEGIN
  PKG_ADMIN_PRODUCTOS.P_ACTUALIZAR_NOMBRE_PRODUCTO('1234567890123', 1, 'Nuevo Nombre');
  DBMS_OUTPUT.PUT_LINE('Nombre del producto actualizado.');
END;
/

----------------------------------

-- P_ASOCIAR_ACTIVO_A_PRODUCTO --

BEGIN
  PKG_ADMIN_PRODUCTOS.P_ASOCIAR_ACTIVO_A_PRODUCTO('1234567890123', 1, 10, 1);
  DBMS_OUTPUT.PUT_LINE('Activo asociado al producto.');
EXCEPTION
  WHEN PKG_ADMIN_PRODUCTOS.EXCEPTION_ASOCIACION_DUPLICADA THEN
    DBMS_OUTPUT.PUT_LINE('Error: Asociación duplicada.');
END;
/

----------------------------------

-- P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES --

BEGIN
  PKG_ADMIN_PRODUCTOS.P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES('1234567890123', 1);
  DBMS_OUTPUT.PUT_LINE('Producto y asociaciones eliminados.');
END;
/

-----------------------------------------

-- P_CREAR_USUARIO --

DECLARE
  v_usuario USUARIO%ROWTYPE;
BEGIN
  v_usuario.ID := 504;
  v_usuario.NOMBRECOMPLETO := 'Antonio';
  v_usuario.NOMBREUSUARIO := 'Antonio';
  v_usuario.CUENTA_ID := 1;
  -- Asigna otros campos según la estructura de la tabla USUARIO

  PKG_ADMIN_PRODUCTOS.P_CREAR_USUARIO(v_usuario, 'ROL_USUARIO_ESTANDAR', 'password123');
  DBMS_OUTPUT.PUT_LINE('Usuario creado.');
EXCEPTION
  WHEN PKG_ADMIN_PRODUCTOS.EXCEPTION_USUARIO_EXISTE THEN
    DBMS_OUTPUT.PUT_LINE('Error: El usuario ya existe.');
END;
/

--------------------

-- P_ACTUALIZAR_PRODUCTOS -- La politica viola la opcion de comprobacion

BEGIN
  PKG_ADMIN_PRODUCTOS.P_ACTUALIZAR_PRODUCTOS(1);
  DBMS_OUTPUT.PUT_LINE('Productos actualizados.');
END;
/

----------------------------


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
------------------------------------------- 11. Seguridad ------------------------------------------
----------------------------------------------------------------------------------------------------

-- Asignación de roles a usuarios --

SELECT * 
FROM DBA_ROLE_PRIVS 
WHERE GRANTEE IN (
  SELECT username FROM dba_users
  WHERE account_status = 'OPEN'
  AND UPPER(USERNAME) NOT LIKE '%SYS%'
  AND UPPER(USERNAME) NOT LIKE '%SYSTEM%'
  AND UPPER(USERNAME) NOT LIKE '%PLYTIX%'
);

------------------------------------

-- Asiganción de permisos de forma restrictiva a todos los usuarios --

-- Privilegios sobre objetos especificos
SELECT * 
FROM DBA_TAB_PRIVS 
WHERE GRANTEE IN (
  SELECT username FROM dba_users
  WHERE account_status = 'OPEN'
);

-- Privilegios sobre el sistema
SELECT * 
FROM DBA_SYS_PRIVS 
WHERE GRANTEE IN (
  SELECT username FROM dba_users
  WHERE account_status = 'OPEN'
);

----------------------------------------------------------------------

-- Operaciones a realizar por los usuarios --

-- Seria mirar los roles y permisos de cada usuario y deducir que operaciones puede realizar

---------------------------------------------

-- Política de gestión de contraseñas --

SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE PROFILE LIKE '%ESTANDAR%';

----------------------------------------

-- Activación de TDE y encriptación de columnas --

SELECT * FROM V$ENCRYPTION_WALLET;

--------------------------------------------------

-- ¿Cómo controlan las contraseñas?
-- Respuesta: Con perfiles (DBA_PROFILES) y políticas de contraseñas seguras.

-- ¿Está activado el TDE (Transparent Data Encryption)?
-- Respuesta: Se comprueba con V$ENCRYPTION_WALLET.
----------------------------------------------------------------------------------------------------

-- ############################################################################################### --


-- ############################################################################################### --
-- ################################### PARTE OPCIONAL ############################################ --
-- ############################################################################################### --

----------------------------------------------------------------------------------------------------
---------------------------------- 1. PKG_ADMIN_PRODUCTOS_AVANZADO ---------------------------------
----------------------------------------------------------------------------------------------------

-- En general con las funciones y los procedimientos hay un problema interno con las politicas que hacen que las funciones no se puedan probar
-- y no funcionen. La solucion no la hemos podido sacar pero sabemos que puede estar ahi el error.

-- F_VALIDAR_PLAN_SUFICIENTE -- El error esta en la funcion, llama a otra funcion del otro paquete y hay algu problema con las politicas interno
                             -- que no se que solucion puede tener

DECLARE
  v_resultado VARCHAR2(100);
BEGIN
  v_resultado := PKG_ADMIN_PRODUCTOS_AVANZADO.F_VALIDAR_PLAN_SUFICIENTE(1);
  DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/

------------------------------------

-- F_LISTA_CATEGORIAS_PRODUCTO -- Tampoco devuelve el tipo correctop

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

--------------------------------------

-- P_MIGRAR_PRODUCTOS_A_CATEGORIA -- ALgo falla pero no se el que

BEGIN
  PKG_ADMIN_PRODUCTOS_AVANZADO.P_MIGRAR_PRODUCTOS_A_CATEGORIA(1, 10, 10);
  DBMS_OUTPUT.PUT_LINE('Migración completada.');
END;
/

-- Comprobacion --
SELECT gtin, categoria_id FROM producto WHERE cuenta_id = 1;

------------------------------------

-- P_REPLICAR_ATRIBUTOS -- Algova mal tambien

BEGIN
  PKG_ADMIN_PRODUCTOS_AVANZADO.P_REPLICAR_ATRIBUTOS(
    p_origen_gtin => '1234567890123',
    p_destino_gtin => '9876543210987',
    p_cuenta_id => 1
  );
  DBMS_OUTPUT.PUT_LINE('Atributos replicados.');
END;
/

-- Comprobacion --
SELECT * FROM atributo_producto WHERE gtin = '9876543210987';  

-- F_VALIDAR_PLAN_SUFICIENTE devuelve VARCHAR2 en vez de BOOLEAN.
-- Respuesta: En Oracle no se puede usar BOOLEAN como tipo de retorno en funciones públicas PL/SQL desde SQL. Debe devolver 'S'/'N', o 1/0.

-- F_LISTA_CATEGORIAS_PRODUCTO usa REF CURSOR
-- Pregunta: ¿Cómo se recorre un cursor en PL/SQL?
-- Respuesta: Mediante un LOOP con FETCH ... INTO ... y luego CLOSE.
-------------------------------

----------------------------------------------------------------------------------------------------
---------------------------------------------- 2. Jobs ---------------------------------------------
----------------------------------------------------------------------------------------------------

SELECT *
FROM dba_scheduler_jobs
WHERE OWNER = 'PLYTIX';

-- Ver el estado del job
SELECT object_name, status
FROM user_objects
WHERE object_type = 'PROCEDURE' AND object_name = 'P_LIMPIA_TRAZA';

-- J_LIMPIA_TRAZA --

BEGIN
  DBMS_SCHEDULER.RUN_JOB('J_LIMPIA_TRAZA');
  DBMS_OUTPUT.PUT_LINE('Job J_LIMPIA_TRAZA ejecutado manualmente.');
END;
/

-- Comprobación --
SELECT COUNT(*) FROM trazas;

--------------------

-- J_ACTUALIZA_PRODUCTOS --

BEGIN
  DBMS_SCHEDULER.RUN_JOB('J_ACTUALIZA_PRODUCTOS');
  DBMS_OUTPUT.PUT_LINE('Job J_ACTUALIZA_PRODUCTOS ejecutado manualmente.');
END;
/

-- ERROR --
/*
Informe de error -
ORA-01031: privilegios insuficientes
ORA-06512: en "SYS.DBMS_SESSION", línea 141
ORA-06512: en línea 2
01031. 00000 -  "insufficient privileges"
*Cause:    An attempt was made to perform a database operation without
           the necessary privileges.
*Action:   Ask your database administrator or designated security
           administrator to grant you the necessary privileges
*/

-- Comprobación --
SELECT * FROM producto
WHERE fecha_actualizacion >= SYSDATE - 1/24;

---------------------------

-- ¿Por qué se produce el error ORA-01031 al ejecutar J_ACTUALIZA_PRODUCTOS?
-- Faltan privilegios. El usuario no tiene permiso para ejecutar el procedimiento o acceder a ciertos objetos.

-- ¿Por qué se filtran los objetos con BIN$%?
-- Porque son objetos borrados (papelera de reciclaje de Oracle).

-- ¿Cómo comprobar que J_LIMPIA_TRAZA se ejecutó bien?
-- Verificando que la tabla trazas tenga menos registros.

-- ¿Cómo automatizar J_LIMPIA_TRAZA?
-- Programándolo con DBMS_SCHEDULER usando repeat_interval.

-- ¿Se puede ejecutar un JOB aunque el procedimiento asociado esté en estado INVALID?
-- No, fallará la ejecución del job.

-- ¿Por qué se ejecuta J_LIMPIA_TRAZA manualmente si debería estar programado?
-- Probablemente para pruebas, pero en producción debería tener repeat_interval.
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
----------------------------------- 3. Correctitud del modelo E/R ----------------------------------
----------------------------------------------------------------------------------------------------

-- Restricciones de tipo CHECK --

SELECT table_name, constraint_name, search_condition
FROM user_constraints
WHERE constraint_type = 'C';                                     

---------------------------------

-- Creación de restricciones NOT NULL / UNIQUE --

-- Restriccion NOT NULL
SELECT table_name, column_name
FROM user_tab_columns
WHERE nullable = 'N';

-- Restriccion UNIQUE
SELECT table_name, constraint_name
FROM user_constraints
WHERE constraint_type = 'U';

-------------------------------------------------

-- Diferencias entre CHECK, NOT NULL y UNIQUE
-- CHECK: regla personalizada. NOT NULL: sin nulos. UNIQUE: sin duplicados.

-- ¿Qué pasa si producto.cuenta_id no tiene integridad referencial?
-- Puede haber datos huérfanos sin relación válida.

-- ¿Una restricción NOT NULL garantiza que no habrá duplicados?
-- No, solo garantiza que no habrá nulos.

-- ¿Una CHECK puede reemplazar una clave foránea?
-- No, no valida integridad referencial entre tablas.
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--------------------------------------------- 4. Auditoría  ----------------------------------------
----------------------------------------------------------------------------------------------------

-- Creación de trigger de auditoría o configuración de AUDIT --

SHOW PARAMETER audit_trail;

-- Comprobacion --
-- Si sale DB es porque la auditoria esta , y si que sale

SELECT * 
FROM dba_stmt_audit_opts 
WHERE user_name = 'PLYTIX' OR user_name IS NULL;

-- Comprobacion --
-- Con la consulta anterior deberian de oberservarse los atributos que son auditados

---------------------------------------------------------------

-- ¿Qué significa audit_trail = DB?
-- Que la auditoría está activa y guarda en base de datos.

-- ¿Por qué user_name IS NULL en la auditoría?
-- Para aplicar auditoría a todos los usuarios.

-- Si audit_trail está en DB, ¿se audita todo automáticamente?
-- No, solo lo configurado explícitamente con AUDIT.

-- ¿Aparecerán logs de auditoría si nadie accede al sistema?
-- No, solo se genera auditoría si hay actividad.
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--------------------------------------------- 5. Miscelanea  ---------------------------------------
----------------------------------------------------------------------------------------------------

-- 1. Comprobar si hay datos suficientes para integridad referencial
    DECLARE
    v_count NUMBER;
    v_passed_count NUMBER := 0; -- Inicializa si es necesario

    BEGIN
        -- Verificar que hay datos en tablas relacionadas
        SELECT COUNT(*) INTO v_count FROM producto WHERE cuenta_id IN (SELECT id FROM cuenta);
        
        IF v_count > 0 THEN
            v_passed_count := v_passed_count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('No hay datos suficientes para comprobar integridad');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al verificar: ' || SQLERRM);
    END;

    -- 2. Comprobar mayúsculas/minúsculas en objetos
    BEGIN
        SELECT COUNT(*) INTO v_count FROM user_objects 
        WHERE object_type IN ('PROCEDURE','FUNCTION','PACKAGE','TRIGGER') 
        AND REGEXP_LIKE(object_name, '^[A-Z]');
        
        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Todos los objetos tienen nombres en minúsculas');
            v_passed_count := v_passed_count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Hay ' || v_count || ' objetos con mayúsculas');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al verificar: ' || SQLERRM);
    END;

    -- 3. Comprobar elementos adicionales
    BEGIN
        v_count := 0;
        
        -- Verificar triggers adicionales
        SELECT COUNT(*) INTO v_count FROM user_triggers 
        WHERE trigger_name NOT LIKE 'BIN$%'  -- Excluir objetos en papelera
        AND trigger_name NOT IN (SELECT trigger_name FROM user_triggers WHERE base_object_type = 'TABLE');
        
        -- Verificar vistas adicionales
        SELECT COUNT(*) + v_count INTO v_count FROM user_views 
        WHERE view_name NOT LIKE 'BIN$%';
        
        -- Verificar jobs adicionales
        SELECT COUNT(*) + v_count INTO v_count FROM user_scheduler_jobs;
        
        IF v_count >= 2 THEN  -- Considerando que al menos 2 elementos adicionales son requeridos
            DBMS_OUTPUT.PUT_LINE('Existen ' || v_count || ' elementos adicionales (triggers, vistas, jobs)');
            v_passed_count := v_passed_count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Solo hay ' || v_count || ' elementos adicionales');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al verificar: ' || SQLERRM);
    END;
END;
/

------------------------------------

-- ¿Para qué sirve v_passed_count?
-- Cuenta cuántas validaciones pasaron.

-- ¿Por qué importa el uso de mayúsculas en nombres de objetos?
-- Puede causar inconsistencias o errores en entornos sensibles al caso.

-- ¿v_passed_count sirve para mostrar errores?
-- No, solo cuenta aciertos (checks pasados).

-- ¿Si un objeto tiene mayúsculas, está mal hecho?
-- No necesariamente, pero no sigue la convención del sistema.
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
--------------------------------------------- 6. Contexto  ---------------------------------------
----------------------------------------------------------------------------------------------------

-- Uso de contexto para distinción de usuario activo y permisos

-- Establecer Contexto -> Investigar sobre contexto
CREATE CONTEXT PLYTIX_CONTEXT USING PLYTIX.PKG_CONTEXT; 
    -- Util para poder probar un usuario como admin, usaremos para suplantar identidad de un usuario
-- ALTER SESSION SET CONTEXT ...;
SYS_CONTEXT('userenv','SESSION_USER');
    -- Añadir contextos para pruebas pero poner control

-- ¿Para qué sirve PLYTIX_CONTEXT?
-- Para gestionar usuarios simulados en la sesión.

-- ¿Por qué es útil en pruebas de seguridad?
-- Permite simular accesos sin cambiar de usuario.

-- ¿Se puede usar un contexto sin paquete asociado (USING)?
-- No, Oracle lo requiere para gestionarlo.

-- ¿Puede un usuario cambiar el SYS_CONTEXT de otro?
-- No, solo puede acceder al suyo.
----------------------------------------------------------------------------------------------------

-- ############################################################################################### --
