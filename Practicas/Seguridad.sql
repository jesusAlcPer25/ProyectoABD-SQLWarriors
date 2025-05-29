-- Crear roles según los perfiles especificados
CREATE ROLE administrador_sistema;
CREATE ROLE usuario_estandar;
CREATE ROLE gestor_cuentas;
CREATE ROLE planificador_servicios;

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
-- CREACIÓN DE USUARIOS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE USER admin IDENTIFIED BY admin123;
GRANT administrador_sistema TO admin;

CREATE USER juan IDENTIFIED BY juan123;
GRANT usuario_estandar TO juan;

CREATE USER pedro INDENTIFIED BY pedro123;
GRANT gestor_cuentas TO pedro

CREATE USER maria IDENTIFIED BY maria123;
GRANT planificador_servicios TO maria;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
