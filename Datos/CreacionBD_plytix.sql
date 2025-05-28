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
    precio             NUMBER NOT NULL,
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

-------------------------------------- INSERTS ------------------------------------------------

----------- TABLE CUENTA
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('94','Digital Marketing Pros','Calle Serrano, 22, Madrid','W5816604',to_date('23/02/20','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('95','Fresh Foods Market','Calle Mayor, 5, Valencia','V0667415',to_date('07/12/20','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('96','Bright Future Education','Calle Mayor, 5, Valencia','W0649640',to_date('08/12/21','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('97','Health First Medical','Calle Larios, 10, Málaga','S6333699',to_date('16/04/21','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('98','Luxury Living Estates','Calle Gran Vía, 28, Madrid','G5195031',to_date('10/02/22','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('99','Eco-Friendly Products','Calle de Alcalá, 45, Madrid','S5182179',to_date('21/01/22','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('100','Digital Marketing Pros','Avenida Diagonal, 20, Barcelona','V7437021',to_date('18/01/23','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('1','Travel World Agency','Calle Serrano, 22, Madrid','V7235810',to_date('16/03/25','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('2','Tech Innovators Inc.','Avenida Diagonal, 20, Barcelona','K3574668',to_date('13/12/20','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('3','Bright Future Education','Calle Gran Vía, 28, Madrid','D7411123',to_date('01/08/24','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('4','Elite Fitness Club','Calle Serrano, 22, Madrid','L7393738',to_date('07/02/21','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('5','Bright Future Education','Calle Gran Vía, 28, Madrid','V1876383',to_date('22/02/25','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('6','Luxury Living Estates','Calle de Alcalá, 45, Madrid','U5973630',to_date('05/09/22','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('7','Creative Media Agency','Calle Serrano, 22, Madrid','F4299726',to_date('06/06/20','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('8','Health First Medical','Calle Gran Vía, 28, Madrid','P2840144',to_date('06/05/23','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('9','Global Trade Corp.','Calle Gran Vía, 28, Madrid','A7066973',to_date('28/11/24','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('10','Luxury Living Estates','Calle Gran Vía, 28, Madrid','M7360019',to_date('12/10/24','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('11','Creative Media Agency','Calle Gran Vía, 28, Madrid','F2234134',to_date('28/05/24','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('12','Future Finance Group','Calle Uría, 3, Oviedo','A0461486',to_date('05/07/21','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('13','SecureIT Services','Calle Larios, 10, Málaga','G2467937',to_date('19/08/24','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('14','Bright Future Education','Calle de Alcalá, 45, Madrid','J5462411',to_date('09/01/22','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('15','Fashion Forward Boutique','Calle Uría, 3, Oviedo','K1575025',to_date('04/10/20','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('16','Clean Water Initiative','Calle Serrano, 22, Madrid','N2982448',to_date('02/02/23','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('17','Luxury Living Estates','Avenida Diagonal, 20, Barcelona','R5788502',to_date('06/06/23','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('18','Travel World Agency','Calle Uría, 3, Oviedo','R5636771',to_date('01/02/23','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('19','Bright Future Education','Paseo de Gracia, 15, Barcelona','A9476104',to_date('13/03/20','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('20','Digital Marketing Pros','Paseo de Gracia, 15, Barcelona','C0387887',to_date('08/05/21','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('21','Tech Innovators Inc.','Calle Mayor, 5, Valencia','H7520094',to_date('27/09/24','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('22','Creative Media Agency','Calle Gran Vía, 28, Madrid','V3302898',to_date('22/03/22','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('23','Fresh Foods Market','Calle Serrano, 22, Madrid','C0161122',to_date('20/02/25','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('24','SecureIT Services','Calle Serrano, 22, Madrid','J5805392',to_date('06/05/21','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('25','Clean Water Initiative','Avenida de la Constitución, 12, Sevilla','A1381742',to_date('07/09/21','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('26','Urban Development Co.','Paseo de Gracia, 15, Barcelona','J2431831',to_date('09/12/21','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('27','Smart Home Technologies','Calle Serrano, 22, Madrid','Q8824456',to_date('21/03/23','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('28','Digital Marketing Pros','Calle Serrano, 22, Madrid','E9402003',to_date('08/09/24','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('29','Urban Development Co.','Calle de Alcalá, 45, Madrid','A9867815',to_date('13/09/20','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('30','Creative Media Agency','Calle Larios, 10, Málaga','U9589848',to_date('09/04/22','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('31','Clean Water Initiative','Calle Larios, 10, Málaga','R1647951',to_date('14/10/24','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('32','Global Trade Corp.','Calle Gran Vía, 28, Madrid','B6235055',to_date('17/04/24','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('33','Future Finance Group','Avenida de la Constitución, 12, Sevilla','P8401310',to_date('11/02/21','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('34','Smart Home Technologies','Calle Gran Vía, 28, Madrid','E1021060',to_date('22/10/22','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('35','Global Trade Corp.','Avenida de la Constitución, 12, Sevilla','L3989512',to_date('22/12/20','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('36','Fresh Foods Market','Calle de Alcalá, 45, Madrid','G0617931',to_date('18/11/24','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('37','Global Trade Corp.','Calle Gran Vía, 28, Madrid','E6476197',to_date('01/03/22','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('38','Health First Medical','Avenida de la Constitución, 12, Sevilla','P0308101',to_date('03/02/20','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('39','Future Finance Group','Avenida de la Constitución, 12, Sevilla','Q5840851',to_date('27/03/24','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('40','Travel World Agency','Paseo de Gracia, 15, Barcelona','E9931977',to_date('31/12/20','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('41','SecureIT Services','Paseo de Gracia, 15, Barcelona','G9862224',to_date('12/10/21','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('42','Auto Experts Garage','Calle Larios, 10, Málaga','K1842986',to_date('29/03/22','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('43','Creative Media Agency','Calle Larios, 10, Málaga','W8804894',to_date('07/03/20','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('44','Travel World Agency','Avenida Diagonal, 20, Barcelona','L7127457',to_date('05/06/22','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('45','Bright Future Education','Calle Mayor, 5, Valencia','R3627862',to_date('12/08/20','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('46','Digital Marketing Pros','Calle Colón, 8, Valencia','P4885531',to_date('30/11/22','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('47','Fresh Foods Market','Calle Mayor, 5, Valencia','M1345231',to_date('24/12/24','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('48','Auto Experts Garage','Calle Colón, 8, Valencia','D7233379',to_date('28/06/23','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('49','Smart Home Technologies','Calle Colón, 8, Valencia','F3899466',to_date('01/11/23','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('50','Elite Fitness Club','Paseo de Gracia, 15, Barcelona','S9613722',to_date('07/01/25','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('51','Fresh Foods Market','Calle Uría, 3, Oviedo','D7324463',to_date('04/02/24','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('52','Green Energy Solutions','Paseo de Gracia, 15, Barcelona','G1288467',to_date('30/06/20','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('53','Health First Medical','Calle Colón, 8, Valencia','F1648211',to_date('01/09/22','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('54','Health First Medical','Calle Mayor, 5, Valencia','N9805933',to_date('15/08/21','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('55','Luxury Living Estates','Avenida de la Constitución, 12, Sevilla','V3667580',to_date('26/12/23','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('56','Creative Media Agency','Calle Uría, 3, Oviedo','A1691704',to_date('27/05/23','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('57','Clean Water Initiative','Calle Larios, 10, Málaga','P5911480',to_date('30/08/23','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('58','Auto Experts Garage','Avenida de la Constitución, 12, Sevilla','M6366356',to_date('02/03/25','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('59','Fashion Forward Boutique','Calle Colón, 8, Valencia','C9474308',to_date('26/12/24','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('60','Eco-Friendly Products','Avenida Diagonal, 20, Barcelona','W4632635',to_date('23/09/22','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('61','Urban Development Co.','Calle Serrano, 22, Madrid','M0081808',to_date('02/08/21','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('62','Green Energy Solutions','Paseo de Gracia, 15, Barcelona','R9530747',to_date('27/01/22','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('63','Digital Marketing Pros','Avenida Diagonal, 20, Barcelona','V6714460',to_date('03/04/23','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('64','Elite Fitness Club','Avenida Diagonal, 20, Barcelona','V4306785',to_date('16/08/23','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('65','Eco-Friendly Products','Calle Colón, 8, Valencia','M0871781',to_date('25/10/24','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('66','Global Trade Corp.','Calle Colón, 8, Valencia','U1495106',to_date('10/12/20','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('67','Future Finance Group','Calle Serrano, 22, Madrid','U6984280',to_date('03/11/21','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('68','Health First Medical','Calle Serrano, 22, Madrid','M7705539',to_date('02/03/24','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('69','Bright Future Education','Avenida Diagonal, 20, Barcelona','H8228526',to_date('17/01/20','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('70','Auto Experts Garage','Calle Mayor, 5, Valencia','M8101059',to_date('19/07/23','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('71','Health First Medical','Calle Colón, 8, Valencia','U1715228',to_date('07/04/22','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('72','Smart Home Technologies','Calle Uría, 3, Oviedo','U6916574',to_date('28/09/24','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('73','Fresh Foods Market','Calle Mayor, 5, Valencia','V8562233',to_date('23/11/20','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('74','Fresh Foods Market','Calle de Alcalá, 45, Madrid','P4907175',to_date('03/06/21','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('75','Tech Innovators Inc.','Calle Gran Vía, 28, Madrid','S5218224',to_date('02/10/23','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('76','SecureIT Services','Calle Uría, 3, Oviedo','S7783005',to_date('29/04/22','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('77','Tech Innovators Inc.','Calle Serrano, 22, Madrid','V1306650',to_date('06/03/21','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('78','Health First Medical','Calle Mayor, 5, Valencia','U8893431',to_date('24/08/21','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('79','Urban Development Co.','Paseo de Gracia, 15, Barcelona','U7016716',to_date('04/01/25','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('80','Eco-Friendly Products','Paseo de Gracia, 15, Barcelona','L8052984',to_date('29/11/22','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('81','Green Energy Solutions','Paseo de Gracia, 15, Barcelona','D2777329',to_date('04/11/21','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('82','Eco-Friendly Products','Calle Gran Vía, 28, Madrid','C2345157',to_date('14/06/21','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('83','Smart Home Technologies','Avenida de la Constitución, 12, Sevilla','V4562337',to_date('04/11/23','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('84','Green Energy Solutions','Avenida Diagonal, 20, Barcelona','C6839292',to_date('29/06/20','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('85','Health First Medical','Calle Larios, 10, Málaga','C3859795',to_date('30/10/24','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('86','SecureIT Services','Calle de Alcalá, 45, Madrid','M2701424',to_date('11/07/20','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('87','Travel World Agency','Avenida de la Constitución, 12, Sevilla','G6996840',to_date('14/01/25','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('88','Travel World Agency','Calle Serrano, 22, Madrid','R9715792',to_date('09/06/23','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('89','Creative Media Agency','Calle Uría, 3, Oviedo','J2302678',to_date('13/12/24','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('90','Auto Experts Garage','Calle Gran Vía, 28, Madrid','K8272395',to_date('18/07/21','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('91','Urban Development Co.','Calle Colón, 8, Valencia','R5723629',to_date('05/03/25','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('92','Clean Water Initiative','Calle Gran Vía, 28, Madrid','L2875426',to_date('24/02/21','DD/MM/RR'),'3',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('93','SecureIT Services','Calle Uría, 3, Oviedo','M2363725',to_date('30/08/22','DD/MM/RR'),'1',null);

----------- TABLE PLAN
Insert into PLYTIX.PLAN (ID,NOMBRE,PRODUCTOS,ACTIVOS,ALMACENAMIENTO,CATEGORIASPRODUCTO,CATEGORIASACTIVOS,RELACIONES,PRECIO) values ('1','Free','100','200','1GB','3','3','3','0');
Insert into PLYTIX.PLAN (ID,NOMBRE,PRODUCTOS,ACTIVOS,ALMACENAMIENTO,CATEGORIASPRODUCTO,CATEGORIASACTIVOS,RELACIONES,PRECIO) values ('2','Basic','1000','20000','50GB','10','10','5','7000');
Insert into PLYTIX.PLAN (ID,NOMBRE,PRODUCTOS,ACTIVOS,ALMACENAMIENTO,CATEGORIASPRODUCTO,CATEGORIASACTIVOS,RELACIONES,PRECIO) values ('3','Enterprise','100000','100000','200GB','1000','1000','10','50000');
Insert into PLYTIX.PLAN (ID,NOMBRE,PRODUCTOS,ACTIVOS,ALMACENAMIENTO,CATEGORIASPRODUCTO,CATEGORIASACTIVOS,RELACIONES,PRECIO) values ('4','Deluxe','200000','200000','1TB','2000','2000','20','75000');

----------- TABLE PRODUCTO
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('1','SKU_000001','Fitness Tracker','Next-gen gaming console.',to_date('23/02/24','DD/MM/RR'),null,'2');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('2','SKU_000002','Bluetooth Speaker','Professional laptop for all your needs.',to_date('31/10/24','DD/MM/RR'),null,'15');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('3','SKU_000003','Wireless Headphones','Portable Bluetooth speaker.',to_date('11/10/24','DD/MM/RR'),null,'21');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('4','SKU_000004','Smartwatch','Professional laptop for all your needs.',to_date('07/07/24','DD/MM/RR'),null,'20');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('5','SKU_000005','Digital Camera','Portable Bluetooth speaker.',to_date('10/10/24','DD/MM/RR'),null,'2');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('6','SKU_000006','Smartwatch','Smartwatch with health tracking.',to_date('31/07/24','DD/MM/RR'),null,'29');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('7','SKU_000007','Digital Camera','Smartwatch with health tracking.',to_date('17/09/24','DD/MM/RR'),null,'13');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('8','SKU_000008','Fitness Tracker','High-resolution digital camera.',to_date('04/10/24','DD/MM/RR'),null,'12');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('9','SKU_000009','Laptop Pro','High-end smartphone with advanced features.',to_date('12/09/24','DD/MM/RR'),null,'22');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('10','SKU_000010','Bluetooth Speaker','Portable Bluetooth speaker.',to_date('14/04/24','DD/MM/RR'),null,'10');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('11','SKU_000011','Gaming Console','Ultra HD 4K television.',to_date('11/03/25','DD/MM/RR'),null,'19');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('12','SKU_000012','Wireless Headphones','Portable Bluetooth speaker.',to_date('13/04/24','DD/MM/RR'),null,'5');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('13','SKU_000013','4K TV','Versatile tablet for work and play.',to_date('23/07/24','DD/MM/RR'),null,'11');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('14','SKU_000014','Gaming Console','Professional laptop for all your needs.',to_date('10/05/24','DD/MM/RR'),null,'12');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('15','SKU_000015','Wireless Headphones','Fitness tracker with heart rate monitor.',to_date('26/06/24','DD/MM/RR'),null,'17');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('16','SKU_000016','4K TV','Smartwatch with health tracking.',to_date('08/01/24','DD/MM/RR'),null,'23');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('17','SKU_000017','Smartphone X','High-end smartphone with advanced features.',to_date('24/06/24','DD/MM/RR'),null,'10');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('18','SKU_000018','4K TV','Versatile tablet for work and play.',to_date('15/11/24','DD/MM/RR'),null,'21');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('19','SKU_000019','Wireless Headphones','Portable Bluetooth speaker.',to_date('08/03/25','DD/MM/RR'),null,'5');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('20','SKU_000020','Digital Camera','Ultra HD 4K television.',to_date('05/02/25','DD/MM/RR'),null,'11');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('21','SKU_000021','Digital Camera','Versatile tablet for work and play.',to_date('08/11/24','DD/MM/RR'),null,'27');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('22','SKU_000022','Laptop Pro','Smartwatch with health tracking.',to_date('18/10/24','DD/MM/RR'),null,'26');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('23','SKU_000023','Gaming Console','High-resolution digital camera.',to_date('25/01/25','DD/MM/RR'),null,'7');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('24','SKU_000024','Smartphone X','Ultra HD 4K television.',to_date('04/03/25','DD/MM/RR'),null,'2');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('25','SKU_000025','Gaming Console','Ultra HD 4K television.',to_date('05/03/25','DD/MM/RR'),null,'8');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('26','SKU_000026','4K TV','Noise-cancelling wireless headphones.',to_date('29/08/24','DD/MM/RR'),null,'1');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('27','SKU_000027','Bluetooth Speaker','Versatile tablet for work and play.',to_date('29/12/24','DD/MM/RR'),null,'16');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('28','SKU_000028','Gaming Console','Portable Bluetooth speaker.',to_date('26/06/24','DD/MM/RR'),null,'27');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('29','SKU_000029','Digital Camera','Professional laptop for all your needs.',to_date('19/12/24','DD/MM/RR'),null,'25');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('30','SKU_000030','Smartphone X','High-resolution digital camera.',to_date('11/01/24','DD/MM/RR'),null,'26');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('31','SKU_000031','Smartwatch','Versatile tablet for work and play.',to_date('22/01/24','DD/MM/RR'),null,'24');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('32','SKU_000032','Smartphone X','Next-gen gaming console.',to_date('01/02/25','DD/MM/RR'),null,'3');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('33','SKU_000033','4K TV','Ultra HD 4K television.',to_date('01/07/24','DD/MM/RR'),null,'13');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('34','SKU_000034','Laptop Pro','Portable Bluetooth speaker.',to_date('22/08/24','DD/MM/RR'),null,'15');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('35','SKU_000035','Laptop Pro','Fitness tracker with heart rate monitor.',to_date('07/02/24','DD/MM/RR'),null,'26');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('36','SKU_000036','Smartwatch','Noise-cancelling wireless headphones.',to_date('29/02/24','DD/MM/RR'),null,'27');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('37','SKU_000037','Gaming Console','Next-gen gaming console.',to_date('10/03/25','DD/MM/RR'),null,'26');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('38','SKU_000038','Bluetooth Speaker','Noise-cancelling wireless headphones.',to_date('11/02/25','DD/MM/RR'),null,'15');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('39','SKU_000039','Tablet Plus','Next-gen gaming console.',to_date('16/11/24','DD/MM/RR'),null,'19');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('40','SKU_000040','Fitness Tracker','High-end smartphone with advanced features.',to_date('15/04/24','DD/MM/RR'),null,'26');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('41','SKU_000041','Digital Camera','Portable Bluetooth speaker.',to_date('24/09/24','DD/MM/RR'),null,'28');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('42','SKU_000042','Bluetooth Speaker','Next-gen gaming console.',to_date('18/01/24','DD/MM/RR'),null,'13');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('43','SKU_000043','Digital Camera','Fitness tracker with heart rate monitor.',to_date('20/08/24','DD/MM/RR'),null,'21');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('44','SKU_000044','Smartphone X','High-end smartphone with advanced features.',to_date('06/03/24','DD/MM/RR'),null,'27');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('45','SKU_000045','Wireless Headphones','Versatile tablet for work and play.',to_date('24/01/24','DD/MM/RR'),null,'18');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('46','SKU_000046','Smartwatch','Ultra HD 4K television.',to_date('24/05/24','DD/MM/RR'),null,'16');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('47','SKU_000047','Smartwatch','High-resolution digital camera.',to_date('14/02/24','DD/MM/RR'),null,'8');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('48','SKU_000048','Laptop Pro','Versatile tablet for work and play.',to_date('10/11/24','DD/MM/RR'),null,'17');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('49','SKU_000049','Smartphone X','Noise-cancelling wireless headphones.',to_date('17/10/24','DD/MM/RR'),null,'4');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('50','SKU_000050','Fitness Tracker','Professional laptop for all your needs.',to_date('06/12/24','DD/MM/RR'),null,'28');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('51','SKU_000051','Tablet Plus','Ultra HD 4K television.',to_date('01/02/25','DD/MM/RR'),null,'2');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('52','SKU_000052','Bluetooth Speaker','Professional laptop for all your needs.',to_date('19/03/25','DD/MM/RR'),null,'2');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('53','SKU_000053','Smartwatch','High-end smartphone with advanced features.',to_date('29/11/24','DD/MM/RR'),null,'13');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('54','SKU_000054','Gaming Console','Professional laptop for all your needs.',to_date('13/01/25','DD/MM/RR'),null,'25');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('55','SKU_000055','4K TV','Smartwatch with health tracking.',to_date('03/07/24','DD/MM/RR'),null,'11');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('56','SKU_000056','Smartwatch','Versatile tablet for work and play.',to_date('21/01/24','DD/MM/RR'),null,'13');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('57','SKU_000057','Fitness Tracker','Next-gen gaming console.',to_date('17/06/24','DD/MM/RR'),null,'15');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('58','SKU_000058','Laptop Pro','Versatile tablet for work and play.',to_date('05/07/24','DD/MM/RR'),null,'16');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('59','SKU_000059','Laptop Pro','Portable Bluetooth speaker.',to_date('31/03/24','DD/MM/RR'),null,'24');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('60','SKU_000060','Gaming Console','Portable Bluetooth speaker.',to_date('12/10/24','DD/MM/RR'),null,'24');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('61','SKU_000061','Smartphone X','High-resolution digital camera.',to_date('14/06/24','DD/MM/RR'),null,'11');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('62','SKU_000062','Fitness Tracker','Ultra HD 4K television.',to_date('03/01/25','DD/MM/RR'),null,'28');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('63','SKU_000063','Laptop Pro','Noise-cancelling wireless headphones.',to_date('23/06/24','DD/MM/RR'),null,'20');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('64','SKU_000064','Tablet Plus','Ultra HD 4K television.',to_date('05/05/24','DD/MM/RR'),null,'13');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('65','SKU_000065','Bluetooth Speaker','Ultra HD 4K television.',to_date('28/01/25','DD/MM/RR'),null,'9');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('66','SKU_000066','Fitness Tracker','Noise-cancelling wireless headphones.',to_date('14/04/24','DD/MM/RR'),null,'19');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('67','SKU_000067','Wireless Headphones','Ultra HD 4K television.',to_date('22/02/24','DD/MM/RR'),null,'20');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('68','SKU_000068','Fitness Tracker','Next-gen gaming console.',to_date('26/07/24','DD/MM/RR'),null,'19');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('69','SKU_000069','Fitness Tracker','Smartwatch with health tracking.',to_date('23/05/24','DD/MM/RR'),null,'14');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('70','SKU_000070','Tablet Plus','Ultra HD 4K television.',to_date('09/02/24','DD/MM/RR'),null,'3');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('71','SKU_000071','Digital Camera','Portable Bluetooth speaker.',to_date('31/10/24','DD/MM/RR'),null,'8');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('72','SKU_000072','Bluetooth Speaker','High-end smartphone with advanced features.',to_date('13/01/25','DD/MM/RR'),null,'23');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('73','SKU_000073','Wireless Headphones','Versatile tablet for work and play.',to_date('20/05/24','DD/MM/RR'),null,'15');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('74','SKU_000074','Fitness Tracker','Smartwatch with health tracking.',to_date('07/09/24','DD/MM/RR'),null,'7');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('75','SKU_000075','Gaming Console','Professional laptop for all your needs.',to_date('15/12/24','DD/MM/RR'),null,'14');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('76','SKU_000076','4K TV','Noise-cancelling wireless headphones.',to_date('08/05/24','DD/MM/RR'),null,'20');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('77','SKU_000077','Smartwatch','High-end smartphone with advanced features.',to_date('02/04/24','DD/MM/RR'),null,'15');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('78','SKU_000078','Fitness Tracker','Ultra HD 4K television.',to_date('11/01/24','DD/MM/RR'),null,'15');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('79','SKU_000079','4K TV','High-resolution digital camera.',to_date('23/04/24','DD/MM/RR'),null,'16');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('80','SKU_000080','Gaming Console','High-resolution digital camera.',to_date('03/10/24','DD/MM/RR'),null,'21');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('81','SKU_000081','Bluetooth Speaker','Professional laptop for all your needs.',to_date('12/01/25','DD/MM/RR'),null,'4');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('82','SKU_000082','Tablet Plus','Smartwatch with health tracking.',to_date('12/03/24','DD/MM/RR'),null,'15');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('83','SKU_000083','Smartphone X','Smartwatch with health tracking.',to_date('02/02/25','DD/MM/RR'),null,'5');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('84','SKU_000084','Smartphone X','Portable Bluetooth speaker.',to_date('02/04/24','DD/MM/RR'),null,'1');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('85','SKU_000085','Digital Camera','Noise-cancelling wireless headphones.',to_date('18/02/24','DD/MM/RR'),null,'4');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('86','SKU_000086','Fitness Tracker','Ultra HD 4K television.',to_date('01/01/25','DD/MM/RR'),null,'2');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('87','SKU_000087','Smartphone X','Ultra HD 4K television.',to_date('31/01/25','DD/MM/RR'),null,'18');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('88','SKU_000088','Gaming Console','Next-gen gaming console.',to_date('16/12/24','DD/MM/RR'),null,'17');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('89','SKU_000089','Smartwatch','Ultra HD 4K television.',to_date('17/09/24','DD/MM/RR'),null,'5');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('90','SKU_000090','Bluetooth Speaker','Portable Bluetooth speaker.',to_date('23/08/24','DD/MM/RR'),null,'27');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('91','SKU_000091','Gaming Console','Versatile tablet for work and play.',to_date('24/02/25','DD/MM/RR'),null,'27');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('92','SKU_000092','Bluetooth Speaker','Portable Bluetooth speaker.',to_date('17/01/25','DD/MM/RR'),null,'13');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('93','SKU_000093','Gaming Console','Professional laptop for all your needs.',to_date('13/05/24','DD/MM/RR'),null,'22');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('94','SKU_000094','Tablet Plus','High-end smartphone with advanced features.',to_date('12/05/24','DD/MM/RR'),null,'3');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('95','SKU_000095','Wireless Headphones','Next-gen gaming console.',to_date('06/04/24','DD/MM/RR'),null,'3');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('96','SKU_000096','4K TV','Noise-cancelling wireless headphones.',to_date('01/02/25','DD/MM/RR'),null,'3');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('97','SKU_000097','Laptop Pro','Noise-cancelling wireless headphones.',to_date('03/05/24','DD/MM/RR'),null,'21');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('98','SKU_000098','Gaming Console','Smartwatch with health tracking.',to_date('01/07/24','DD/MM/RR'),null,'12');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('99','SKU_000099','Wireless Headphones','Next-gen gaming console.',to_date('28/01/24','DD/MM/RR'),null,'12');
Insert into PLYTIX.PRODUCTO (GTIN,SKU,NOMBRE,TEXTOCORTO,CREADO,MODIFICADO,CUENTA_ID) values ('100','SKU_000100','4K TV','High-resolution digital camera.',to_date('28/08/24','DD/MM/RR'),null,'28');

----------- TABLE PRODUCTOS_EXT
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000001','Fitness Tracker','Next-gen gaming console.',to_date('23/02/24','DD/MM/RR'),'2');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000002','Bluetooth Speaker','Professional laptop for all your needs.',to_date('31/10/24','DD/MM/RR'),'15');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000003','Wireless Headphones','Portable Bluetooth speaker.',to_date('11/10/24','DD/MM/RR'),'21');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000004','Smartwatch','Professional laptop for all your needs.',to_date('07/07/24','DD/MM/RR'),'20');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000005','Digital Camera','Portable Bluetooth speaker.',to_date('10/10/24','DD/MM/RR'),'2');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000006','Smartwatch','Smartwatch with health tracking.',to_date('31/07/24','DD/MM/RR'),'29');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000007','Digital Camera','Smartwatch with health tracking.',to_date('17/09/24','DD/MM/RR'),'13');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000008','Fitness Tracker','High-resolution digital camera.',to_date('04/10/24','DD/MM/RR'),'12');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000009','Laptop Pro','High-end smartphone with advanced features.',to_date('12/09/24','DD/MM/RR'),'22');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000010','Bluetooth Speaker','Portable Bluetooth speaker.',to_date('14/04/24','DD/MM/RR'),'10');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000011','Gaming Console','Ultra HD 4K television.',to_date('11/03/25','DD/MM/RR'),'19');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000012','Wireless Headphones','Portable Bluetooth speaker.',to_date('13/04/24','DD/MM/RR'),'5');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000013','4K TV','Versatile tablet for work and play.',to_date('23/07/24','DD/MM/RR'),'11');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000014','Gaming Console','Professional laptop for all your needs.',to_date('10/05/24','DD/MM/RR'),'12');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000015','Wireless Headphones','Fitness tracker with heart rate monitor.',to_date('26/06/24','DD/MM/RR'),'17');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000016','4K TV','Smartwatch with health tracking.',to_date('08/01/24','DD/MM/RR'),'23');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000017','Smartphone X','High-end smartphone with advanced features.',to_date('24/06/24','DD/MM/RR'),'10');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000018','4K TV','Versatile tablet for work and play.',to_date('15/11/24','DD/MM/RR'),'21');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000019','Wireless Headphones','Portable Bluetooth speaker.',to_date('08/03/25','DD/MM/RR'),'5');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000020','Digital Camera','Ultra HD 4K television.',to_date('05/02/25','DD/MM/RR'),'11');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000021','Digital Camera','Versatile tablet for work and play.',to_date('08/11/24','DD/MM/RR'),'27');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000022','Laptop Pro','Smartwatch with health tracking.',to_date('18/10/24','DD/MM/RR'),'26');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000023','Gaming Console','High-resolution digital camera.',to_date('25/01/25','DD/MM/RR'),'7');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000024','Smartphone X','Ultra HD 4K television.',to_date('04/03/25','DD/MM/RR'),'2');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000025','Gaming Console','Ultra HD 4K television.',to_date('05/03/25','DD/MM/RR'),'8');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000026','4K TV','Noise-cancelling wireless headphones.',to_date('29/08/24','DD/MM/RR'),'1');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000027','Bluetooth Speaker','Versatile tablet for work and play.',to_date('29/12/24','DD/MM/RR'),'16');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000028','Gaming Console','Portable Bluetooth speaker.',to_date('26/06/24','DD/MM/RR'),'27');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000029','Digital Camera','Professional laptop for all your needs.',to_date('19/12/24','DD/MM/RR'),'25');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000030','Smartphone X','High-resolution digital camera.',to_date('11/01/24','DD/MM/RR'),'26');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000031','Smartwatch','Versatile tablet for work and play.',to_date('22/01/24','DD/MM/RR'),'24');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000032','Smartphone X','Next-gen gaming console.',to_date('01/02/25','DD/MM/RR'),'3');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000033','4K TV','Ultra HD 4K television.',to_date('01/07/24','DD/MM/RR'),'13');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000034','Laptop Pro','Portable Bluetooth speaker.',to_date('22/08/24','DD/MM/RR'),'15');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000035','Laptop Pro','Fitness tracker with heart rate monitor.',to_date('07/02/24','DD/MM/RR'),'26');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000036','Smartwatch','Noise-cancelling wireless headphones.',to_date('29/02/24','DD/MM/RR'),'27');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000037','Gaming Console','Next-gen gaming console.',to_date('10/03/25','DD/MM/RR'),'26');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000038','Bluetooth Speaker','Noise-cancelling wireless headphones.',to_date('11/02/25','DD/MM/RR'),'15');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000039','Tablet Plus','Next-gen gaming console.',to_date('16/11/24','DD/MM/RR'),'19');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000040','Fitness Tracker','High-end smartphone with advanced features.',to_date('15/04/24','DD/MM/RR'),'26');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000041','Digital Camera','Portable Bluetooth speaker.',to_date('24/09/24','DD/MM/RR'),'28');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000042','Bluetooth Speaker','Next-gen gaming console.',to_date('18/01/24','DD/MM/RR'),'13');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000043','Digital Camera','Fitness tracker with heart rate monitor.',to_date('20/08/24','DD/MM/RR'),'21');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000044','Smartphone X','High-end smartphone with advanced features.',to_date('06/03/24','DD/MM/RR'),'27');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000045','Wireless Headphones','Versatile tablet for work and play.',to_date('24/01/24','DD/MM/RR'),'18');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000046','Smartwatch','Ultra HD 4K television.',to_date('24/05/24','DD/MM/RR'),'16');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000047','Smartwatch','High-resolution digital camera.',to_date('14/02/24','DD/MM/RR'),'8');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000048','Laptop Pro','Versatile tablet for work and play.',to_date('10/11/24','DD/MM/RR'),'17');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000049','Smartphone X','Noise-cancelling wireless headphones.',to_date('17/10/24','DD/MM/RR'),'4');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000050','Fitness Tracker','Professional laptop for all your needs.',to_date('06/12/24','DD/MM/RR'),'28');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000051','Tablet Plus','Ultra HD 4K television.',to_date('01/02/25','DD/MM/RR'),'2');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000052','Bluetooth Speaker','Professional laptop for all your needs.',to_date('19/03/25','DD/MM/RR'),'2');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000053','Smartwatch','High-end smartphone with advanced features.',to_date('29/11/24','DD/MM/RR'),'13');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000054','Gaming Console','Professional laptop for all your needs.',to_date('13/01/25','DD/MM/RR'),'25');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000055','4K TV','Smartwatch with health tracking.',to_date('03/07/24','DD/MM/RR'),'11');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000056','Smartwatch','Versatile tablet for work and play.',to_date('21/01/24','DD/MM/RR'),'13');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000057','Fitness Tracker','Next-gen gaming console.',to_date('17/06/24','DD/MM/RR'),'15');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000058','Laptop Pro','Versatile tablet for work and play.',to_date('05/07/24','DD/MM/RR'),'16');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000059','Laptop Pro','Portable Bluetooth speaker.',to_date('31/03/24','DD/MM/RR'),'24');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000060','Gaming Console','Portable Bluetooth speaker.',to_date('12/10/24','DD/MM/RR'),'24');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000061','Smartphone X','High-resolution digital camera.',to_date('14/06/24','DD/MM/RR'),'11');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000062','Fitness Tracker','Ultra HD 4K television.',to_date('03/01/25','DD/MM/RR'),'28');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000063','Laptop Pro','Noise-cancelling wireless headphones.',to_date('23/06/24','DD/MM/RR'),'20');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000064','Tablet Plus','Ultra HD 4K television.',to_date('05/05/24','DD/MM/RR'),'13');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000065','Bluetooth Speaker','Ultra HD 4K television.',to_date('28/01/25','DD/MM/RR'),'9');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000066','Fitness Tracker','Noise-cancelling wireless headphones.',to_date('14/04/24','DD/MM/RR'),'19');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000067','Wireless Headphones','Ultra HD 4K television.',to_date('22/02/24','DD/MM/RR'),'20');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000068','Fitness Tracker','Next-gen gaming console.',to_date('26/07/24','DD/MM/RR'),'19');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000069','Fitness Tracker','Smartwatch with health tracking.',to_date('23/05/24','DD/MM/RR'),'14');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000070','Tablet Plus','Ultra HD 4K television.',to_date('09/02/24','DD/MM/RR'),'3');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000071','Digital Camera','Portable Bluetooth speaker.',to_date('31/10/24','DD/MM/RR'),'8');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000072','Bluetooth Speaker','High-end smartphone with advanced features.',to_date('13/01/25','DD/MM/RR'),'23');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000073','Wireless Headphones','Versatile tablet for work and play.',to_date('20/05/24','DD/MM/RR'),'15');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000074','Fitness Tracker','Smartwatch with health tracking.',to_date('07/09/24','DD/MM/RR'),'7');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000075','Gaming Console','Professional laptop for all your needs.',to_date('15/12/24','DD/MM/RR'),'14');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000076','4K TV','Noise-cancelling wireless headphones.',to_date('08/05/24','DD/MM/RR'),'20');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000077','Smartwatch','High-end smartphone with advanced features.',to_date('02/04/24','DD/MM/RR'),'15');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000078','Fitness Tracker','Ultra HD 4K television.',to_date('11/01/24','DD/MM/RR'),'15');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000079','4K TV','High-resolution digital camera.',to_date('23/04/24','DD/MM/RR'),'16');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000080','Gaming Console','High-resolution digital camera.',to_date('03/10/24','DD/MM/RR'),'21');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000081','Bluetooth Speaker','Professional laptop for all your needs.',to_date('12/01/25','DD/MM/RR'),'4');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000082','Tablet Plus','Smartwatch with health tracking.',to_date('12/03/24','DD/MM/RR'),'15');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000083','Smartphone X','Smartwatch with health tracking.',to_date('02/02/25','DD/MM/RR'),'5');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000084','Smartphone X','Portable Bluetooth speaker.',to_date('02/04/24','DD/MM/RR'),'1');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000085','Digital Camera','Noise-cancelling wireless headphones.',to_date('18/02/24','DD/MM/RR'),'4');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000086','Fitness Tracker','Ultra HD 4K television.',to_date('01/01/25','DD/MM/RR'),'2');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000087','Smartphone X','Ultra HD 4K television.',to_date('31/01/25','DD/MM/RR'),'18');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000088','Gaming Console','Next-gen gaming console.',to_date('16/12/24','DD/MM/RR'),'17');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000089','Smartwatch','Ultra HD 4K television.',to_date('17/09/24','DD/MM/RR'),'5');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000090','Bluetooth Speaker','Portable Bluetooth speaker.',to_date('23/08/24','DD/MM/RR'),'27');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000091','Gaming Console','Versatile tablet for work and play.',to_date('24/02/25','DD/MM/RR'),'27');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000092','Bluetooth Speaker','Portable Bluetooth speaker.',to_date('17/01/25','DD/MM/RR'),'13');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000093','Gaming Console','Professional laptop for all your needs.',to_date('13/05/24','DD/MM/RR'),'22');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000094','Tablet Plus','High-end smartphone with advanced features.',to_date('12/05/24','DD/MM/RR'),'3');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000095','Wireless Headphones','Next-gen gaming console.',to_date('06/04/24','DD/MM/RR'),'3');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000096','4K TV','Noise-cancelling wireless headphones.',to_date('01/02/25','DD/MM/RR'),'3');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000097','Laptop Pro','Noise-cancelling wireless headphones.',to_date('03/05/24','DD/MM/RR'),'21');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000098','Gaming Console','Smartwatch with health tracking.',to_date('01/07/24','DD/MM/RR'),'12');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000099','Wireless Headphones','Next-gen gaming console.',to_date('28/01/24','DD/MM/RR'),'12');
Insert into PLYTIX.PRODUCTOS_EXT (SKU,NOMBRE,TEXTOCORTO,CREADO,CUENTA_ID) values ('SKU_000100','4K TV','High-resolution digital camera.',to_date('28/08/24','DD/MM/RR'),'28');

----------- TABLE USUARIO
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('87','qortuno','Sandra Pina Baró','qortuno@example.org','34980533394','31');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('88','ggutierrez','Gaspar Martin','ggutierrez@example.net','34872900521','25');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('89','pinogoyo','Florentina Coca Reguera','pinogoyo@example.com','+34 980 604 053','42');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('90','maricela83','Mónica Monreal Castilla','maricela83@example.org','+34927 592 304','33');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('91','trinicastello','Iris Jiménez Rincón','trinicastello@example.com','+34930 88 61 12','31');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('92','qtomas','Liliana Torre','qtomas@example.com','+34 985314171','1');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('93','borjamedina','Eligia Camino Cárdenas','borjamedina@example.net','+34 986 69 06 07','7');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('94','uriatatiana','Danilo del Morata','uriatatiana@example.net','+34 836237620','28');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('95','balduinootero','Cloe Redondo Sosa','balduinootero@example.org','34883513666','28');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('96','bruvera','Jesús Moll Cepeda','bruvera@example.org','+34 902 93 30 84','6');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('97','benitaquerol','María Manuela Morán Medina','benitaquerol@example.net','+34 979422934','44');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('98','antunezleire','Samuel Juan Francisco Casals Lamas','antunezleire@example.com','+34 902837262','8');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('99','eveliacuellar','Anacleto Calderon-Tejero','eveliacuellar@example.org','+34984 454 543','41');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('100','holmedo','Hermenegildo del Benavente','holmedo@example.org','+34986 85 54 05','9');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('101','francojoel','Héctor Borja Bastida','francojoel@example.org','+34988 458 801','49');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('102','cabrerosalomon','Caridad Barranco Vaquero','cabrerosalomon@example.com','+34820 18 13 95','8');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('103','arseniopol','Raúl Cuadrado Pazos','arseniopol@example.net','+34 879 483 130','12');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('104','asaura','Trini Bárcena Haro','asaura@example.org','34725158373','5');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('105','ndonaire','Itziar Valverde Martínez','ndonaire@example.net','+34821 021 261','24');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('106','lsolis','Florencia Fabiola Murillo Bellido','lsolis@example.com','+34 986 235 137','18');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('107','roldanaznar','Priscila Chaparro-Palomares','roldanaznar@example.org','34882351956','41');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('108','kcapdevila','Kike Agustín Cuenca','kcapdevila@example.com','+34902 413 304','27');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('109','jbonet','Feliciano Puig Querol','jbonet@example.org','+34690 359 658','26');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('110','alvaro47','Arsenio Santana Elorza','alvaro47@example.net','+34 949 82 61 36','6');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('111','danielahernandez','Eloísa Teruel-Arana','danielahernandez@example.net','+34986 30 73 31','38');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('112','tejerazaida','Rubén Miró Salom','tejerazaida@example.com','+34920 41 43 94','48');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('113','tomasamaya','Bartolomé Muñoz Salinas','tomasamaya@example.org','+34841 24 99 26','48');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('114','renemenendez','Marcela Montaña Castelló','renemenendez@example.net','+34748 532 897','47');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('115','estradarosalia','Valerio Perez Escrivá','estradarosalia@example.org','+34 924 80 11 49','12');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('116','wcornejo','Azeneth Zaragoza Amador','wcornejo@example.com','+34 923 42 60 68','41');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('117','julia37','Clementina de Quesada','julia37@example.net','+34972 44 88 22','16');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('118','nicanormanso','Ofelia Carranza Campo','nicanormanso@example.org','+34 883602806','12');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('119','lamasmario','Fermín Arellano Benavent','lamasmario@example.org','+34972 846 191','38');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('120','penacelso','Joaquina Salas Vigil','penacelso@example.com','+34 975 67 95 38','40');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('121','qbastida','Joaquina Torrents','qbastida@example.net','+34849 423 253','39');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('122','leonardo02','Baltasar Martinez','leonardo02@example.org','+34843 54 08 87','24');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('123','teocamino','Rafael Vaquero Figueras','teocamino@example.org','+34841 62 63 52','26');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('124','regulo85','Berta Ugarte Llorens','regulo85@example.org','+34 875973363','14');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('125','carrillogonzalo','Bernardino Díaz Narváez','carrillogonzalo@example.com','+34807 140 750','2');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('126','elena87','Marciano Pera Arias','elena87@example.org','+34 723 463 244','3');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('127','irma80','Marisa Sobrino','irma80@example.com','+34878 74 09 44','2');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('128','emilioguillen','Telmo Adán Riba','emilioguillen@example.org','+34 902 90 75 26','44');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('129','bermejomarciano','Telmo León Viñas Gárate','bermejomarciano@example.com','+34942 385 193','10');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('130','busquetseugenio','Ana Vergara Viñas','busquetseugenio@example.net','+34 811 979 356','23');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('1','anagarcia','Ana García Pérez','ana.garcia@email.com','678123456','66');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('2','joselopez','José López Martínez','jose.lopez@email.com','612987654','41');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('3','mariarodriguez','María Rodríguez Sánchez','maria.rodriguez@email.com','655234567','1');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('4','davidfernandez','David Fernández González','david.fernandez@email.com','633345678','34');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('5','lauramartin','Laura Martín Romero','laura.martin@email.com','644456789','2');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('6','carlosperez','Carlos Pérez García','carlos.perez@email.com','600567890','62');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('7','sofiagonzalez','Sofía González López','sofia.gonzalez@email.com','677678901','63');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('8','pabloromero','Pablo Romero Martínez','pablo.romero@email.com','688789012','73');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('9','isabelsanchez','Isabel Sánchez Rodríguez','isabel.sanchez@email.com','655890123','62');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('10','adrianlopez','Adrián López Fernández','adrian.lopez@email.com','633901234','64');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('11','andrearodriguez','Andrea Rodríguez García','andrea.rodriguez@email.com','644012345','65');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('12','javierfernandez','Javier Fernández Pérez','javier.fernandez@email.com','600123456','44');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('13','paulamartin','Paula Martín Sánchez','paula.martin@email.com','677234567','71');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('14','alejandroperez','Alejandro Pérez Romero','alejandro.perez@email.com','688345678','14');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('15','elenagonzalez','Elena González Martínez','elena.gonzalez@email.com','655456789','27');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('16','miguelromero','Miguel Romero López','miguel.romero@email.com','633567890','69');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('17','valeriasanchez','Valeria Sánchez García','valeria.sanchez@email.com','644678901','76');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('18','daniellopez','Daniel López Sánchez','daniel.lopez@email.com','600789012','26');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('19','albarodriguez','Alba Rodríguez Pérez','alba.rodriguez@email.com','677890123','2');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('20','ivanfernandez','Iván Fernández Martínez','ivan.fernandez@email.com','688901234','38');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('21','carmenmartin','Carmen Martín García','carmen.martin@email.com','655012345','38');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('22','rubenperez','Rubén Pérez Romero','ruben.perez@email.com','633123456','51');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('23','saragonzalez','Sara González Sánchez','sara.gonzalez@email.com','644234567','74');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('24','aitorromero','Aitor Romero López','aitor.romero@email.com','600345678','21');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('25','natalialopez','Natalia López García','natalia.lopez@email.com','677456789','31');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('26','hugorodriguez','Hugo Rodríguez Martínez','hugo.rodriguez@email.com','688567890','59');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('27','oliviafernandez','Olivia Fernández Pérez','olivia.fernandez@email.com','655678901','2');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('28','diegomartin','Diego Martín Sánchez','diego.martin@email.com','633789012','43');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('29','valentinaperez','Valentina Pérez Romero','valentina.perez@email.com','644890123','51');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('30','alvarogonzalez','Álvaro González Martínez','alvaro.gonzalez@email.com','600901234','50');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('31','salcedolucho','Aurora Guillén Delgado','salcedolucho@example.org','+34 871256380','3');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('32','ofeliaferrero','Osvaldo de Ferrández','ofeliaferrero@example.com','+34 800 298 398','27');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('33','cletoalberdi','Marc del Bou','cletoalberdi@example.org','+34 873 301 562','39');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('34','morcillonicanor','Milagros del Pizarro','morcillonicanor@example.net','34825901131','47');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('35','irocamora','Vidal Cabanillas','irocamora@example.com','+34 926592662','13');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('36','alemanarmida','Hermenegildo Belda-Casal','alemanarmida@example.net','+34 803266917','47');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('37','polconcepcion','Ascensión Molina Sola','polconcepcion@example.net','+34 949719596','46');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('38','wjerez','Jesús Néstor Carrión Benito','wjerez@example.com','+34 846 05 63 72','13');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('39','figuerolajoaquin','Adán Losada Barco','figuerolajoaquin@example.org','+34 877084928','21');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('40','abr-02','Maxi Pintor Raya','abril02@example.com','+34 928 78 82 67','49');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('41','canopurificacion','Ciríaco González Martí','canopurificacion@example.net','34972934998','43');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('42','dferrando','Priscila Roca Castejón','dferrando@example.org','+34 707268685','21');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('43','narciso56','Trinidad Fuster Iniesta','narciso56@example.org','+34847 848 718','25');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('44','casandraayuso','Óscar Fito Fonseca Hidalgo','casandraayuso@example.org','34920975307','24');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('45','crocha','Segismundo del Mateo','crocha@example.net','+34 926 53 30 80','2');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('46','hidalgojose-mari','Guiomar de Escobar','hidalgojose-mari@example.com','34977068407','17');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('47','apolonia83','Nieves de Quiroga','apolonia83@example.net','+34987 68 96 73','20');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('48','magdalenaramon','Maxi Quevedo Garmendia','magdalenaramon@example.org','+34706 483 140','19');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('49','teresa63','Teo Molina','teresa63@example.org','34844676935','2');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('50','pastor47','Flora Marti Mas','pastor47@example.net','+34928 30 32 48','20');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('51','pastorapedro','Ibán Hernandez','pastorapedro@example.org','+34 848 664 928','49');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('52','urrutiaaraceli','Jordán Corbacho','urrutiaaraceli@example.net','+34 830834291','5');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('53','querolcatalina','Carla Pomares-Núñez','querolcatalina@example.com','+34874 750 208','6');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('54','bibianacabello','Germán Pedrosa Piña','bibianacabello@example.net','+34944 71 15 14','3');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('55','samanta00','Anselma Cámara','samanta00@example.com','+34800 759 134','34');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('56','eroldan','Ángeles Guardia Escamilla','eroldan@example.net','+34 741188904','3');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('57','tiburcio46','Pepe Castrillo Martín','tiburcio46@example.org','+34 827 197 844','22');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('58','cortesanunciacion','Olalla de Mata','cortesanunciacion@example.com','+34981 722 181','24');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('59','alosada','Loreto Mendez','alosada@example.net','34973310384','29');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('60','toledomacario','Juan Bautista Velasco Cid','toledomacario@example.com','+34 806129876','36');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('61','haydeearnaiz','Roberta Herrero','haydeearnaiz@example.com','+34 971 39 00 98','9');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('62','gilabertobdulia','Etelvina Murcia Céspedes','gilabertobdulia@example.org','34828326977','41');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('63','candelariomendoza','Aitana Nicolás Rojas','candelariomendoza@example.net','34849394642','26');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('64','evelia73','Silvia Alegria-León','evelia73@example.net','+34 878 25 77 56','18');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('65','marta39','Rosendo Escudero Flor','marta39@example.org','34885064530','7');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('66','dantunez','Vanesa de Jódar','dantunez@example.com','34847529088','13');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('67','nando50','Graciano Juárez-Mínguez','nando50@example.com','+34 885 212 150','25');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('68','navarretearsenio','Gregorio Mármol Garcia','navarretearsenio@example.net','+34 824 32 59 94','11');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('69','ysaez','Javier Castro-Cerro','ysaez@example.com','+34 942 914 722','25');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('70','rmorante','Juan Bautista Aramburu Simó','rmorante@example.org','+34 875 94 88 62','25');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('71','olimpiasoriano','Anna Sanmiguel Andres','olimpiasoriano@example.com','+34985 227 707','20');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('72','nguzman','Lilia Nicolasa Moles Alvarez','nguzman@example.net','+34 900 52 51 99','42');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('73','cabanasnatanael','Edgardo Galan Matas','cabanasnatanael@example.net','+34 820903336','26');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('74','azaharasalinas','Saturnino Lucas Marcos','azaharasalinas@example.net','+34 948 763 379','27');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('75','silviarobledo','Victor Torrent Aroca','silviarobledo@example.com','+34 946468861','28');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('76','hcrespo','Adelia del Roselló','hcrespo@example.net','+34 986 44 41 97','34');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('77','fortunatoguzman','Benita Ruiz','fortunatoguzman@example.org','+34877 073 094','48');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('78','silvestreherrero','Ale Aramburu Laguna','silvestreherrero@example.com','+34 944 750 187','14');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('79','eugeniacoca','Chelo Valbuena-Belmonte','eugeniacoca@example.com','+34623 38 48 10','2');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('80','mpallares','Rita Meléndez Dávila','mpallares@example.net','+34920 544 672','47');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('81','satienza','Serafina Vicens Torrent','satienza@example.com','+34969 744 023','27');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('82','zrodriguez','Maristela Vicente Zurita','zrodriguez@example.org','+34730 252 239','22');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('83','ibarraencarnacion','Luis Vergara Alfonso','ibarraencarnacion@example.org','+34873 11 12 11','15');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('84','zaida54','Leandra Robledo Barroso','zaida54@example.org','+34980 16 92 70','14');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('85','rubenbenitez','Inocencio Amorós','rubenbenitez@example.com','+34818 45 29 46','41');
Insert into PLYTIX.USUARIO (ID,NOMBRE_USUARIO,NOMBRECOMPLETO,EMAIL,TELEFONO,CUENTA_ID) values ('86','iledesma','Gastón Mínguez Zurita','iledesma@example.org','34712974360','3');