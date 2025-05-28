SET ECHO ON; -- Muestra la operacion ejecutada antes del resultado

------------------------------------------ PARTE OBLIGATORIA -----------------------------------------------

-- 1. Esquema distinto para el trabajo

-- 1.1. Tablespaces TS_PLYTIX y TS_INDICES
SELECT COUNT(*) FROM DBA_TABLESPACES WHERE TABLESPACE_NAME = 'TS_PLYTIX' OR TABLESPACE_NAME = 'TS_INDICES';
SELECT COUNT(*) FROM V$DATAFILE WHERE UPPER(NAME) LIKE '%PLYTIX%' OR UPPER(NAME) LIKE '%INDICES%';

-- 1.2. Comprobación índices
SELECT index_name, index_type, table_owner, table_name, uniqueness, tablespace_name 
FROM DBA_INDEXES 
WHERE TABLE_OWNER = 'PLYTIX';

-- 1.3. Comprobación creación tablas e importacion
SELECT * FROM CUENTA;
SELECT * FROM PLAN;
SELECT * FROM USUARIO;
SELECT * FROM PRODUCTO;
SELECT * FROM PRODUCTOS_EXT;

-- 1.4. Comprobación tabla TRAZA
SELECT * FROM TRAZA;


-- 2. Seguridad
-- 2.1. Cifrado de columnas
SELECT * FROM V$DBA_ENCRYPTED_COLUMNS;

-- 2.2 Política VPD
SELECT * FROM DBA_POLICIES WHERE OBJECT_OWNER = 'PLYTIX';   -- Muestra las políticas existentes


-- 3. Vistas
-- 3.1. Crear V_PRODUCTO_PUBLICO
SELECT * FROM V_PRODUCTO_PUBLICO;

-- 3.2. VM_PRODUCTOS
SELECT * FROM VM_PRODUCTOS;


-- 4. Permisos
-- 4.1. Gestión productos -> Usuario Estandar

-- 4.2. Gestion Productos, Activos y Categorias

-- 4.3. Gestion Atributos, Relación entre Productos

-- 4.4. Gestión de las cuentas

-- 4.5. Gestión de los planes


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


-- 6. Procedimientos

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
-- 6.4. F_NUM_CATEGORIAS_CUENTA
DECLARE
  v_categorias NUMBER;
BEGIN
  v_categorias := PKG_ADMIN_PRODUCTOS.F_NUM_CATEGORIAS_CUENTA(1);
  DBMS_OUTPUT.PUT_LINE('Número de categorías: ' || v_categorias);
END;
/
-- 6.5. P_ACTUALIZAR_NOMBRE_PRODUCTO
BEGIN
  PKG_ADMIN_PRODUCTOS.P_ACTUALIZAR_NOMBRE_PRODUCTO('1234567890123', 1, 'Nuevo Nombre');
  DBMS_OUTPUT.PUT_LINE('Nombre del producto actualizado.');
END;
/
-- 6.6. P_ASOCIAR_ACTIVO_A_PRODUCTO
BEGIN
  PKG_ADMIN_PRODUCTOS.P_ASOCIAR_ACTIVO_A_PRODUCTO('1234567890123', 1, 10, 1);
  DBMS_OUTPUT.PUT_LINE('Activo asociado al producto.');
EXCEPTION
  WHEN PKG_ADMIN_PRODUCTOS.EXCEPTION_ASOCIACION_DUPLICADA THEN
    DBMS_OUTPUT.PUT_LINE('Error: Asociación duplicada.');
END;
/
-- 6.7. P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES
BEGIN
  PKG_ADMIN_PRODUCTOS.P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES('1234567890123', 1);
  DBMS_OUTPUT.PUT_LINE('Producto y asociaciones eliminados.');
END;
/
-- 6.8. P_CREAR_USUARIO
DECLARE
  v_usuario USUARIO%ROWTYPE;
