-- Crear roles según los perfiles especificados
CREATE ROLE ROL_ADMINISTRADOR_SISTEMA IDENTIFIED BY admin;
CREATE ROLE ROL_USUARIO_ESTANDAR;
CREATE ROLE ROL_GESTOR_CUENTAS;
CREATE ROLE ROL_PLANIFICADOR_SERVICIOS;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ADMINISTRADOR DEL SISTEMA
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE USER ADMIN IDENTIFIED BY admin
    DEFAULT TABLESPACE TS_PLYTIX
    QUOTA UNLIMITED ON TS_PLYTIX
    QUOTA UNLIMITED ON TS_INDICES
    ACCOUNT LOCK
;
GRANT DBA TO ADMIN;

GRANT ADMINISTER KEY MANAGEMENT TO ROL_ADMINISTRADOR_SISTEMA;                       -- Gestión TDE, solo un usuario
GRANT ALTER SYSTEM TO ROL_ADMINISTRADOR_SISTEMA;
-- GRANT EXECUTE ON DBMS_RLS TO ROL_ADMINISTRADOR_SISTEMA;                             -- Gestión VPD
GRANT ALTER USER TO ROL_ADMINISTRADOR_SISTEMA;                                      -- Gestión de usuarios
GRANT EXECUTE ON PKG_ADMIN_PRODUCTOS.P_CREA_USUARIO TO ROL_ADMINISTRADOR_SISTEMA;   -- Crea usario
GRANT EXECUTE ON PKG_ADMIN_PRODUCTOS.P_BORRAR_USUARIO TO ROL_ADMINISTRADOR_SISTEMA; -- Eliminar usuario
GRANT GRANT ANY ROLE TO ROL_ADMINISTRADOR_SISTEMA;

GRANT ALL ON activo_categoria_act TO ROL_ADMINISTRADOR_SISTEMA;                     -- Gestion de tablas
GRANT ALL ON activo TO ROL_ADMINISTRADOR_SISTEMA;    
GRANT ALL ON atributo TO ROL_ADMINISTRADOR_SISTEMA;    
GRANT ALL ON atributo_producto TO ROL_ADMINISTRADOR_SISTEMA;    
GRANT ALL ON categoria TO ROL_ADMINISTRADOR_SISTEMA;    
GRANT ALL ON categoria_activo TO ROL_ADMINISTRADOR_SISTEMA;    
GRANT ALL ON categoria_producto TO ROL_ADMINISTRADOR_SISTEMA;    
GRANT ALL ON cuenta TO ROL_ADMINISTRADOR_SISTEMA;    
GRANT ALL ON plan TO ROL_ADMINISTRADOR_SISTEMA;    
GRANT ALL ON producto_activo TO ROL_ADMINISTRADOR_SISTEMA;    
GRANT ALL ON producto TO ROL_ADMINISTRADOR_SISTEMA;
GRANT ALL ON productos_ext TO ROL_ADMINISTRADOR_SISTEMA;
GRANT ALL ON usuario TO ROL_ADMINISTRADOR_SISTEMA;    
GRANT ALL ON relacionado TO ROL_ADMINISTRADOR_SISTEMA;
GRANT ALL ON traza TO ROL_ADMINISTRADOR_SISTEMA;

GRANT RESOURCE, CONNECT TO ROL_ADMINISTRADOR_SISTEMA;                               -- Gestión conexión y recursos
GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE TO ROL_ADMINISTRADOR_SISTEMA;

-- Seguridad: El Administrador tiene TDE y VPD (esto debe implementarse por DBA, ejemplo teórico):
CREATE OR REPLACE FUNCTION F_VERIFY_PASSWORD (
   username      VARCHAR2,
   password      VARCHAR2,
   old_password  VARCHAR2
) RETURN BOOLEAN IS
   v_min_length          CONSTANT INTEGER := 8;
   v_common_passwords    SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('password', '123456', '123456789', 'qwerty', 'abc123', 'admin');
