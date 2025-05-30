--------------------------------------------------------
-- Archivo creado  - viernes-mayo-30-2025   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence SEQ_PRODUCTOS
--------------------------------------------------------

   CREATE SEQUENCE  "PLYTIX"."SEQ_PRODUCTOS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Table ACTIVO
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."ACTIVO" 
   (	"ID" NUMBER, 
	"NOMBRE" VARCHAR2(30 CHAR), 
	"TAMANO" NUMBER, 
	"TIPO" VARCHAR2(30 CHAR), 
	"URL" VARCHAR2(50 CHAR), 
	"CUENTA_ID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table ACTIVO_CATEGORIA_ACT
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."ACTIVO_CATEGORIA_ACT" 
   (	"ACTIVO_ID" NUMBER, 
	"CATEGORIA_ACTIVO_ID" NUMBER, 
	"ACTIVO_CUENTA_ID" NUMBER, 
	"CATEGORIA_ACTIVO_CUENTA_ID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table ATRIBUTO
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."ATRIBUTO" 
   (	"ID" NUMBER, 
	"NOMBRE" VARCHAR2(30 CHAR), 
	"TIPO" VARCHAR2(30 CHAR), 
	"CREADO" DATE, 
	"CUENTA_ID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table ATRIBUTO_PRODUCTO
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."ATRIBUTO_PRODUCTO" 
   (	"VALOR" NUMBER, 
	"PRODUCTO_GTIN" NUMBER, 
	"PRODUCTO_CUENTA_ID" NUMBER, 
	"ATRIBUTO_ID" NUMBER, 
	"ATRIBUTO_CUENTA_ID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table CATEGORIA
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."CATEGORIA" 
   (	"ID" NUMBER, 
	"NOMBRE" VARCHAR2(30 CHAR), 
	"CUENTA_ID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table CATEGORIA_ACTIVO
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."CATEGORIA_ACTIVO" 
   (	"ID" NUMBER, 
	"NOMBRE" VARCHAR2(30 CHAR), 
	"CUENTA_ID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table CATEGORIA_PRODUCTO
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."CATEGORIA_PRODUCTO" 
   (	"CATEGORIA_ID" NUMBER, 
	"CATEGORIA_CUENTA_ID" NUMBER, 
	"PRODUCTO_GTIN" NUMBER, 
	"PRODUCTO_CUENTA_ID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table CUENTA
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."CUENTA" 
   (	"ID" NUMBER, 
	"NOMBRE" VARCHAR2(50 CHAR), 
	"DIRECCIONFISCAL" VARCHAR2(50 CHAR) ENCRYPT USING 'AES192' 'SHA-1', 
	"NIF" VARCHAR2(30 BYTE) ENCRYPT USING 'AES192' 'SHA-1', 
	"FECHAALTA" DATE, 
	"PLAN_ID" NUMBER, 
	"USUARIO_ID" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table PLAN
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."PLAN" 
   (	"ID" NUMBER, 
	"NOMBRE" VARCHAR2(30 CHAR), 
	"PRODUCTOS" NUMBER, 
	"ACTIVOS" NUMBER, 
	"ALMACENAMIENTO" VARCHAR2(50 BYTE), 
	"CATEGORIASPRODUCTO" NUMBER, 
	"CATEGORIASACTIVOS" NUMBER, 
	"RELACIONES" NUMBER, 
	"PRECIOANUAL" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table PRODUCTO
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."PRODUCTO" 
   (	"GTIN" NUMBER, 
	"SKU" VARCHAR2(40 CHAR), 
	"NOMBRE" VARCHAR2(50 CHAR), 
	"MINIATURA" BLOB, 
	"TEXTOCORTO" VARCHAR2(150 CHAR), 
	"CREADO" DATE, 
	"MODIFICADO" DATE, 
	"CUENTA_ID" NUMBER, 
	"PUBLICO" CHAR(1 BYTE) DEFAULT 'S'
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_PLYTIX" 
 LOB ("MINIATURA") STORE AS SECUREFILE "MINIATURA_LOB"(
  TABLESPACE "TS_INDICES" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES ) ;
--------------------------------------------------------
--  DDL for Table PRODUCTO_ACTIVO
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."PRODUCTO_ACTIVO" 
   (	"PRODUCTO_GTIN" NUMBER, 
	"PRODUCTO_CUENTA_ID" NUMBER, 
	"ACTIVO_ID" NUMBER, 
	"ACTIVO_CUENTA_ID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table PRODUCTOS_EXT
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."PRODUCTOS_EXT" 
   (	"SKU" VARCHAR2(40 CHAR), 
	"NOMBRE" VARCHAR2(50 CHAR), 
	"TEXTOCORTO" VARCHAR2(150 CHAR), 
	"CREADO" DATE, 
	"CUENTA_ID" NUMBER
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "DIRECTORIO_EXT"
      ACCESS PARAMETERS
      ( RECORDS DELIMITED BY NEWLINE 
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
      LOCATION
       ( 'productos.csv'
       )
    )
   REJECT LIMIT 0 ;
--------------------------------------------------------
--  DDL for Table RELACIONADO
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."RELACIONADO" 
   (	"NOMBRE" VARCHAR2(30 CHAR), 
	"SENTIDO" VARCHAR2(30 CHAR), 
	"PRODUCTO_GTIN" NUMBER, 
	"PRODUCTO_CUENTA_ID" NUMBER, 
	"PRODUCTO_RELACIONADO_GTIN" NUMBER, 
	"PRODUCTO_RELACIONADO_CUENTA_ID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table TRAZA
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."TRAZA" 
   (	"FECHA" DATE, 
	"USUARIO" VARCHAR2(40 BYTE), 
	"CAUSANTE" VARCHAR2(40 BYTE), 
	"DESCRIPCION" VARCHAR2(500 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "TS_PLYTIX" ;
--------------------------------------------------------
--  DDL for Table USUARIO
--------------------------------------------------------

  CREATE TABLE "PLYTIX"."USUARIO" 
   (	"ID" NUMBER, 
	"NOMBREUSUARIO" VARCHAR2(30 CHAR), 
	"NOMBRECOMPLETO" VARCHAR2(50 CHAR), 
	"AVATAR" BLOB ENCRYPT USING 'AES192' 'SHA-1', 
	"CORREOELECTRONICO" VARCHAR2(50 CHAR) ENCRYPT USING 'AES192' 'SHA-1', 
	"TELEFONO" VARCHAR2(20 CHAR) ENCRYPT USING 'AES192' 'SHA-1', 
	"CUENTA_ID" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_PLYTIX" 
 LOB ("AVATAR") STORE AS SECUREFILE "AVATAR_LOB"(
  TABLESPACE "TS_INDICES" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  ENCRYPT USING 'AES192' 'SHA-1' NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
--------------------------------------------------------
--  DDL for View V_PRODUCTO_PUBLICO
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PLYTIX"."V_PRODUCTO_PUBLICO" ("GTIN", "SKU", "NOMBRE", "MINIATURA", "TEXTOCORTO", "CREADO", "MODIFICADO", "CUENTA_ID", "PUBLICO") AS 
  SELECT "GTIN","SKU","NOMBRE","MINIATURA","TEXTOCORTO","CREADO","MODIFICADO","CUENTA_ID","PUBLICO" FROM producto WHERE PUBLICO = 'S'
;
--------------------------------------------------------
--  DDL for Materialized View VM_PRODUCTOS
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "PLYTIX"."VM_PRODUCTOS" ("SKU", "NOMBRE", "TEXTOCORTO", "CREADO", "CUENTA_ID")
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_PLYTIX" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT TRUNC(SYSDATE + 1)
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT * FROM PRODUCTOS_EXT;

   COMMENT ON MATERIALIZED VIEW "PLYTIX"."VM_PRODUCTOS"  IS 'snapshot table for snapshot PLYTIX.VM_PRODUCTOS';
REM INSERTING into PLYTIX.ACTIVO
SET DEFINE OFF;
REM INSERTING into PLYTIX.ACTIVO_CATEGORIA_ACT
SET DEFINE OFF;
REM INSERTING into PLYTIX.ATRIBUTO
SET DEFINE OFF;
REM INSERTING into PLYTIX.ATRIBUTO_PRODUCTO
SET DEFINE OFF;
REM INSERTING into PLYTIX.CATEGORIA
SET DEFINE OFF;
REM INSERTING into PLYTIX.CATEGORIA_ACTIVO
SET DEFINE OFF;
REM INSERTING into PLYTIX.CATEGORIA_PRODUCTO
SET DEFINE OFF;
REM INSERTING into PLYTIX.CUENTA
SET DEFINE OFF;
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
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('94','Digital Marketing Pros','Calle Serrano, 22, Madrid','W5816604',to_date('23/02/20','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('95','Fresh Foods Market','Calle Mayor, 5, Valencia','V0667415',to_date('07/12/20','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('96','Bright Future Education','Calle Mayor, 5, Valencia','W0649640',to_date('08/12/21','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('97','Health First Medical','Calle Larios, 10, Málaga','S6333699',to_date('16/04/21','DD/MM/RR'),'4',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('98','Luxury Living Estates','Calle Gran Vía, 28, Madrid','G5195031',to_date('10/02/22','DD/MM/RR'),'2',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('99','Eco-Friendly Products','Calle de Alcalá, 45, Madrid','S5182179',to_date('21/01/22','DD/MM/RR'),'1',null);
Insert into PLYTIX.CUENTA (ID,NOMBRE,DIRECCIONFISCAL,NIF,FECHAALTA,PLAN_ID,USUARIO_ID) values ('100','Digital Marketing Pros','Avenida Diagonal, 20, Barcelona','V7437021',to_date('18/01/23','DD/MM/RR'),'4',null);
REM INSERTING into PLYTIX.PLAN
SET DEFINE OFF;
Insert into PLYTIX.PLAN (ID,NOMBRE,PRODUCTOS,ACTIVOS,ALMACENAMIENTO,CATEGORIASPRODUCTO,CATEGORIASACTIVOS,RELACIONES,PRECIOANUAL) values ('1','Free','100','200','1GB','3','3','3','0');
Insert into PLYTIX.PLAN (ID,NOMBRE,PRODUCTOS,ACTIVOS,ALMACENAMIENTO,CATEGORIASPRODUCTO,CATEGORIASACTIVOS,RELACIONES,PRECIOANUAL) values ('2','Basic','1000','20000','50GB','10','10','5','7000');
Insert into PLYTIX.PLAN (ID,NOMBRE,PRODUCTOS,ACTIVOS,ALMACENAMIENTO,CATEGORIASPRODUCTO,CATEGORIASACTIVOS,RELACIONES,PRECIOANUAL) values ('3','Enterprise','100000','100000','200GB','1000','1000','10','50000');
Insert into PLYTIX.PLAN (ID,NOMBRE,PRODUCTOS,ACTIVOS,ALMACENAMIENTO,CATEGORIASPRODUCTO,CATEGORIASACTIVOS,RELACIONES,PRECIOANUAL) values ('4','Deluxe','200000','200000','1TB','2000','2000','20','75000');
REM INSERTING into PLYTIX.PRODUCTO
SET DEFINE OFF;
REM INSERTING into PLYTIX.PRODUCTO_ACTIVO
SET DEFINE OFF;
REM INSERTING into PLYTIX.PRODUCTOS_EXT
SET DEFINE OFF;
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
REM INSERTING into PLYTIX.RELACIONADO
SET DEFINE OFF;
REM INSERTING into PLYTIX.TRAZA
SET DEFINE OFF;
REM INSERTING into PLYTIX.USUARIO
SET DEFINE OFF;
--------------------------------------------------------
--  DDL for Index ACTIVO_CATEGORIA_ACT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."ACTIVO_CATEGORIA_ACT_PK" ON "PLYTIX"."ACTIVO_CATEGORIA_ACT" ("ACTIVO_ID", "ACTIVO_CUENTA_ID", "CATEGORIA_ACTIVO_ID", "CATEGORIA_ACTIVO_CUENTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index ACTIVO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."ACTIVO_PK" ON "PLYTIX"."ACTIVO" ("ID", "CUENTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index ATRIBUTO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."ATRIBUTO_PK" ON "PLYTIX"."ATRIBUTO" ("ID", "CUENTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index ATRIBUTO_PRODUCTO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."ATRIBUTO_PRODUCTO_PK" ON "PLYTIX"."ATRIBUTO_PRODUCTO" ("PRODUCTO_GTIN", "ATRIBUTO_ID", "VALOR", "PRODUCTO_CUENTA_ID", "ATRIBUTO_CUENTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index CATEGORIA_ACTIVO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."CATEGORIA_ACTIVO_PK" ON "PLYTIX"."CATEGORIA_ACTIVO" ("ID", "CUENTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index CATEGORIA_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."CATEGORIA_PK" ON "PLYTIX"."CATEGORIA" ("ID", "CUENTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index CATEGORIA_PRODUCTO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."CATEGORIA_PRODUCTO_PK" ON "PLYTIX"."CATEGORIA_PRODUCTO" ("CATEGORIA_ID", "PRODUCTO_GTIN", "CATEGORIA_CUENTA_ID", "PRODUCTO_CUENTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index CUENTA_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."CUENTA_PK" ON "PLYTIX"."CUENTA" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index PLAN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."PLAN_PK" ON "PLYTIX"."PLAN" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index PRODUCTO_ACTIVO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."PRODUCTO_ACTIVO_PK" ON "PLYTIX"."PRODUCTO_ACTIVO" ("PRODUCTO_GTIN", "PRODUCTO_CUENTA_ID", "ACTIVO_ID", "ACTIVO_CUENTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index PRODUCTO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."PRODUCTO_PK" ON "PLYTIX"."PRODUCTO" ("GTIN", "CUENTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index RELACIONADO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."RELACIONADO_PK" ON "PLYTIX"."RELACIONADO" ("PRODUCTO_GTIN", "PRODUCTO_RELACIONADO_GTIN", "PRODUCTO_CUENTA_ID", "PRODUCTO_RELACIONADO_CUENTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index USUARIO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."USUARIO_PK" ON "PLYTIX"."USUARIO" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index CUENTA_IDX
--------------------------------------------------------

  CREATE UNIQUE INDEX "PLYTIX"."CUENTA_IDX" ON "PLYTIX"."CUENTA" ("USUARIO_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index IDX_UPPER_NOMBRECOMPLETO
--------------------------------------------------------

  CREATE INDEX "PLYTIX"."IDX_UPPER_NOMBRECOMPLETO" ON "PLYTIX"."USUARIO" (UPPER("NOMBRECOMPLETO")) 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index IDX_NOMBREUSUARIO
--------------------------------------------------------

  CREATE INDEX "PLYTIX"."IDX_NOMBREUSUARIO" ON "PLYTIX"."USUARIO" ("NOMBREUSUARIO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Index IDX_CUENTA_USUARIO_BITMAP
--------------------------------------------------------

  CREATE BITMAP INDEX "PLYTIX"."IDX_CUENTA_USUARIO_BITMAP" ON "PLYTIX"."USUARIO" ("CUENTA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_INDICES" ;
--------------------------------------------------------
--  DDL for Trigger TR_PRODUCTOS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "PLYTIX"."TR_PRODUCTOS" 
before insert on PRODUCTO for each row 
begin 
    if :new.GTIN is null then  
        :new.GTIN := SEQ_PRODUCTOS.NEXTVAL; 
    end if; 
END TR_PRODUCTOS;
/
ALTER TRIGGER "PLYTIX"."TR_PRODUCTOS" ENABLE;
--------------------------------------------------------
--  DDL for Function F_GESTION_USUARIO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "PLYTIX"."F_GESTION_USUARIO" (p_schema varchar2, p_obj varchar2)
    RETURN varchar2
IS
    VUSUARIO VARCHAR2(100);
BEGIN
    VUSUARIO := SYS_CONTEXT('userenv', 'SESSION_USER');

    IF UPPER(VUSUARIO) IN ('SYSTEM', 'ADMIN') THEN
        RETURN '';
    ELSE
        RETURN 'UPPER(Nombreusuario) = ''' || UPPER(VUSUARIO) || '''';
    END IF;
END;

/
--------------------------------------------------------
--  Constraints for Table CATEGORIA_ACTIVO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."CATEGORIA_ACTIVO" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CATEGORIA_ACTIVO" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CATEGORIA_ACTIVO" MODIFY ("CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CATEGORIA_ACTIVO" ADD CONSTRAINT "CATEGORIA_ACTIVO_PK" PRIMARY KEY ("ID", "CUENTA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Constraints for Table ATRIBUTO_PRODUCTO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."ATRIBUTO_PRODUCTO" MODIFY ("VALOR" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ATRIBUTO_PRODUCTO" MODIFY ("PRODUCTO_GTIN" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ATRIBUTO_PRODUCTO" MODIFY ("PRODUCTO_CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ATRIBUTO_PRODUCTO" MODIFY ("ATRIBUTO_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ATRIBUTO_PRODUCTO" MODIFY ("ATRIBUTO_CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ATRIBUTO_PRODUCTO" ADD CONSTRAINT "ATRIBUTO_PRODUCTO_PK" PRIMARY KEY ("PRODUCTO_GTIN", "ATRIBUTO_ID", "VALOR", "PRODUCTO_CUENTA_ID", "ATRIBUTO_CUENTA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Constraints for Table USUARIO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."USUARIO" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."USUARIO" MODIFY ("NOMBREUSUARIO" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."USUARIO" MODIFY ("NOMBRECOMPLETO" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."USUARIO" MODIFY ("CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."USUARIO" ADD CONSTRAINT "USUARIO_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Constraints for Table CUENTA
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."CUENTA" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CUENTA" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CUENTA" MODIFY ("DIRECCIONFISCAL" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CUENTA" MODIFY ("NIF" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CUENTA" MODIFY ("FECHAALTA" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CUENTA" MODIFY ("PLAN_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CUENTA" ADD CONSTRAINT "CUENTA_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Constraints for Table ATRIBUTO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."ATRIBUTO" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ATRIBUTO" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ATRIBUTO" MODIFY ("CREADO" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ATRIBUTO" MODIFY ("CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ATRIBUTO" ADD CONSTRAINT "ATRIBUTO_PK" PRIMARY KEY ("ID", "CUENTA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Constraints for Table PLAN
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."PLAN" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PLAN" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PLAN" MODIFY ("PRODUCTOS" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PLAN" MODIFY ("ACTIVOS" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PLAN" MODIFY ("ALMACENAMIENTO" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PLAN" MODIFY ("CATEGORIASPRODUCTO" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PLAN" MODIFY ("CATEGORIASACTIVOS" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PLAN" MODIFY ("RELACIONES" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PLAN" MODIFY ("PRECIOANUAL" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PLAN" ADD CONSTRAINT "PLAN_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Constraints for Table PRODUCTOS_EXT
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."PRODUCTOS_EXT" MODIFY ("SKU" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PRODUCTOS_EXT" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PRODUCTOS_EXT" MODIFY ("CUENTA_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PRODUCTO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."PRODUCTO" MODIFY ("GTIN" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PRODUCTO" MODIFY ("SKU" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PRODUCTO" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PRODUCTO" MODIFY ("CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PRODUCTO" ADD CONSTRAINT "PRODUCTO_PK" PRIMARY KEY ("GTIN", "CUENTA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES"  ENABLE;
  ALTER TABLE "PLYTIX"."PRODUCTO" MODIFY ("PUBLICO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ACTIVO_CATEGORIA_ACT
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."ACTIVO_CATEGORIA_ACT" MODIFY ("ACTIVO_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ACTIVO_CATEGORIA_ACT" MODIFY ("CATEGORIA_ACTIVO_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ACTIVO_CATEGORIA_ACT" MODIFY ("ACTIVO_CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ACTIVO_CATEGORIA_ACT" MODIFY ("CATEGORIA_ACTIVO_CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ACTIVO_CATEGORIA_ACT" ADD CONSTRAINT "ACTIVO_CATEGORIA_ACT_PK" PRIMARY KEY ("ACTIVO_ID", "ACTIVO_CUENTA_ID", "CATEGORIA_ACTIVO_ID", "CATEGORIA_ACTIVO_CUENTA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Constraints for Table CATEGORIA_PRODUCTO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."CATEGORIA_PRODUCTO" MODIFY ("CATEGORIA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CATEGORIA_PRODUCTO" MODIFY ("CATEGORIA_CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CATEGORIA_PRODUCTO" MODIFY ("PRODUCTO_GTIN" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CATEGORIA_PRODUCTO" MODIFY ("PRODUCTO_CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CATEGORIA_PRODUCTO" ADD CONSTRAINT "CATEGORIA_PRODUCTO_PK" PRIMARY KEY ("CATEGORIA_ID", "PRODUCTO_GTIN", "CATEGORIA_CUENTA_ID", "PRODUCTO_CUENTA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Constraints for Table RELACIONADO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."RELACIONADO" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."RELACIONADO" MODIFY ("PRODUCTO_GTIN" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."RELACIONADO" MODIFY ("PRODUCTO_CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."RELACIONADO" MODIFY ("PRODUCTO_RELACIONADO_GTIN" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."RELACIONADO" MODIFY ("PRODUCTO_RELACIONADO_CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."RELACIONADO" ADD CONSTRAINT "RELACIONADO_PK" PRIMARY KEY ("PRODUCTO_GTIN", "PRODUCTO_RELACIONADO_GTIN", "PRODUCTO_CUENTA_ID", "PRODUCTO_RELACIONADO_CUENTA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Constraints for Table PRODUCTO_ACTIVO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."PRODUCTO_ACTIVO" MODIFY ("PRODUCTO_GTIN" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PRODUCTO_ACTIVO" MODIFY ("PRODUCTO_CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PRODUCTO_ACTIVO" MODIFY ("ACTIVO_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PRODUCTO_ACTIVO" MODIFY ("ACTIVO_CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."PRODUCTO_ACTIVO" ADD CONSTRAINT "PRODUCTO_ACTIVO_PK" PRIMARY KEY ("PRODUCTO_GTIN", "PRODUCTO_CUENTA_ID", "ACTIVO_ID", "ACTIVO_CUENTA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Constraints for Table ACTIVO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."ACTIVO" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ACTIVO" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ACTIVO" MODIFY ("TAMANO" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ACTIVO" MODIFY ("CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."ACTIVO" ADD CONSTRAINT "ACTIVO_PK" PRIMARY KEY ("ID", "CUENTA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Constraints for Table CATEGORIA
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."CATEGORIA" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CATEGORIA" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CATEGORIA" MODIFY ("CUENTA_ID" NOT NULL ENABLE);
  ALTER TABLE "PLYTIX"."CATEGORIA" ADD CONSTRAINT "CATEGORIA_PK" PRIMARY KEY ("ID", "CUENTA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "TS_INDICES"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ACTIVO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."ACTIVO" ADD CONSTRAINT "ACTIVO_CUENTA_ID_FK" FOREIGN KEY ("CUENTA_ID")
	  REFERENCES "PLYTIX"."CUENTA" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ACTIVO_CATEGORIA_ACT
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."ACTIVO_CATEGORIA_ACT" ADD CONSTRAINT "ACTIVO_CAT_ACT_FK" FOREIGN KEY ("ACTIVO_ID", "ACTIVO_CUENTA_ID")
	  REFERENCES "PLYTIX"."ACTIVO" ("ID", "CUENTA_ID") ENABLE;
  ALTER TABLE "PLYTIX"."ACTIVO_CATEGORIA_ACT" ADD CONSTRAINT "ACT_CATEGORIA_ACTIVO_FK" FOREIGN KEY ("CATEGORIA_ACTIVO_ID", "CATEGORIA_ACTIVO_CUENTA_ID")
	  REFERENCES "PLYTIX"."CATEGORIA_ACTIVO" ("ID", "CUENTA_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ATRIBUTO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."ATRIBUTO" ADD CONSTRAINT "ATRIBUTO_CUENTA_ID_FK" FOREIGN KEY ("CUENTA_ID")
	  REFERENCES "PLYTIX"."CUENTA" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ATRIBUTO_PRODUCTO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."ATRIBUTO_PRODUCTO" ADD CONSTRAINT "ATRIBUTO_PRODUCTO_ATRIBUTO_FK" FOREIGN KEY ("ATRIBUTO_ID", "ATRIBUTO_CUENTA_ID")
	  REFERENCES "PLYTIX"."ATRIBUTO" ("ID", "CUENTA_ID") ENABLE;
  ALTER TABLE "PLYTIX"."ATRIBUTO_PRODUCTO" ADD CONSTRAINT "ATRIBUTO_PRODUCTO_PRODUCTO_FK" FOREIGN KEY ("PRODUCTO_GTIN", "PRODUCTO_CUENTA_ID")
	  REFERENCES "PLYTIX"."PRODUCTO" ("GTIN", "CUENTA_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table CATEGORIA
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."CATEGORIA" ADD CONSTRAINT "CATEGORIA_CUENTA_ID_FK" FOREIGN KEY ("CUENTA_ID")
	  REFERENCES "PLYTIX"."CUENTA" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table CATEGORIA_ACTIVO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."CATEGORIA_ACTIVO" ADD CONSTRAINT "CATEGORIA_ACTIVO_CUENTA_FK" FOREIGN KEY ("CUENTA_ID")
	  REFERENCES "PLYTIX"."CUENTA" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table CATEGORIA_PRODUCTO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."CATEGORIA_PRODUCTO" ADD CONSTRAINT "CATEGORIA_PROD_FK" FOREIGN KEY ("CATEGORIA_ID", "CATEGORIA_CUENTA_ID")
	  REFERENCES "PLYTIX"."CATEGORIA" ("ID", "CUENTA_ID") ENABLE;
  ALTER TABLE "PLYTIX"."CATEGORIA_PRODUCTO" ADD CONSTRAINT "CAT_PRODUCTO_FK" FOREIGN KEY ("PRODUCTO_GTIN", "PRODUCTO_CUENTA_ID")
	  REFERENCES "PLYTIX"."PRODUCTO" ("GTIN", "CUENTA_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table CUENTA
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."CUENTA" ADD CONSTRAINT "CUENTA_PLAN_FK" FOREIGN KEY ("PLAN_ID")
	  REFERENCES "PLYTIX"."PLAN" ("ID") ENABLE;
  ALTER TABLE "PLYTIX"."CUENTA" ADD CONSTRAINT "CUENTA_USUARIO_FK" FOREIGN KEY ("USUARIO_ID")
	  REFERENCES "PLYTIX"."USUARIO" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PRODUCTO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."PRODUCTO" ADD CONSTRAINT "PRODUCTO_CUENTA_ID_FK" FOREIGN KEY ("CUENTA_ID")
	  REFERENCES "PLYTIX"."CUENTA" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PRODUCTO_ACTIVO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."PRODUCTO_ACTIVO" ADD CONSTRAINT "PRODUCTO_ACTIVO_ACTIVO_FK" FOREIGN KEY ("ACTIVO_ID", "ACTIVO_CUENTA_ID")
	  REFERENCES "PLYTIX"."ACTIVO" ("ID", "CUENTA_ID") ENABLE;
  ALTER TABLE "PLYTIX"."PRODUCTO_ACTIVO" ADD CONSTRAINT "PRODUCTO_ACTIVO_PRODUCTO_FK" FOREIGN KEY ("PRODUCTO_GTIN", "PRODUCTO_CUENTA_ID")
	  REFERENCES "PLYTIX"."PRODUCTO" ("GTIN", "CUENTA_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table RELACIONADO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."RELACIONADO" ADD CONSTRAINT "RELACIONADO_PRODUCTO_FK" FOREIGN KEY ("PRODUCTO_GTIN", "PRODUCTO_CUENTA_ID")
	  REFERENCES "PLYTIX"."PRODUCTO" ("GTIN", "CUENTA_ID") ENABLE;
  ALTER TABLE "PLYTIX"."RELACIONADO" ADD CONSTRAINT "PRODUCTO_RELACIONADO_FK" FOREIGN KEY ("PRODUCTO_RELACIONADO_GTIN", "PRODUCTO_RELACIONADO_CUENTA_ID")
	  REFERENCES "PLYTIX"."PRODUCTO" ("GTIN", "CUENTA_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table USUARIO
--------------------------------------------------------

  ALTER TABLE "PLYTIX"."USUARIO" ADD CONSTRAINT "USUARIO_CUENTA_ID_FK" FOREIGN KEY ("CUENTA_ID")
	  REFERENCES "PLYTIX"."CUENTA" ("ID") ENABLE;