BEGIN
  v_usuario.ID := 100;
  v_usuario.NOMBRE := 'Juan Pérez';
  v_usuario.EMAIL := 'juan.perez@example.com';
  -- Asigna otros campos según la estructura de la tabla USUARIO

  PKG_ADMIN_PRODUCTOS.P_CREAR_USUARIO(v_usuario, 'ADMIN', 'password123');
  DBMS_OUTPUT.PUT_LINE('Usuario creado.');
EXCEPTION
  WHEN PKG_ADMIN_PRODUCTOS.EXCEPTION_USUARIO_EXISTE THEN
    DBMS_OUTPUT.PUT_LINE('Error: El usuario ya existe.');
END;
/
-- 6.9. P_ACTUALIZAR_PRODUCTOS
BEGIN
  PKG_ADMIN_PRODUCTOS.P_ACTUALIZAR_PRODUCTOS(1);
  DBMS_OUTPUT.PUT_LINE('Productos actualizados.');
END;
/


-- 7. Triggers
SELECT trigger_name, table_name, triggering_event, trigger_type, status
FROM user_triggers;                         -- Muestras los triggers existentes

SELECT trigger_body
FROM user_triggers
WHERE trigger_name = 'TR_PRODUCTOS';        -- Muestra el código del trigger


-- 8. Transacciones

-- Control de los COMMIT y ROLLBACK en los procedimientos y funciones para mantener las transacciones
-- Añadir COMMIT y ROLLBACK en los procedimientos


-- 9. Excepciones
-- Mostrar en el codigo del paquete PL/SQL


-- 10. Creación de datos coherentes
-- Ejecución de tests con datos coherentes para comprobar el buen funcionamiento del paquete
-- Verificar que los cambios se reflejan en la BD
-- Intentar hacer una tabla-resumen 


-- 11. Seguridad

-- 11.1. Creación de roles adecuados
SELECT *
FROM dba_roles
WHERE oracle_maintained = 'N'
ORDER BY role;

-- 11.2. Asignación de roles a usuarios

-- 11.3. Asiganción de permisos de forma restrictiva a todos los usuarios

-- 11.4. Operaciones a realizar por los usuarios

-- 11.5. Política de gestión de contraseñas

-- 11.6. Activación de TDE y encriptación de columnas
SELECT * FROM V$DBA_ENCRYPTED_COLUMNS;



------------------------------------------ PARTE OPCIONAL -----------------------------------------------

-- 1. Paquetes
-- 1.1. PKG_ADMIN_PRODUCTOS_AVANZADO
-- 1.2. F_VALIDAR_PLAN_SUFICIENTE
DECLARE
  v_resultado BOOLEAN;