BEGIN
    -- Validación de longitud mínima
    IF LENGTH(password) < v_min_length THEN
        RAISE_APPLICATION_ERROR(-20001, 'La contraseña debe tener al menos ' || v_min_length || ' caracteres.');
    END IF;

    -- No debe contener el nombre de usuario (insensible a mayúsculas/minúsculas)
    IF INSTR(LOWER(password), LOWER(username)) > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'La contraseña no debe contener el nombre de usuario.');
    END IF;

    -- Debe tener al menos una letra minúscula
    IF NOT REGEXP_LIKE(password, '[a-z]') THEN
        RAISE_APPLICATION_ERROR(-20003, 'La contraseña debe contener al menos una letra minúscula.');
    END IF;

    -- Debe tener al menos una letra mayúscula
    IF NOT REGEXP_LIKE(password, '[A-Z]') THEN
        RAISE_APPLICATION_ERROR(-20004, 'La contraseña debe contener al menos una letra mayúscula.');
    END IF;

    -- Debe tener al menos un número
    IF NOT REGEXP_LIKE(password, '[0-9]') THEN
        RAISE_APPLICATION_ERROR(-20005, 'La contraseña debe contener al menos un número.');
    END IF;

    -- Debe tener al menos un carácter especial
    IF NOT REGEXP_LIKE(password, '[!@#$%^&*()_+=\-{}\[\]:;"''<>,.?/\\|]') THEN
        RAISE_APPLICATION_ERROR(-20006, 'La contraseña debe contener al menos un carácter especial.');
    END IF;

    -- No debe estar en la lista de contraseñas comunes
    FOR i IN 1 .. v_common_passwords.COUNT LOOP
        IF LOWER(password) = LOWER(v_common_passwords(i)) THEN
            RAISE_APPLICATION_ERROR(-20007, 'La contraseña es demasiado común. Elija una más segura.');
        END IF;
    END LOOP;

    RETURN TRUE;
END;
/

CREATE OR REPLACE PUBLIC SYNONYM F_VERIFY_PASSWORD FOR PLYTIX.F_VERIFY_PASSWORD;
GRANT EXECUTE ON PLYTIX.F_VERIFY_PASSWORD TO PUBLIC;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--  CONTEXTO 

CREATE CONTEXT CTX_USUARIO USING PKG_CONTEXT;

CREATE OR REPLACE PACKAGE PKG_CONTEXT IS
  PROCEDURE set_cuenta_id;
END;
/

CREATE OR REPLACE PACKAGE BODY PKG_CONTEXT IS
  
  PROCEDURE set_cuenta_id IS
        v_cuenta_id NUMBER;
    BEGIN
        SELECT cuenta_id INTO v_cuenta_id
        FROM usuario
        WHERE nombreusuario = SYS_CONTEXT('USERENV', 'SESSION_USER');

        DBMS_SESSION.set_context('CTX_USUARIO', 'CUENTA_ID', v_cuenta_id);
    END;
END;
/

CREATE OR REPLACE TRIGGER TR_SET_CONTEXT
    AFTER LOGON ON DATABASE
    BEGIN
        PKG_CONTEXT.set_cuenta_id;
    END;
/

SELECT SYS_CONTEXT('CTX_USUARIO', 'CUENTA_ID') FROM DUAL; -- Comprobación


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- USUARIO ESTÁNDAR
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GRANT RESOURCE, CONNECT TO ROL_USUARIO_ESTANDAR;

-- Permiso para ver/modificar su propia info (asumiendo columna usuario_id o similar)
GRANT SELECT, UPDATE ON USUARIO TO ROL_USUARIO_ESTANDAR;
GRANT SELECT ON plan TO ROL_USUARIO_ESTANDAR;

-- Permisos sobre PRODUCTO
CREATE OR REPLACE FUNCTION F_USUARIO_PRODUCTO (
    schema_name IN VARCHAR2,
    object_name IN VARCHAR2
) RETURN VARCHAR2
IS
BEGIN
    RETURN 'cuenta_id = SYS_CONTEXT(''CTX_USUARIO'', ''CUENTA_ID'')';
