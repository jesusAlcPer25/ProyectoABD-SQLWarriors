-- Creación de roles
CREATE USER ADMIN IDENTIFIED BY admin
    DEFAULT TABLESPACE TS_PLYTIX
    QUOTA UNLIMITED ON TS_PLYTIX
    QUOTA UNLIMITED ON TS_INDICES
    ACCOUNT LOCK
;
GRANT DBA TO ADMIN;

--      Administrador sistema
CREATE ROLE ROL_ADMIN IDENTIFIED BY admin;

GRANT ADMINISTER KEY MANAGEMENT TO ROL_ADMIN;               -- Gestión TDE, solo un usuario
GRANT ALTER SYSTEM TO ROL_ADMIN;
GRANT EXECUTE ON DBMS_RLS TO ROL_ADMIN;                     -- Gestión VPD
GRANT ALTER USER TO ROL_ADMIN;                              -- Gestión de usuarios
GRANT EXECUTE ON PKG_ADMIN_PRODUCTOS.P_CREA_USUARIO TO ROL_ADMIN;           -- Crea usario
GRANT EXECUTE ON PKG_ADMIN_PRODUCTOS.P_BORRAR_USUARIO TO ROL_ADMIN;         -- Eliminar usuario
GRANT GRANT ANY ROLE TO ROL_ADMIN;

GRANT ALL ON activo_categoria_act TO ROL_ADMIN;             -- Gestion de tablas
GRANT ALL ON activo TO ROL_ADMIN;    
GRANT ALL ON atributo TO ROL_ADMIN;    
GRANT ALL ON atributo_producto TO ROL_ADMIN;    
GRANT ALL ON categoria TO ROL_ADMIN;    
GRANT ALL ON categoria_activo TO ROL_ADMIN;    
GRANT ALL ON categoria_producto TO ROL_ADMIN;    
GRANT ALL ON cuenta TO ROL_ADMIN;    
GRANT ALL ON plan TO ROL_ADMIN;    
GRANT ALL ON producto_activo TO ROL_ADMIN;    
GRANT ALL ON producto TO ROL_ADMIN;
GRANT ALL ON productos_ext TO ROL_ADMIN;
GRANT ALL ON usuario TO ROL_ADMIN;    
GRANT ALL ON relacionado TO ROL_ADMIN;
GRANT ALL ON traza TO ROL_ADMIN;

GRANT RESOURCE, CONNECT TO ROL_ADMIN;                       -- Gestión conexión y recursos
GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE TO ROL_ADMIN;

-- Crear roles según los perfiles especificados
CREATE ROLE ROL_ADMINISTRADOR_SISTEMA;
CREATE ROLE ROL_USUARIO_ESTANDAR;
CREATE ROLE ROL_GESTOR_CUENTAS;
CREATE ROLE ROL_PLANIFICADOR_SERVICIOS;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ADMINISTRADOR DEL SISTEMA
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Control total sobre Plytix
GRANT ALL PRIVILEGES ON ALL TABLES TO administrador_sistema;
GRANT ALL PRIVILEGES ON ALL SEQUENCES TO administrador_sistema;

-- Seguridad: El Administrador tiene TDE y VPD (esto debe implementarse por DBA, ejemplo teórico):
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'PLYTIX',
        object_name   => 'PRODUCTO',
        policy_name   => 'VPD_PRODUCTO_POLICY',
        function_schema => 'SECURITY',
        policy_function => 'f_policy_producto',
        statement_types => 'SELECT,INSERT,UPDATE,DELETE'
    );
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- USUARIO ESTÁNDAR
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Permiso para ver/modificar su propia info (asumiendo columna usuario_id o similar)
GRANT SELECT, UPDATE ON USUARIO TO usuario_estandar;

-- Permisos sobre PRODUCTO
ALTER TABLE PRODUCTO ADD PUBLICO CHAR(1) DEFAULT 'S';
GRANT SELECT, INSERT, UPDATE, DELETE ON PRODUCTO TO usuario_estandar;