BEGIN
  v_resultado := PKG_ADMIN_PRODUCTOS_AVANZADO.F_VALIDAR_PLAN_SUFICIENTE(1); -- ID de cuenta de ejemplo

  IF v_resultado THEN
    DBMS_OUTPUT.PUT_LINE('El plan es suficiente.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('El plan NO es suficiente.');
  END IF;
END;
/
-- 1.3. F_LISTA_CATEGORIAS_PRODUCTO
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
-- 1.4. P_MIGRAR_PRODUCTOS_A_CATEGORIA
BEGIN
  PKG_ADMIN_PRODUCTOS_AVANZADO.P_MIGRAR_PRODUCTOS_A_CATEGORIA(
    p_cuenta_id => 1,
    p_categoria_destino => 10  -- ID de categoría destino
  );
  DBMS_OUTPUT.PUT_LINE('Migración completada.');
END;
/
SELECT gtin, categoria_id FROM producto WHERE cuenta_id = 1;        -- Comprobación
-- 1.5. P_REPLICAR_ATRIBUTOS
BEGIN
  PKG_ADMIN_PRODUCTOS_AVANZADO.P_REPLICAR_ATRIBUTOS(
    p_origen_gtin => '1234567890123',
    p_destino_gtin => '9876543210987',
    p_cuenta_id => 1
  );
  DBMS_OUTPUT.PUT_LINE('Atributos replicados.');
END;
/
SELECT * FROM atributo_producto WHERE gtin = '9876543210987';       -- Comprobación 


-- 2. Jobs
SELECT job_name, enabled, state, last_start_date, next_run_date
FROM dba_scheduler_jobs
WHERE job_name IN ('J_LIMPIA_TRAZA', 'J_ACTUALIZA_PRODUCTOS');

-- 2.1. J_LIMPIA_TRAZA
BEGIN
  DBMS_SCHEDULER.RUN_JOB('J_LIMPIA_TRAZA');
  DBMS_OUTPUT.PUT_LINE('Job J_LIMPIA_TRAZA ejecutado manualmente.');
END;
/

SELECT COUNT(*) FROM trazas;                                        -- Comprobación
-- 2.2. J_ACTUALIZA_PRODUCTOS
BEGIN
  DBMS_SCHEDULER.RUN_JOB('J_ACTUALIZA_PRODUCTOS');
  DBMS_OUTPUT.PUT_LINE('Job J_ACTUALIZA_PRODUCTOS ejecutado manualmente.');
END;
/

SELECT * FROM producto
WHERE fecha_actualizacion >= SYSDATE - 1/24;                        -- Comprobación productos ultima hora


-- 3. Correctitud del modelo E/R
SELECT table_name, constraint_name, search_condition
FROM user_constraints
WHERE constraint_type = 'C';                                        -- Comprobación restricciones

-- 3.1. Comprobación de restricciones semánticas, rangos, números no negativos...

-- 3.2. Creación de restricciones NOT NULL / UNIQUE


-- 4. Auditoría 

-- Creación de trigger de auditoría o configuración de AUDIT


-- 5. Miscelanea

-- 5.1. Inserciñon suficiente de datos para comprobar la integridad referencial 

-- 5.2. Tratado de mayúsculas y minúsculas en triggers, índices, etc

-- 5.3. Introducción de objetos extras


-- 7. Contexto

-- 7.1. Uso de contexto para distinción de usuario activo y permisos

-- Establecer Contexto -> Investigar sobre contexto
CREATE CONTEXT PLYTIX_CONTEXT USING PLYTIX.PKG_CONTEXT; 
    -- Util para poder probar un usuario como admin, usaremos para suplantar identidad de un usuario
-- ALTER SESSION SET CONTEXT ...;
SYS_CONTEXT('userenv','SESSION_USER');
    -- Añadir contextos para pruebas pero poner control






----------------------------------------------------------------------------------------------------------


SELECT COUNT(*) FROM DBA_ENCRYPTED_COLUMNS;
SELECT COUNT(*) FROM DBA_INDEXES WHERE OWNER = 'PLYTIX' AND TABLESPACE_NAME = 'TS_PLYTIX';
SELECT COUNT(*) FROM DBA_INDEXES WHERE OWNER = 'PLYTIX' AND TABLESPACE_NAME = 'TS_PLYTIX';

-- Para ejecutar procedimientos -> Proceso comprobación Creacion de usuario
DECLARE
    V_EXISTE_USUARIO NUMBER;
    V_EXISTE_USER NUMBER;
BEGIN
    PLYTIX.CREA_USUARIO('PEPE','PEPE123');
    SELECT COUNT(*) IN V_EXISTE_USUARIO FROM USUARIOS WHERE NOMBRE = 'PEPE';
    IF V_EXISTE_USUARIO == 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'No existe usuario');
    END IF;
    SELECT COUNT(*) INTO V_EXISTE_USER FROM ALL_USERS WHERE UPPER(NAME) = 'PEPE';
    IF V_EXISTE_USER == 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'No existe usuario');
    END IF;

    -- Añadir destrucción de usuario
    -- Automatización de pruebas

END;
/

-- Establecer Contexto -> Investigar sobre contexto
CREATE CONTEXT PLYTIX_CONTEXT USING PLYTIX.PKG_CONTEXT; 
    -- Util para poder probar un usuario como admin, usaremos para suplantar identidad de un usuario
-- ALTER SESSION SET CONTEXT ...;
SYS_CONTEXT('userenv','SESSION_USER');
    -- Añadir contextos para pruebas pero poner control