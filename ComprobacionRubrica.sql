SET ECHO ON; -- Muestra la operacion ejecutada antes del resultado

-- 1. Comprobación Tablespaces
SELECT COUNT(*) FROM DBA_TABLESPACES WHERE TABLESPACE_NAME = 'TS_PLYTIX' OR TABLESPACE_NAME = 'TS_INDICES';

SELECT * FROM DBA_TABLESPACES WHERE TABLESPACE_NAME = 'TS_PLYTIX';
SELECT * FROM DBA_TABLESPACES WHERE TABLESPACE_NAME = 'TS_INDICES';

SELECT owner, segment_name, segment_type, tablespace_name
FROM dba_segments
WHERE tablespace_name IN ('TS_PLYTIX', 'TS_INDICES');

-- 1.1. Comprobación índices

SELECT index_name, index_type, table_owner, table_name, uniqueness, tablespace_name FROM USER_INDEXES;

-- 1.2. Comprobación creación tablas
SELECT * FROM CUENTA;
SELECT * FROM PLAN;
SELECT * FROM USUARIO;          -- Eliminar la VPD y comprobar funcionamiento
SELECT * FROM PRODUCTO;
SELECT * FROM PRODUCTOS_EXT;

-- 1.3. Comprobación tabla TRAZA

-- Crear tabla TRAZA y hacer seguimiento errores


-- 2. Seguridad

--  Crear tablas con columnas encriptadas -> TDE

-- 2.2 VPD Function

SELECT * FROM DBA_POLICIES WHERE OBJECT_OWNER = 'PLYTIX';   -- Muestra las políticas existentes


-- 3. Vistas

-- 3.1. Crear V_PRODUCTO_PUBLICO

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

-- 6.1. F_OBTENER_PLAN_CUENTA
-- 6.2. F_CONTAR_PRODUCTOS_CUENTA
-- 6.3. F_VALIDAR_ATRIBUTOS_PRODUCTO
/* F_NUM_CATEGORIAS_CUENTA
P_ACTUALIZAR_NOMBRE_PRODUCTO
P_ASOCIAR_ACTIVO_A_PRODUCTO
P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES
P_CREAR_USUARIO
P_ACTUALIZAR_PRODUCTOS */






-- 7. Triggers





-- 8. Transacciones




-- 9. Excepciones




-- 10. Creación de datos coherentes



-- 11. Seguridad

























SELECT COUNT(*) FROM V$DATAFILE WHERE UPPER(NAME) LIKE '%PLYTIX%';
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