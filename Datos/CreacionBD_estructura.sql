-- Creacion de los tablespaces
CREATE TABLESPACE TS_PLYTIX DATAFILE 'PLYTIX01.DBF' SIZE 500M AUTOEXTEND ON;
CREATE TABLESPACE TS_INDICES DATAFILE 'INDICES01.DBF' SIZE 50M AUTOEXTEND ON;
-- SELECT * FROM DBA_TABLESPACES;
-- SELECT * FROM V$DATAFILE;

CREATE USER PLYTIX IDENTIFIED BY plytix
    DEFAULT TABLESPACE TS_PLYTIX
    QUOTA UNLIMITED ON TS_PLYTIX
    QUOTA UNLIMITED ON TS_INDICES
;
GRANT   CREATE TABLE,
        CREATE VIEW, 
        CREATE MATERIALIZED VIEW, 
        CREATE SEQUENCE, 
        CREATE PROCEDURE,
        CREATE TRIGGER 
TO PLYTIX;
GRANT CONNECT, RESOURCE TO PLYTIX;

-- Ejecutar como system
ALTER SESSION SET CURRENT_SCHEMA = PLYTIX;

-- Tabla de Activo->Categoria_activo
CREATE TABLE activo_categoria_act (
    activo_id                   NUMBER NOT NULL,
    categoria_activo_id         NUMBER NOT NULL,
    activo_cuenta_id            NUMBER NOT NULL,
    categoria_activo_cuenta_id  NUMBER NOT NULL,
    CONSTRAINT activo_categoria_act_pk PRIMARY KEY ( activo_id,
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
    producto_cuenta_id NUMBER NOT NULL,
    atributo_id        NUMBER NOT NULL,
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

CREATE TABLE categoria_producto (
    categoria_id        NUMBER NOT NULL,
    categoria_cuenta_id NUMBER NOT NULL,
    producto_gtin       NUMBER NOT NULL,
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

CREATE UNIQUE INDEX cuenta_idx ON
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

CREATE TABLE producto_activo (
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
)
LOB (miniatura) STORE AS SECUREFILE miniatura_lob (
    TABLESPACE TS_INDICES
    ENABLE STORAGE IN ROW
);

CREATE TABLE relacionado (
    nombre                          VARCHAR2(30 CHAR) NOT NULL,
    sentido                         VARCHAR2(30 CHAR),
    producto_gtin                   NUMBER NOT NULL,
    producto_cuenta_id              NUMBER NOT NULL,
    producto_relacionado_gtin       NUMBER NOT NULL,
    producto_relacionado_cuenta_id  NUMBER NOT NULL,
    CONSTRAINT relacionado_pk PRIMARY KEY ( producto_gtin, 
                                                producto_relacionado_gtin,
                                                producto_cuenta_id,
                                                producto_relacionado_cuenta_id 
                                            )USING INDEX TABLESPACE TS_INDICES
);

CREATE TABLE usuario (
    id                  NUMBER NOT NULL,
    nombreusuario       VARCHAR2(30 CHAR) NOT NULL,
    nombrecompleto      VARCHAR2(50 CHAR) NOT NULL,
    avatar              BLOB,
    correoelectronico   VARCHAR2(50 CHAR),
    telefono            VARCHAR2(20 CHAR),
    cuenta_id           NUMBER NOT NULL,
    CONSTRAINT usuario_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES
)
LOB (avatar) STORE AS SECUREFILE avatar_lob (
    TABLESPACE TS_INDICES
    ENABLE STORAGE IN ROW
);



ALTER TABLE activo
    ADD CONSTRAINT activo_cuenta_id_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

-- Toma la fk de activo 
ALTER TABLE activo_categoria_act
    ADD CONSTRAINT ACTIVO_CAT_ACT_FK FOREIGN KEY ( activo_id, activo_cuenta_id )
        REFERENCES activo ( id, cuenta_id );

-- Toma la fk de categoria_activo
ALTER TABLE activo_categoria_act
    ADD CONSTRAINT ACT_CATEGORIA_ACTIVO_FK FOREIGN KEY ( categoria_activo_id, categoria_activo_cuenta_id )                                                                               
        REFERENCES categoria_activo ( id, cuenta_id );

ALTER TABLE atributo
    ADD CONSTRAINT atributo_cuenta_id_fk FOREIGN KEY ( cuenta_id )
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
    ADD CONSTRAINT categoria_cuenta_id_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

ALTER TABLE categoria_producto
    ADD CONSTRAINT CATEGORIA_PROD_FK FOREIGN KEY ( categoria_id, categoria_cuenta_id )
        REFERENCES categoria ( id, cuenta_id );

ALTER TABLE categoria_producto
    ADD CONSTRAINT CAT_PRODUCTO_FK FOREIGN KEY ( producto_gtin, producto_cuenta_id )
        REFERENCES producto ( gtin, cuenta_id );

ALTER TABLE cuenta
    ADD CONSTRAINT cuenta_plan_fk FOREIGN KEY ( plan_id )
        REFERENCES plan ( id );

ALTER TABLE cuenta
    ADD CONSTRAINT cuenta_usuario_fk FOREIGN KEY ( usuario_id )
        REFERENCES usuario ( id );

ALTER TABLE producto
    ADD CONSTRAINT producto_cuenta_id_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

ALTER TABLE producto_activo
    ADD CONSTRAINT PRODUCTO_ACTIVO_Activo_FK FOREIGN KEY ( activo_id, activo_cuenta_id )
        REFERENCES activo ( id, cuenta_id );

ALTER TABLE producto_activo
    ADD CONSTRAINT PRODUCTO_ACTIVO_Producto_FK FOREIGN KEY ( producto_gtin, producto_cuenta_id )
        REFERENCES producto ( gtin, cuenta_id );

ALTER TABLE relacionado
    ADD CONSTRAINT relacionado_producto_fk FOREIGN KEY ( producto_gtin, producto_cuenta_id )
        REFERENCES producto ( gtin, cuenta_id );

ALTER TABLE relacionado
    ADD CONSTRAINT producto_relacionado_fk FOREIGN KEY ( producto_relacionado_gtin, producto_relacionado_cuenta_id )
        REFERENCES producto ( gtin, cuenta_id );

ALTER TABLE usuario
    ADD CONSTRAINT usuario_cuenta_id_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );


-- Creacion de la tabla externa
-- Descargamos y guardamos el archivo productos.csv en C:\app\alumnos\admin\orcl\dpdump
create or replace directory directorio_ext as 'C:\app\alumnos\admin\orcl\dpdump';
grant read, write on directory directorio_ext to PLYTIX; 

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


-- Creacion de indices
-- Indice simple sobre nombreusuario
CREATE INDEX idx_nombreusuario
ON USUARIO (NOMBREUSUARIO)
TABLESPACE TS_INDICES;

-- Indice sobre una función: UPPER(nombrecompleto)
CREATE INDEX idx_upper_nombrecompleto
ON USUARIO (UPPER(NOMBRECOMPLETO))
TABLESPACE TS_INDICES;

-- Crear indice bitmap sobre cuenta_id
CREATE BITMAP INDEX idx_cuenta_usuario_bitmap
ON USUARIO (CUENTA_ID)
TABLESPACE TS_INDICES;


-- Creacion de la VM
CREATE MATERIALIZED VIEW VM_PRODUCTOS
    BUILD IMMEDIATE
    REFRESH COMPLETE
    START WITH TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ' 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
    NEXT TRUNC(SYSDATE + 1)
    AS SELECT * FROM PRODUCTOS_EXT
;


-- Crear secuencia
CREATE SEQUENCE SEQ_PRODUCTOS
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE
;
create or replace trigger TR_PRODUCTOS  
before insert on PRODUCTO for each row 
begin 
    if :new.GTIN is null then  
        :new.GTIN := SEQ_PRODUCTOS.NEXTVAL; 
    end if; 
END TR_PRODUCTOS;


-- Creacion de la tabla TRAZA para seguimiento de errores
CREATE TABLE TRAZA 
    (
        Fecha Date,
        Usuario VARCHAR2(40),
        Causante VARCHAR2(40), 
        Descripcion VARCHAR2(500) 
    )
    TABLESPACE TS_PLYTIX
;

-- Cifrado de columnas
-- SELECT * FROM DBA_ENCRYPTED_COLUMNS;  -- Comprabacion