-- Vista de productos públicos
CREATE OR REPLACE VIEW V_PRODUCTO_PUBLICO AS
    SELECT * FROM PRODUCTO WHERE PUBLICO = 'S';
GRANT SELECT ON V_PRODUCTO_PUBLICO TO usuario_estandar;

-- Permisos sobre ACTIVO y relación Categorías
GRANT SELECT, INSERT, UPDATE, DELETE ON ACTIVO TO usuario_estandar;
GRANT SELECT, INSERT, UPDATE, DELETE ON CATEGORIA_ACTIVO TO usuario_estandar;

---------------------------------------- Modificar el trigger TR_PRODUCTOS para asignar cuenta_id automáticamente ----------------------------------------
CREATE OR REPLACE TRIGGER TR_PRODUCTOS
    BEFORE INSERT ON PRODUCTO
    FOR EACH ROW
BEGIN
    SELECT cuenta_id INTO :NEW.cuenta_id
    FROM USUARIO
    WHERE usuario_id = SYS_CONTEXT('USERENV', 'SESSION_USER');
END;

-- Permisos sobre CATEGORÍA Y relación con producto
GRANT SELECT, INSERT, UPDATE, DELETE ON CATEGORIA TO usuario_estandar;
GRANT SELECT, INSERT, UPDATE, DELETE ON PRODUCTO_CATEGORIA TO usuario_estandar;

-- Permisos sobre RELACIONADO
GRANT SELECT, INSERT, UPDATE, DELETE ON RELACIONADO TO usuario_estandar;

-- Permisos sobre ATRIBUTO y relación con productos
GRANT SELECT, INSERT, UPDATE, DELETE ON ATRIBUTO TO usuario_estandar;
GRANT SELECT, INSERT, UPDATE, DELETE ON ATRIBUTO_PRODUCTO TO usuario_estandar;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GESTOR DE CUENTAS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Permiso para gestionar cuentas
GRANT SELECT, INSERT, UPDATE, DELETE ON CUENTA TO gestor_cuentas;

-- Solo puede acceder a datos no sensibles del usuario
CREATE OR REPLACE VIEW V_USUARIO_PUBLICO AS
    SELECT usuario_id, nombre, apellido FROM USUARIO;
GRANT SELECT ON V_USUARIO_PUBLICO TO gestor_cuentas;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PLANIFICADOR DE SERVICIOS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Permiso sobre tabla PLAN
GRANT SELECT, INSERT, UPDATE, DELETE ON PLAN TO planificador_servicios;

-- Permiso sobre relaciones (productos, activos, categorías)
GRANT SELECT, INSERT, UPDATE, DELETE ON PLAN_PRODUCTO TO planificador_servicios;
GRANT SELECT, INSERT, UPDATE, DELETE ON PLAN_ACTIVO TO planificador_servicios;
GRANT SELECT, INSERT, UPDATE, DELETE ON PLAN_CATEGORIA TO planificador_servicios;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Crear un perfil de política de contraseñas para usuarios estándar
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROFILE perfil_usuario_estandar LIMIT
    FAILED_LOGIN_ATTEMPTS 3              -- máximo 3 intentos fallidos
    PASSWORD_LOCK_TIME 1/24              -- 1 hora bloqueado (1/24 días)
    PASSWORD_LIFE_TIME 30                -- la contraseña caduca a los 30 días
    PASSWORD_REUSE_TIME 90               -- no puede reutilizar contraseñas recientes por 90 días
    PASSWORD_REUSE_MAX 5                 -- no puede usar las últimas 5 contraseñas
    PASSWORD_VERIFY_FUNCTION verify_function; -- función que comprueba la complejidad

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREACIÓN DE USUARIOS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE USER admin IDENTIFIED BY admin123;
GRANT administrador_sistema TO admin;

CREATE USER juan IDENTIFIED BY juan123;
GRANT usuario_estandar TO juan;
ALTER USER juan PROFILE perfil_usuario_estandar;

