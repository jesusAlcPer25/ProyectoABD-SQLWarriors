----------------------------------------------------- Creación de roles ---------------------------------------------

-- Administración del Sistema

CREATE ROLE admin_sis IDENTIFIED BY admin;
GRANT ADMINISTER KEY MANAGEMENT TO admin_sis;           -- Para gestionar el TDE, solo aplicable para un usuario
GRANT EXECUTE ON DBMS_RLS TO admin_sistema;             -- Para gestionar el VPD
GRANT CREATE USER, ALTER USER, DROP USER TO admin_sis;  -- Gestión de usuarios
GRANT GRANT ANY ROLE TO admin_sis;
 
GRANT SELECT, INSERT, UPDATE, DELETE ON cuenta TO admin_sis;    -- Gestion de tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON cuenta TO admin_sis;    -- Gestion de tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON cuenta TO admin_sis;    -- Gestion de tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON cuenta TO admin_sis;    -- Gestion de tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON cuenta TO admin_sis;    -- Gestion de tablas

GRANT CREATE ANY TABLE, 
        SELECT ANY TABLE, 
        DELETE ANY TABLE
        TO admin_sis;



-- Usuario Estandard




-- Gestor de cuentas





-- Planificador de Servicios 





-- 1. RF1. Gestión de los Productos, Categorías y activos













-- 2. RF2. Gestión de las cuentas
-- Otorgar los permisos al Gestor de Cuentas para hacer CRUD de la tabla cuentas. 
-- Otorgarle los permisos para acceder a los atributos de usuario necesarios.





-- 3. RF3. Gestión de lo planes -> Otorgar los permisos Planificador de servicios para hacer CRUD de la tabla planes.