END;
/
BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'PLYTIX',
    object_name     => 'PRODUCTO',
    policy_name     => 'POL_SEGURIDAD_PRODUCTO',
    function_schema => 'PLYTIX',
    policy_function => 'F_USUARIO_PRODUCTO',
    statement_types => 'SELECT, INSERT, UPDATE, DELETE',
    update_check    => TRUE
  );
END;
/

GRANT SELECT, INSERT, UPDATE, DELETE ON PRODUCTO TO ROL_USUARIO_ESTANDAR;

-- Vista de productos públicos
GRANT SELECT, UPDATE (PUBLICO) ON V_PRODUCTO_PUBLICO TO ROL_USUARIO_ESTANDAR;

-- Permisos sobre ACTIVO y relación Categorías
CREATE OR REPLACE FUNCTION F_USUARIO_ACTIVO (
    schema_name IN VARCHAR2,
    object_name IN VARCHAR2
) RETURN VARCHAR2
IS
BEGIN
    RETURN 'cuenta_id = SYS_CONTEXT(''CTX_USUARIO'', ''CUENTA_ID'')';
END;
/
BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'PLYTIX',
    object_name     => 'ACTIVO',
    policy_name     => 'POL_SEGURIDAD_ACTIVO',
    function_schema => 'PLYTIX',
    policy_function => 'F_USUARIO_ACTIVO',
    statement_types => 'SELECT, INSERT, UPDATE, DELETE',
    update_check    => TRUE
  );
END;
/

CREATE OR REPLACE FUNCTION F_USUARIO_CAT_ACTIVO (
    schema_name IN VARCHAR2,
    object_name IN VARCHAR2
) RETURN VARCHAR2
IS
BEGIN
    RETURN 'ACTIVO_CUENTA_ID = SYS_CONTEXT(''CTX_USUARIO'', ''CUENTA_ID'')';
END;
/

BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'PLYTIX',
    object_name     => 'CATEGORIA_ACTIVO',
    policy_name     => 'POL_SEGURIDAD_CAT_ACTIVO',
    function_schema => 'PLYTIX',
    policy_function => 'F_USUARIO_CAT_ACTIVO',
    statement_types => 'SELECT, INSERT, UPDATE, DELETE',
    update_check    => TRUE
  );
END;
/

GRANT SELECT, INSERT, UPDATE, DELETE ON ACTIVO TO ROL_USUARIO_ESTANDAR;
GRANT SELECT, INSERT, UPDATE, DELETE ON CATEGORIA_ACTIVO TO ROL_USUARIO_ESTANDAR;

-- Permisos sobre CATEGORÍA Y relación con producto
CREATE OR REPLACE FUNCTION F_USUARIO_CATEGORIA (
    schema_name IN VARCHAR2,
    object_name IN VARCHAR2
) RETURN VARCHAR2
IS
BEGIN
    RETURN 'CUENTA_ID = SYS_CONTEXT(''CTX_USUARIO'', ''CUENTA_ID'')';
END;
/

BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'PLYTIX',
    object_name     => 'CATEGORIA',
    policy_name     => 'POL_SEGURIDAD_CATEGORIA',
    function_schema => 'PLYTIX',
    policy_function => 'F_USUARIO_CATEGORIA',
    statement_types => 'SELECT, INSERT, UPDATE, DELETE',
    update_check    => TRUE
  );
END;
/

CREATE OR REPLACE FUNCTION F_USUARIO_CATEGORIA_PRODUCTO (
    schema_name IN VARCHAR2,
    object_name IN VARCHAR2
) RETURN VARCHAR2
IS
BEGIN
    RETURN 'PRODUCTO_CUENTA_ID = SYS_CONTEXT(''CTX_USUARIO'', ''CUENTA_ID'') AND 
            CATEGORIA_CUENTA_ID = SYS_CONTEXT(''CTX_USUARIO'', ''CUENTA_ID'')';