CREATE USER pedro INDENTIFIED BY pedro123;
GRANT gestor_cuentas TO pedro

CREATE USER maria IDENTIFIED BY maria123;
GRANT planificador_servicios TO maria;

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

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Para encryptar columnas
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Hacerlo con las columnas que queramos y ya estaria hecho

ALTER TABLE USUARIO MODIFY (EMAIL ENCRYPT);
ALTER TABLE USUARIO MODIFY (TELEFONO ENCRYPT);
ALTER TABLE USUARIO MODIFY (NIF ENCRYPT);


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------






-------- SEGURIDAD Y PERMISOS -------------------------------------------------------------------

--      Usuario Estandar
CREATE ROLE ROL_USUARIO;

GRANT SELECT, UPDATE ON USUARIO TO ROL_USUARIO;
GRANT SELECT ON plan TO ROL_USUARIO;
GRANT RESOURCE, CONNECT TO ROL_USUARIO;                     -- Gestión conexión y recursos

--      Gestor cuentas
CREATE ROLE ROL_GESTOR_CUENTA;
GRANT RESOURCE, CONNECT TO ROL_GESTOR_CUENTA;               -- Gestión conexión y recursos

--      Planificador Servicios
CREATE ROLE ROL_PLAN_SERVICIOS;
GRANT RESOURCE, CONNECT TO ROL_PLAN_SERVICIOS;              -- Gestión conexión y recursos


-- Gestión de Permisos
-- RF1. Gestión rpoductos, Categoría y Activos
GRANT SELECT, INSERT, UPDATE, DELETE ON producto TO ROL_USUARIO;
GRANT SELECT, INSERT, UPDATE, DELETE ON activo TO ROL_USUARIO;
GRANT SELECT, INSERT, UPDATE, DELETE ON activo_categoria_act TO ROL_USUARIO;
GRANT SELECT, INSERT, UPDATE, DELETE ON categoria TO ROL_USUARIO;
GRANT SELECT, INSERT, UPDATE, DELETE ON categoria_producto TO ROL_USUARIO;
    --  Un producto solo puede ser de una categoría de su misma cuenta
GRANT SELECT, INSERT, UPDATE, DELETE ON relacionado TO ROL_USUARIO;
    -- Solo se pueden relacionar productos de la misma cuenta que debe ser la misma que la del usuario que crea la relación.
GRANT SELECT, INSERT, UPDATE, DELETE ON atributo TO ROL_USUARIO;
GRANT SELECT, INSERT, UPDATE, DELETE ON atributo_producto TO ROL_USUARIO;
    -- Ambos tienen que ser de la misma cuenta.


-- RF2. Gestión de cuentas
GRANT SELECT, INSERT, UPDATE, DELETE ON CUENTA TO ROL_GESTOR_CUENTA;
CREATE OR REPLACE VIEW V_USUARIO_PUBLICO AS
    SELECT id, nombreusuario, nombrecompleto, avatar, cuenta_id
    FROM USUARIO;                                           -- Preguntar si hacer por vistas o politicas
-- CREATE SYNONYM USUARIO FOR V_USUARIO_PUBLICO;
GRANT SELECT, UPDATE ON V_USUARIO_PUBLICO TO ROL_GESTOR_CUENTA;


-- RF3. Gestión de los planes
GRANT SELECT, INSERT, UPDATE, DELETE ON plan TO ROL_PLAN_SERVICIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON producto TO ROL_PLAN_SERVICIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON activo TO ROL_PLAN_SERVICIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON categoria_producto TO ROL_PLAN_SERVICIOS;
GRANT SELECT, INSERT, UPDATE, DELETE ON categoria_activo TO ROL_PLAN_SERVICIOS;

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Para configurar la auditoría
-----------------------------------------------------------------------------------------------------------------------------------------------

AUDIT INSERT, UPDATE, DELETE ON PLAN BY ACCESS;

-----------------------------------------------------------------------------------------------------------------------------------------------