-- 1. Creacion del usuario y tablespace
-- Para buscar los distintos DATAFILE
SELECT * FROM V$DATAFILE;

-- Crear TABLESPACES
ALTER DATABASE DATAFILE 'C:\APP\ALUMNOS\ORADATA\ORCL\TS_PLITYX01.DBF' AUTOEXTEND ON NEXT 100M MAXSIZE 2G;
CREATE TABLESPACE TS_INDICES DATAFILE 'C:\APP\ALUMNOS\ORADATA\ORCL\TS_INDICES01.DBF' SIZE 50M AUTOEXTEND ON;

-- Crear usuario PLYTIX con su tablespace por defecto, quota 500M en TS_PLYTIX y quota 50M en TS_INDICES
CREATE USER PLYTIX IDENTIFIED BY plytix
DEFAULT TABLESPACE TS_PLYTIX
QUOTA 500M ON TS_PLYTIX
QUOTA 50M ON TS_INDICES;

-- Dar permisos al usuario para crear tablas, vistas, vistas materializadas, secuencias y procedimientos
GRANT CREATE TABLE, CREATE VIEW, CREATE MATERIALIZED VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO PLYTIX;

-- Consultar que los tablespaces existen
SELECT TABLESPACE_NAME FROM DBA_TABLESPACES WHERE TABLESPACE_NAME IN ('TS_PLYTIX', 'TS_INDICES');

-- Comprobar que el tablespace por defecto del usuario PLYTIX es TS_PLYTIX
SELECT USERNAME, DEFAULT_TABLESPACE FROM DBA_USERS WHERE USERNAME = 'PLYTIX';

-- Comprobar los datafiles asociados a TS_PLYTIX y TS_INDICES
SELECT FILE_NAME, TABLESPACE_NAME, BYTES/1024/1024 AS_SIZE_MB FROM DBA_DATA_FILES WHERE TABLESPACE_NAME IN ('TS_PLYTIX', 'TS_INDICES');



-- 2. Creacion del esquema
-- Script para montar todo desde cero

BEGIN
    FOR T IN (SELECT TABLE_NAME FROM DBA_TABLES WHERE OWNER = 'PLYTIX') LOOP
        EXECUTE IMMEDIATE 'DROP TABLE PLYTIX.' || T.TABLE_NAME || 'CASCADE CONSTRAINTS';
    END LOOP;
    FOR V IN (SELECT VIEW_NAME FROM DBA_VIEWS WHERE OWNER = 'PLYTIX') LOOP
        EXECUTE IMMEDIATE 'DROP VIEW PLYTIX.' || V.VIEW_NAME;
    END LOOP;
    FOR S IN (SELECT SYNONYM_NAME FROM DBA_SYNONYMS WHERE OWNER = 'PLYTIX_MP') LOOP
        EXECUTE IMMEDIATE 'DROP SYNONYM PLYTIX_MP.' || S.SYNONYM_NAME || '';
    END LOOP;
END;
/

-- Ejecutar como system
ALTER SESSION SET CURRENT_SCHEMA = PLYTIX;

