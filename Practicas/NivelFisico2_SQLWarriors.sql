----------------------------------------------------- Creación de roles ---------------------------------------------

-- Administración del Sistema

CREATE ROLE admin_sis IDENTIFIED BY admin;

GRANT ADMINISTER KEY MANAGEMENT TO admin_sis;                                   -- Para gestionar el TDE, solo aplicable para un usuario

GRANT EXECUTE ON DBMS_RLS TO admin_sistema;                                     -- Para gestionar el VPD

GRANT CREATE USER, ALTER USER, DROP USER TO admin_sis;                          -- Gestión de usuarios
GRANT GRANT ANY ROLE TO admin_sis;
 
GRANT SELECT, INSERT, UPDATE, DELETE ON ACTIVO_CAT_ACT TO admin_sis;            -- Gestion de tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON activo TO admin_sis;    
GRANT SELECT, INSERT, UPDATE, DELETE ON atributo TO admin_sis;    
GRANT SELECT, INSERT, UPDATE, DELETE ON atributo_producto TO admin_sis;    
GRANT SELECT, INSERT, UPDATE, DELETE ON categoria TO admin_sis;    
GRANT SELECT, INSERT, UPDATE, DELETE ON categoria_activo TO admin_sis;    
GRANT SELECT, INSERT, UPDATE, DELETE ON cat_prod TO admin_sis;    
GRANT SELECT, INSERT, UPDATE, DELETE ON cuenta TO admin_sis;    
GRANT SELECT, INSERT, UPDATE, DELETE ON plan TO admin_sis;    
GRANT SELECT, INSERT, UPDATE, DELETE ON prod_act TO admin_sis;    
GRANT SELECT, INSERT, UPDATE, DELETE ON producto TO admin_sis;    
GRANT SELECT, INSERT, UPDATE, DELETE ON relacionado TO admin_sis;    
GRANT SELECT, INSERT, UPDATE, DELETE ON usuario TO admin_sis;    

GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE TO admin_sistema;

CREATE OR REPLACE PROCEDURE eliminar_tabla_activo_cat_act IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE ACTIVO_CAT_ACT'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_activo IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE activo'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_atributo IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE atributo'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_atributo_producto IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE atributo_producto'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_categoria IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE categoria'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_categoria_activo IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE categoria_activo'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_cat_prod IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE cat_prod'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_cuenta IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE cuenta'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_plan IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE plan'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_prod_act IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE prod_act'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_producto IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE producto'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_relacionado IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE relacionado'; END;
END;

CREATE OR REPLACE PROCEDURE eliminar_tabla_usuario IS
BEGIN
        BEGIN EXECUTE IMMEDIATE 'DROP TABLE usuario'; END;
END;


-- Usuario Estandard
CREATE ROLE usu_est;


-- Gestor de cuentas
CREATE ROLE ges_cuen;


-- Planificador de Servicios 
CREATE ROLE plan_serv;


-----------------------------------------------------------------------------------------------------
-- 1. RF1. Gestión de los Productos, Categorías y activos

-- Creamos la función para que los usuarios solo puedan acceder a  sus datos
CREATE OR REPLACE FUNCTION vpd_function(p_schema varchar2, p_obj varchar2)
    RETURN varchar2
IS
    VUSUARIO VARCHAR2(100);
BEGIN
     VUSUARIO := SYS_CONTEXT('userenv', 'SESSION_USER');
     RETURN 'UPPER(Nombreusuario) = ''' || Vusuario || '''';
END;
/

-- Comprobamos que la función se ha creadoo correctamente.
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_TYPE = 'FUNCTION' AND OBJECT_NAME = 'VPD_FUNCTION';

-- Creamos la política sobre la tabla USUARIO
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'PLYTIX',
        object_name => 'USUARIO',
        policy_name => 'P_GES_USER',
        function_schema => 'PLYTIX',
        policy_function => 'VPD_FUNCTION',
        statement_types => 'SELECT, UPDATE'
    );
END;
/

-- Creamos la política sobre la tabla ACTIVO
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'PLYTIX',
        object_name => 'ACTIVO',
        policy_name => 'P_GES_ACT',
        function_schema => 'PLYTIX',
        policy_function => 'VPD_FUNCTION',
        statement_types => 'SELECT, UPDATE'
    );
END;
/

-- Creamos la política sobre la tabla ATRIBUTO
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'PLYTIX',
        object_name => 'ATRIBUTO',
        policy_name => 'P_GES_ATR',
        function_schema => 'PLYTIX',
        policy_function => 'VPD_FUNCTION',
        statement_types => 'SELECT, UPDATE'
    );
END;
/

-- Creamos la política sobre la tabla PRODUCTO
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'PLYTIX',
        object_name => 'PRODUCTO',
        policy_name => 'P_GES_PROD',
        function_schema => 'PLYTIX',
        policy_function => 'VPD_FUNCTION',
        statement_types => 'SELECT, UPDATE'
    );
END;
/

-- Creamos la política sobre la tabla PLAN
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'PLYTIX',
        object_name => 'PLAN',
        policy_name => 'P_GES_PLAN',
        function_schema => 'PLYTIX',
        policy_function => 'VPD_FUNCTION',
        statement_types => 'SELECT, UPDATE'
    );
END;
/

ALTER TABLE productos ADD (PUBLICO CHAR(1) DEFAULT 'S' NOT NULL);

CREATE OR REPLACE VIEW V_PRODUCTO_PUBLICO AS SELECT * FROM producto WHERE PUBLICO = 'S';




-----------------------------------------------------------------------------------------------------
-- 2. RF2. Gestión de las cuentas

GRANT SELECT, UPDATE (NOMBRE, DIRECCIONFISCAL, NIF) ON CUENTA TO ges_cuen;

-- Otorgar permisos para acceder a los atributos de usuario necesarios




-----------------------------------------------------------------------------------------------------
-- 3. RF3. Gestión de lo planes

-- Tabla Plan
GRANT SELECT, INSERT, UPDATE, DELETE ON PLAN TO plan_serv;

-- Tabla Producto
GRANT SELECT, INSERT, UPDATE, DELETE ON PRODUCTO TO plan_serv;

-- Tabla Activo
GRANT SELECT, INSERT, UPDATE, DELETE ON ACTIVO TO plan_serv;

-- Tabla CategoríaProducto
GRANT SELECT, INSERT, UPDATE, DELETE ON "CAT-PROD" TO plan_serv;

-- Tabla CategoríaActivo
GRANT SELECT, INSERT, UPDATE, DELETE ON CATEGORIA_ACTIVO TO plan_serv;