END;
/

BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'PLYTIX',
    object_name     => 'CATEGORIA_PRODUCTO',
    policy_name     => 'POL_SEGURIDAD_CAT_PROD',
    function_schema => 'PLYTIX',
    policy_function => 'F_USUARIO_CATEGORIA_PRODUCTO',
    statement_types => 'SELECT, INSERT, UPDATE, DELETE',
    update_check    => TRUE
  );
END;
/

GRANT SELECT, INSERT, UPDATE, DELETE ON CATEGORIA TO ROL_USUARIO_ESTANDAR;
GRANT SELECT, INSERT, UPDATE, DELETE ON categoria_producto TO ROL_USUARIO_ESTANDAR;

-- Permisos sobre RELACIONADO
CREATE OR REPLACE FUNCTION F_USUARIO_RELACIONADO (
    schema_name IN VARCHAR2,
    object_name IN VARCHAR2
) RETURN VARCHAR2
IS
BEGIN
    RETURN 'CUENTA_ID = SYS_CONTEXT(''CTX_USUARIO'', ''CUENTA_ID'')';
END;
/

BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'PLYTIX',
    object_name     => 'RELACIONADO',
    policy_name     => 'POL_SEGURIDAD_RELACIONADO',
    function_schema => 'PLYTIX',
    policy_function => 'F_USUARIO_RELACIONADO',
    statement_types => 'SELECT, INSERT, UPDATE, DELETE',
    update_check    => TRUE
  );
END;
/

GRANT SELECT, INSERT, UPDATE, DELETE ON RELACIONADO TO ROL_USUARIO_ESTANDAR;

-- Permisos sobre ATRIBUTO y relación con productos
CREATE OR REPLACE FUNCTION F_USUARIO_ATRIBUTO (
    schema_name IN VARCHAR2,
    object_name IN VARCHAR2
) RETURN VARCHAR2
IS
BEGIN
    RETURN 'CUENTA_ID = SYS_CONTEXT(''CTX_USUARIO'', ''CUENTA_ID'')';
END;
/

BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'PLYTIX',
    object_name     => 'ATRIBUTO',
    policy_name     => 'POL_SEGURIDAD_ATRIBUTO',
    function_schema => 'PLYTIX',
    policy_function => 'F_USUARIO_ATRIBUTO',
    statement_types => 'SELECT, INSERT, UPDATE, DELETE',
    update_check    => TRUE
  );
END;
/

CREATE OR REPLACE FUNCTION F_USUARIO_ATRIBUTO_PRODUCTO (
    schema_name IN VARCHAR2,
    object_name IN VARCHAR2
) RETURN VARCHAR2
IS
BEGIN
    RETURN 'PRODUCTO_CUENTA_ID = SYS_CONTEXT(''CTX_USUARIO'', ''CUENTA_ID'') AND 
            ATRIBUTO_CUENTA_ID = SYS_CONTEXT(''CTX_USUARIO'', ''CUENTA_ID'')';
END;
/

BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema   => 'PLYTIX',
    object_name     => 'ATRIBUTO_PRODUCTO',
    policy_name     => 'POL_SEGURIDAD_ATRIBUTO_PRODUCTO',
    function_schema => 'PLYTIX',
    policy_function => 'F_USUARIO_ATRIBUTO_PRODUCTO',
    statement_types => 'SELECT, INSERT, UPDATE, DELETE',
    update_check    => TRUE
  );
END;
/

GRANT SELECT, INSERT, UPDATE, DELETE ON ATRIBUTO TO ROL_USUARIO_ESTANDAR;
GRANT SELECT, INSERT, UPDATE, DELETE ON ATRIBUTO_PRODUCTO TO ROL_USUARIO_ESTANDAR;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GESTOR DE CUENTAS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GRANT RESOURCE, CONNECT TO ROL_GESTOR_CUENTAS;

-- Permiso para gestionar cuentas
GRANT SELECT, INSERT, UPDATE, DELETE ON CUENTA TO ROL_GESTOR_CUENTAS;

