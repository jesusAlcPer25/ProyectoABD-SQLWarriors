-- Generado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   en:        2025-04-02 11:43:46 CEST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

ALTER SESSION SET CURRENT_SCHEMA = PLYTIX;

CREATE TABLE "ACT-CAT_ACT" (
    activo_id            NUMBER NOT NULL,
    activo_id1           NUMBER NOT NULL,
    categoria_activo_id  NUMBER NOT NULL,
    categoria_activo_id1 NUMBER NOT NULL,
    CONSTRAINT "ACTIVOS-CATEGORIA_ACTIVOS_PK" PRIMARY KEY ( activo_id,
                                                                activo_id1,
                                                                categoria_activo_id,
                                                                categoria_activo_id1 ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE activo (
    id        NUMBER NOT NULL,
    nombre    VARCHAR2(30 CHAR) NOT NULL,
    tamaño    NUMBER NOT NULL,
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
                                                      producto_cuenta_id,
                                                      atributo_id,
                                                      atributo_cuenta_id ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE categoría (
    id        NUMBER NOT NULL,
    nombre    VARCHAR2(30 CHAR) NOT NULL,
    cuenta_id NUMBER NOT NULL,
    CONSTRAINT categoría_pk PRIMARY KEY ( id, cuenta_id ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE categoria_activo (
    id        NUMBER NOT NULL,
    nombre    VARCHAR2(30 CHAR) NOT NULL,
    cuenta_id NUMBER NOT NULL,
    CONSTRAINT categoria_activo_pk PRIMARY KEY ( id, cuenta_id ) USING INDEX TABLESPACE TS_INDICES
);

CREATE TABLE "CAT-PROD" (
    categoría_id  NUMBER NOT NULL,
    categoría_id1 NUMBER NOT NULL,
    producto_gtin NUMBER NOT NULL,
    producto_id   NUMBER NOT NULL,
    CONSTRAINT "CATEGORIA-PRODUCTO_PK" PRIMARY KEY ( categoría_id,
                                                         categoría_id1,
                                                         producto_gtin,
                                                         producto_id ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE cuenta (
    id              NUMBER NOT NULL,
    nombre          VARCHAR2(30 CHAR) NOT NULL,
    direcciónfiscal VARCHAR2(50 CHAR) NOT NULL,
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


CREATE TABLE "PROD-ACT" (
    producto_gtin      NUMBER NOT NULL,
    producto_cuenta_id NUMBER NOT NULL,
    activo_id          NUMBER NOT NULL,
    activo_cuenta_id   NUMBER NOT NULL,
    CONSTRAINT "PRODUCTO-ACTIVOS_PK" PRIMARY KEY ( producto_gtin,
                                                       producto_cuenta_id,
                                                       activo_id,
                                                       activo_cuenta_id ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE producto (
    gtin       NUMBER NOT NULL,
    sku        VARCHAR2(30 CHAR) NOT NULL,
    nombre     VARCHAR2(30 CHAR) NOT NULL,
    miniatura  BLOB,
    textocorto VARCHAR2(100 CHAR),
    creado     DATE,
    modificado DATE,
    cuenta_id  NUMBER NOT NULL,
    CONSTRAINT producto_pk PRIMARY KEY ( gtin,
                                                              cuenta_id ) USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE relacionado (
    nombre              VARCHAR2(20 CHAR) NOT NULL,
    sentido             VARCHAR2(20 CHAR),
    producto_gtin       NUMBER NOT NULL,
    producto_gtin1      NUMBER NOT NULL,
    producto_cuenta_id  NUMBER NOT NULL,
    producto_cuenta_id1 NUMBER NOT NULL,
    CONSTRAINT relacionado_pk PRIMARY KEY ( producto_gtin,
                                                producto_cuenta_id,
                                                producto_gtin1,
                                                producto_cuenta_id1 )USING INDEX TABLESPACE TS_INDICES
);


CREATE TABLE usuario (
    id             NUMBER NOT NULL,
    nombre_usuario VARCHAR2(30 CHAR) NOT NULL,
    nombrecompleto VARCHAR2(30 CHAR) NOT NULL,
    avatar         BLOB,
    email          VARCHAR2(50 CHAR),
    teléfono       VARCHAR2(20 CHAR),
    cuenta_id      NUMBER NOT NULL,
    CONSTRAINT usuario_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES

);



ALTER TABLE activo
    ADD CONSTRAINT activo_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );
 
ALTER TABLE "ACT-CAT_ACT"
    ADD CONSTRAINT "Activo_Categoria_FK" FOREIGN KEY ( activo_id,
                                                                       activo_id1 )
        REFERENCES activo ( id,
                            cuenta_id );

ALTER TABLE "ACT-CAT_ACT"
    ADD CONSTRAINT "Categoria_Activo_FK" FOREIGN KEY ( categoria_activo_id,
                                                                                 categoria_activo_id1 )
        REFERENCES categoria_activo ( id,
                                      cuenta_id );

ALTER TABLE atributo
    ADD CONSTRAINT atributo_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

ALTER TABLE atributo_producto
    ADD CONSTRAINT atributo_producto_atributo_fk FOREIGN KEY ( atributo_id,
                                                               atributo_cuenta_id )
        REFERENCES atributo ( id,
                              cuenta_id );

ALTER TABLE atributo_producto
    ADD CONSTRAINT atributo_producto_producto_fk FOREIGN KEY ( producto_gtin,
                                                               producto_cuenta_id )
        REFERENCES producto ( gtin,
                              cuenta_id );

ALTER TABLE categoria_activo
    ADD CONSTRAINT categoria_activo_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

ALTER TABLE categoría
    ADD CONSTRAINT categoría_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

ALTER TABLE "CAT-PROD"
    ADD CONSTRAINT "CAT-PROD_Categoría_FK" FOREIGN KEY ( categoría_id,
                                                                   categoría_id1 )
        REFERENCES categoría ( id,
                               cuenta_id );

ALTER TABLE "CAT-PROD"
    ADD CONSTRAINT "CATEGORIA-PRODUCTO_Producto_FK" FOREIGN KEY ( producto_gtin,
                                                                  producto_id )
        REFERENCES producto ( gtin,
                              cuenta_id );

ALTER TABLE cuenta
    ADD CONSTRAINT cuenta_plan_fk FOREIGN KEY ( plan_id )
        REFERENCES plan ( id );

ALTER TABLE producto
    ADD CONSTRAINT producto_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );

ALTER TABLE "PROD-ACT"
    ADD CONSTRAINT "PRODUCTO-ACTIVOS_Activo_FK" FOREIGN KEY ( activo_id,
                                                              activo_cuenta_id )
        REFERENCES activo ( id,
                            cuenta_id );

ALTER TABLE "PROD-ACT"
    ADD CONSTRAINT "PRODUCTO-ACTIVOS_Producto_FK" FOREIGN KEY ( producto_gtin,
                                                                producto_cuenta_id )
        REFERENCES producto ( gtin,
                              cuenta_id );

ALTER TABLE relacionado
    ADD CONSTRAINT relacionado_producto_fk FOREIGN KEY ( producto_gtin,
                                                         producto_cuenta_id )
        REFERENCES producto ( gtin,
                              cuenta_id );

ALTER TABLE relacionado
    ADD CONSTRAINT relacionado_producto_fkv1 FOREIGN KEY ( producto_gtin1,
                                                           producto_cuenta_id1 )
        REFERENCES producto ( gtin,
                              cuenta_id );

ALTER TABLE usuario
    ADD CONSTRAINT usuario_cuenta_fk FOREIGN KEY ( cuenta_id )
        REFERENCES cuenta ( id );