-- Tabla de Activo->Categoria activo, esta puesto asi para que no de problemas
CREATE TABLE ACTIVO_CAT_ACT (
    activo_id                   NUMBER NOT NULL,
    categoria_activo_id         NUMBER NOT NULL,
    activo_cuenta_id            NUMBER NOT NULL,
    categoria_activo_cuenta_id  NUMBER NOT NULL,
    CONSTRAINT ACTIVO_CATEGORIA_ACTIVO_PK PRIMARY KEY ( activo_id,
                                                        activo_cuenta_id,
                                                        categoria_activo_id,
                                                        categoria_activo_cuenta_id 
                                                        ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE activo (
    id        NUMBER NOT NULL,
    nombre    VARCHAR2(30 CHAR) NOT NULL,
    tamano    NUMBER NOT NULL,
    tipo      VARCHAR2(30 CHAR),
    url       VARCHAR2(50 CHAR),
    cuenta_id NUMBER NOT NULL,
    CONSTRAINT activo_pk PRIMARY KEY ( id, cuenta_id ) USING INDEX TABLESPACE TS_INDICES
);

CREATE TABLE atributo (
    id        NUMBER NOT NULL,
    nombre    VARCHAR2(30 CHAR) NOT NULL,
    tipo      VARCHAR2(30 CHAR),
    creado    DATE NOT NULL,
    cuenta_id NUMBER NOT NULL,
    CONSTRAINT atributo_pk PRIMARY KEY ( id, cuenta_id ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE atributo_producto (
    valor              NUMBER NOT NULL,
    producto_gtin      NUMBER NOT NULL,
    atributo_id        NUMBER NOT NULL,
    producto_cuenta_id NUMBER NOT NULL,
    atributo_cuenta_id NUMBER NOT NULL,
    CONSTRAINT atributo_producto_pk PRIMARY KEY ( producto_gtin, 
                                                    atributo_id, 
                                                    valor,
                                                    producto_cuenta_id,
                                                    atributo_cuenta_id 
                                                ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE categoria (
    id        NUMBER NOT NULL,
    nombre    VARCHAR2(30 CHAR) NOT NULL,
    cuenta_id NUMBER NOT NULL,
    CONSTRAINT categoria_pk PRIMARY KEY ( id, cuenta_id ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE categoria_activo (
    id        NUMBER NOT NULL,
    nombre    VARCHAR2(30 CHAR) NOT NULL,
    cuenta_id NUMBER NOT NULL,
    CONSTRAINT categoria_activo_pk PRIMARY KEY ( id, cuenta_id ) USING INDEX TABLESPACE TS_INDICES
);

CREATE TABLE CAT_PROD (
    categoria_id        NUMBER NOT NULL,
    producto_gtin       NUMBER NOT NULL,
    categoria_cuenta_id NUMBER NOT NULL,
    producto_cuenta_id  NUMBER NOT NULL,
    CONSTRAINT CATEGORIA_PRODUCTO_PK PRIMARY KEY ( categoria_id,
                                                        producto_gtin,
                                                        categoria_cuenta_id,
                                                        producto_cuenta_id
                                                ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE cuenta (
    id              NUMBER NOT NULL,
    nombre          VARCHAR2(50 CHAR) NOT NULL,
    direccionfiscal VARCHAR2(50 CHAR) NOT NULL,
    nif             VARCHAR2(30) NOT NULL,
    fechaalta       DATE NOT NULL,
    plan_id         NUMBER NOT NULL,
    usuario_id      NUMBER,
    CONSTRAINT cuenta_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES
);

CREATE UNIQUE INDEX cuenta__idx ON
    cuenta (
        usuario_id
    ASC )
TABLESPACE TS_INDICES
;


CREATE TABLE plan (
    id                 NUMBER NOT NULL,
    nombre             VARCHAR2(30 CHAR) NOT NULL,
    productos          NUMBER NOT NULL,
    activos            NUMBER NOT NULL,
    almacenamiento     VARCHAR2(50) NOT NULL,
    categoriasproducto NUMBER NOT NULL,
    categoriasactivos  NUMBER NOT NULL,
    relaciones         NUMBER NOT NULL,
    precioanual        NUMBER NOT NULL,
    CONSTRAINT plan_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE PROD_ACT (
    producto_gtin      NUMBER NOT NULL,
    producto_cuenta_id NUMBER NOT NULL,
    activo_id          NUMBER NOT NULL,
    activo_cuenta_id   NUMBER NOT NULL,
    CONSTRAINT PRODUCTO_ACTIVO_PK PRIMARY KEY ( producto_gtin,
                                                producto_cuenta_id,
                                                activo_id,
                                                activo_cuenta_id 
                                            ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE producto (
    gtin       NUMBER NOT NULL,
    sku        VARCHAR2(40 CHAR) NOT NULL,
    nombre     VARCHAR2(50 CHAR) NOT NULL,
    miniatura  BLOB,
    textocorto VARCHAR2(150 CHAR),
    creado     DATE,
    modificado DATE,
    cuenta_id  NUMBER NOT NULL,
    CONSTRAINT producto_pk PRIMARY KEY ( gtin, cuenta_id ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE relacionado (
    nombre                          VARCHAR2(30 CHAR) NOT NULL,
    sentido                         VARCHAR2(30 CHAR),
    producto_gtin                   NUMBER NOT NULL,
    producto_cuenta_id              NUMBER NOT NULL,
    producto_relacionado_gtin       NUMBER NOT NULL,
    -- producto_cuenta_id1 NUMBER NOT NULL,
    CONSTRAINT relacionado_pk PRIMARY KEY ( producto_gtin, 
                                                producto_relacionado_gtin,
                                                producto_cuenta_id
                                                -- producto_cuenta_id1 
                                            )USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE usuario (
    id             NUMBER NOT NULL,
    nombre_usuario VARCHAR2(30 CHAR) NOT NULL,
    nombrecompleto VARCHAR2(50 CHAR) NOT NULL,
    avatar         BLOB,
    email          VARCHAR2(50 CHAR),
    telefono       VARCHAR2(20 CHAR),
    cuenta_id      NUMBER NOT NULL,
    CONSTRAINT usuario_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES

);



ALTER TABLE activo
    ADD CONSTRAINT activo_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

-- Toma la fk de activo 
ALTER TABLE ACTIVO_CAT_ACT
    ADD CONSTRAINT ACTIVO_CAT_ACTIVO_FK FOREIGN KEY ( activo_id, activo_cuenta_id )
        REFERENCES activo ( id, cuenta_id );

-- Toma la fk de categoria_activo
ALTER TABLE ACTIVO_CAT_ACT
    ADD CONSTRAINT ACT_CATEGORIA_ACTIVO_FK FOREIGN KEY ( categoria_activo_id, categoria_activo_cuenta_id )                                                                               
        REFERENCES categoria_activo ( id, cuenta_id );

ALTER TABLE atributo
    ADD CONSTRAINT atributo_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

-- Toma la fk de atributo
ALTER TABLE atributo_producto 
    ADD CONSTRAINT atributo_producto_atributo_fk FOREIGN KEY ( atributo_id, atributo_cuenta_id )
        REFERENCES atributo ( id, cuenta_id );

-- Toma la fk de producto
ALTER TABLE atributo_producto
    ADD CONSTRAINT atributo_producto_producto_fk FOREIGN KEY ( producto_gtin, producto_cuenta_id )
        REFERENCES producto ( gtin, cuenta_id );

ALTER TABLE categoria_activo
    ADD CONSTRAINT categoria_activo_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

ALTER TABLE categoria
    ADD CONSTRAINT categoria_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

ALTER TABLE CAT_PROD
    ADD CONSTRAINT CATEGORIA_PROD_FK FOREIGN KEY ( categoria_id, categoria_cuenta_id )
        REFERENCES categoria ( id, cuenta_id );

ALTER TABLE CAT_PROD
    ADD CONSTRAINT CAT_PRODUCTO_FK FOREIGN KEY ( producto_gtin, producto_cuenta_id )
        REFERENCES producto ( gtin, cuenta_id );

ALTER TABLE cuenta
    ADD CONSTRAINT cuenta_plan_fk FOREIGN KEY ( plan_id )
        REFERENCES plan ( id );

ALTER TABLE cuenta
    ADD CONSTRAINT cuenta_usuario_fk FOREIGN KEY ( usuario_id )
        REFERENCES usuario ( id );

ALTER TABLE producto
    ADD CONSTRAINT producto_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

ALTER TABLE PROD_ACT
    ADD CONSTRAINT PRODUCTO_ACTIVO_Activo_FK FOREIGN KEY ( activo_id, activo_cuenta_id )
        REFERENCES activo ( id, cuenta_id );

ALTER TABLE PROD_ACT
    ADD CONSTRAINT PRODUCTO_ACTIVO_Producto_FK FOREIGN KEY ( producto_gtin, producto_cuenta_id )
        REFERENCES producto ( gtin, cuenta_id );

ALTER TABLE relacionado
    ADD CONSTRAINT relacionado_producto_fk FOREIGN KEY ( producto_gtin, producto_cuenta_id )
        REFERENCES producto ( gtin, cuenta_id );

ALTER TABLE relacionado
    ADD CONSTRAINT producto_relacionado_fk FOREIGN KEY ( producto_relacionado_gtin )
                                                          -- producto_cuenta_id1 )
        REFERENCES producto ( gtin )
                              -- cuenta_id );

ALTER TABLE usuario
    ADD CONSTRAINT usuario_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );



-- 3. Importar datos

-- Plan -> Importar datos 

-- Cuenta -> Importar datos

-- Usuario -> Importar datos



-- 4. Tablas externas

-- Descargamos y guardamos el archivo productos.csv en C:\app\alumnos\admin\orcl\dpdump

-- Ejecutar como system
create or replace directory directorio_ext as 'C:\app\alumnos\admin\orcl\dpdump';

grant read, write on directory directorio_ext to PLYTIX; 

-- Ejecutar como PLYTIX
create table productos_ext 
    (        
        sku        VARCHAR2(40 CHAR) NOT NULL,
        nombre     VARCHAR2(50 CHAR) NOT NULL,
        textocorto VARCHAR2(150 CHAR),
        creado     DATE,
        cuenta_id  NUMBER NOT NULL
    )

ORGANIZATION EXTERNAL ( 
    TYPE ORACLE_LOADER 
    DEFAULT DIRECTORY directorio_ext 
    ACCESS PARAMETERS ( 
        RECORDS DELIMITED BY NEWLINE 
        SKIP 1 
        CHARACTERSET UTF8 
        FIELDS TERMINATED BY ';' 
        OPTIONALLY ENCLOSED BY '"' 
        MISSING FIELD VALUES ARE NULL 
        ( 
            sku        CHAR(40),
            nombre     CHAR(50),
            textocorto CHAR(150),
            creado     CHAR(10) DATE_FORMAT DATE MASK "dd/mm/yyyy", 
            cuenta_id  CHAR(10) 
        ) 
    ) 
    LOCATION ('productos.csv') 
);

-- Comprobacion acciones sobre la tabla externa
SELECT * FROM productos_ext; -- Muestra todo sin problemas

-- No se permite ni insert ni update sobre tablas externas
INSERT INTO productos_ext VALUES (3, 'Producto C', 300, SYSDATE, 103);
UPDATE productos_ext SET nombre = 150 WHERE cuenta_id = 1;



-- 5. Indices
-- Comprobacion clave primaria
SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'USUARIO';

-- Indice simple sobre nombreusuario
CREATE INDEX idx_nombreusuario
ON USUARIO (NOMBRE_USUARIO)
TABLESPACE TS_INDICES;

-- Indice sobre una función: UPPER(nombrecompleto)
CREATE INDEX idx_upper_nombrecompleto
ON USUARIO (UPPER(NOMBRECOMPLETO))
TABLESPACE TS_INDICES;

-- Comprobacion de los indices
SELECT index_name, table_name, tablespace_name, index_type
FROM user_indexes
WHERE table_name = 'USUARIO';

-- Verificar tablespace de la tabla USUARIO
SELECT table_name, tablespace_name
FROM user_tables
WHERE table_name = 'USUARIO';

-- Verificar tablespace de los índices
SELECT index_name, tablespace_name
FROM user_indexes
WHERE table_name = 'USUARIO';

-- Crear indice bitmap sobre cuenta_id
CREATE BITMAP INDEX idx_cuenta_usuario_bitmap
ON USUARIO (CUENTA_ID)
TABLESPACE TS_INDICES;

-- Verificacion indice tipo Bitmap
SELECT index_name, index_type
FROM user_indexes
WHERE index_name = 'IDX_CUENTA_USUARIO_BITMAP';




-- 6. Vista Materializada
CREATE MATERIALIZED VIEW VM_PRODUCTOS
    BUILD IMMEDIATE
    REFRESH COMPLETE
    START WITH TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ' 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
    NEXT TRUNC(SYSDATE + 1)
    AS SELECT * FROM PRODUCTOS_EXT
;



-- 7. Sinonimos
-- Ejecutar desde system
CREATE PUBLIC SYNONYM S_PRODUCTOS FOR PLYTIX.VM_PRODUCTOS; 



-- 8. Producto
-- Ejecutar desde system
GRANT CREATE SEQUENCE TO PLYTIX;

-- Ejecutar desde PLYTIX
CREATE SEQUENCE SEQ_PRODUCTOS
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE
;

-- Ejecutar desde system para dar permiso a PLYTIX para crear triggers
GRANT CREATE TRIGGER TO PLYTIX;

-- Este script de PL/SQL se encarga de proporcionar el GTIN
create or replace trigger TR_PRODUCTOS  
before insert on PRODUCTO for each row 
begin 
    if :new.GTIN is null then  
        :new.GTIN := SEQ_PRODUCTOS.NEXTVAL; 
    end if; 
END TR_PRODUCTOS;

-- Ejecutar desde system para revocar el permiso para crear triggers
REVOKE CREATE TRIGGER FROM PLYTIX;

-- Volvemos a ejecutar desde PLYTIX para insertar en producto
INSERT INTO PRODUCTO (
    SKU, NOMBRE, TEXTOCORTO, CREADO, CUENTA_ID
)
SELECT
    SKU, NOMBRE, TEXTOCORTO, CREADO, CUENTA_ID
FROM S_PRODUCTOS;