-- Solo puede acceder a datos no sensibles del usuario
CREATE OR REPLACE VIEW V_USUARIO_PUBLICO AS
    SELECT id, nombreusuario, nombrecompleto, avatar, cuenta_id 
    FROM USUARIO;
GRANT SELECT, UPDATE ON V_USUARIO_PUBLICO TO ROL_GESTOR_CUENTAS;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PLANIFICADOR DE SERVICIOS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GRANT RESOURCE, CONNECT TO ROL_PLANIFICADOR_SERVICIOS;

-- Permiso sobre tabla PLAN
GRANT SELECT, INSERT, UPDATE, DELETE ON PLAN TO ROL_PLANIFICADOR_SERVICIOS;

-- Permiso sobre relaciones (productos, activos, categorías)
GRANT SELECT, INSERT, UPDATE, DELETE ON plan TO ROL_PLANIFICADOR_SERVICIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON producto TO ROL_PLANIFICADOR_SERVICIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON activo TO ROL_PLANIFICADOR_SERVICIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON categoria_producto TO ROL_PLANIFICADOR_SERVICIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON categoria_activo TO ROL_PLANIFICADOR_SERVICIOS;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Crear un perfil de política de contraseñas para usuarios estándar
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROFILE PERF_USUARIO_ESTANDAR LIMIT
    FAILED_LOGIN_ATTEMPTS 3              -- máximo 3 intentos fallidos
    PASSWORD_LOCK_TIME 1/24              -- 1 hora bloqueado (1/24 días)
    PASSWORD_LIFE_TIME 30                -- la contraseña caduca a los 30 días
    PASSWORD_REUSE_TIME 90               -- no puede reutilizar contraseñas recientes por 90 días
    PASSWORD_REUSE_MAX 5                 -- no puede usar las últimas 5 contraseñas
    PASSWORD_VERIFY_FUNCTION F_VERIFY_PASSWORD; -- función que comprueba la complejidad

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREACIÓN DE USUARIOS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE USER admin IDENTIFIED BY admin123;
GRANT ROL_ADMINISTRADOR_SISTEMA TO admin;

CREATE USER juan IDENTIFIED BY juan123 PROFILE PERF_USUARIO_ESTANDAR;
GRANT ROL_USUARIO_ESTANDAR TO juan;

CREATE USER pedro IDENTIFIED BY pedro123;
GRANT ROL_GESTOR_CUENTAS TO pedro

CREATE USER maria IDENTIFIED BY maria123;
GRANT ROL_PLANIFICADOR_SERVICIOS TO maria;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Poner ejemplos de usuarios realizando consultas para ver si se cumplen correctamente o no (Estos son ejemplos pa luego comprobarlos y ver si funciona bien y haacer mas)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Simula que estás actuando como el usuario Juan
ALTER SESSION SET CURRENT_SCHEMA = juan;

-- Operación que Juan puede hacer según su rol (CRUD sobre PRODUCTO)
INSERT INTO PRODUCTO (producto_id, nombre, descripcion, cuenta_id)
VALUES (101, 'Ratón', 'Ratón inalámbrico', 1);

ALTER SESSION SET CURRENT_SCHEMA = maria;

-- María puede insertar en PLAN
INSERT INTO PLAN (plan_id, nombre, descripcion)
VALUES (501, 'Plan Premium', 'Incluye todo');

ALTER SESSION SET CURRENT_SCHEMA = gestor1;

-- Modificar dirección de la cuenta
UPDATE CUENTA SET direccion_fiscal = 'Avda. Nueva, 123' WHERE cuenta_id = 1;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Para configurar la auditoría
-----------------------------------------------------------------------------------------------------------------------------------------------

AUDIT INSERT, UPDATE, DELETE ON PLAN BY ACCESS;
AUDIT INSERT, UPDATE, DELETE ON CUENTA BY ACCESS;

-----------------------------------------------------------------------------------------------------------------------------------------------
