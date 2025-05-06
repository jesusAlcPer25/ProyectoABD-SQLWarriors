-- Tabla de traza (LOG) 
CREATE TABLE TRAZA 
    (
        Fecha Date,
        Usuario VARCHAR2(40),
        Causante VARCHAR2(40), 
        Descripcion VARCHAR2(500) 
    )
    TABLESPACE TS_PLYTIX
;

-- Nombre del paquete: PKG_ADMIN_PRODUCTOS

-- 1. 
CREATE OR REPLACE FUNCTION 
    F_OBTENER_PLAN_CUENTA(P_CUENTA_ID IN CUENTA.ID%TYPE) 
        RETURN PLAN%ROWTYPE -- Registro completo de la tabla PLAN
AS
    -- ZONA DECLARE
BEGIN
    NULL;
    -- EXCEPTION ...
END;
/
---------------- Para crear el paquete ------------------------------
CREATE OR REPLACE PACKAGE PKG_ADMIN_PRODUCTOS AS

    EXCEPTION EXCEPTION_PLAN_NO_ASIGNADO;   -- To do
    
    FUNCTION F_OBTENER_PLAN_CUENTA(P_CUENTA_ID IN CUENTA.ID%TYPE) 
        RETURN PLAN%ROWTYPE;

    FUNCTION F_CONTAR_PRODUCTOS_CUENTA
        (
            P_CUENTA_ID IN CUENTA.ID%TYPE
        ) 
        RETURN NUMBER;

    FUNCTION F_VALIDAR_ATRIBUTOS_PRODUCTO
        (
            P_PRODUCTO_GTIN IN PRODUCTO.GTIN%TYPE, 
            P_CUENTA_ID IN PRODUCTO.CUENTA_ID%TYPE
        ) 
        RETURN BOOLEAN;

    FUNCTION F_NUM_CATEGORIAS_CUENTA
        (
            P_CUENTA_ID IN CUENTA.ID%TYPE
        ) 
        RETURN NUMBER;

    PROCEDURE P_ACTUALIZAR_NOMBRE_PRODUCTO
        (
            P_PRODUCTO_GTIN IN PRODUCTO.GTIN%TYPE, 
            P_CUENTA_ID IN PRODUCTO.CUENTA_ID%TYPE,
            p_nuevo_nombre IN PRODUCTO.NOMBRE%TYPE
        );

    PROCEDURE P_ASOCIAR_ACTIVO_A_PRODUCTO
        (
            P_PRODUCTO_GTIN IN PRODUCTO.GTIN%TYPE, 
            p_producto_cuenta_id IN PRODUCTO.CUENTA_ID%TYPE,
            p_activo_id IN ACTIVOS.ID%TYPE,
            p_activo_cuenta_id IN ACTIVOS.CUENTA_ID%TYPE
        );
    
    PROCEDURE P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES
        (
            P_PRODUCTO_GTIN IN PRODUCTO.GTIN%TYPE,
            P_CUENTA_ID IN PRODUCTO.CUENTA_ID%TYPE
        );

    PROCEDURE P_CREAR_USUARIO
        (
            p_usuario IN USUARIO%ROWTYPE, 
            p_rol IN VARCHAR, 
            p_password IN VARCHAR
        );

    PROCEDURE P_ACTUALIZAR_PRODUCTOS
        (
            P_CUENTA_ID IN CUENTA.ID%TYPE
        );


END;
/

---------------- Para modificar el cuerpo del paquete ---------------
CREATE OR REPLACE PACKAGE BODY PKG_ADMIN_PRODUCTOS AS

  -- Si se crea una funcion aqui pero no se especifica arriba, la funcion es privada al paquete

  FUNCTION F_OBTENER_PLAN_CUENTA(P_CUENTA_ID IN CUENTA.ID%TYPE) 
        RETURN PLAN%ROWTYPE 
    AS
        V_PLAN              PLAN%ROWTYPE;
        V_CUENTA            CUENTA%ROWTYPE;
        V_CUENTA_CONTADOR   NUMBER;
        V_MENSAJE           VARCHAR2(500);
    BEGIN
        SELECT COUNT(*) INTO V_CUENTA_CONTADOR 
            FROM CUENTA WHERE ID = P_CUENTA_ID
            FOR UPDATE;

        IF V_CUENTA_CONTADOR = 0 THEN
            -- INSERT INTO TRAZA VALUES (SYSDATE, USER, $$PLSQL_UNIT, SUBSTR(SQLCODE||' '||SQLERRM, 1, 500));
            RAISE NO_DATA_FOUND;
        END IF;

        SELECT * INTO V_CUENTA FROM CUENTA WHERE ID = P_CUENTA_ID;
        
        IF V_CUENTA.PLAN IS NULL THEN
            -- INSERT INTO TRAZA VALUES (SYSDATE, USER, $$PLSQL_UNIT, 'Plan no asignado a la cuenta con ID'||P_CUENTA_ID);
            RAISE EXCEPTION_PLAN_NO_ASIGNADO;
        END IF;
        
        SELECT * INTO V_PLAN FROM PLAN WHERE ID = V_CUENTA.PLAN;
        
        RETURN V_PLAN;
    EXCEPTION   -- Si ocurre cualquier error lo guardamos en la tabla traza
        WHEN OTHERS THEN 
            INSERT INTO TRAZA VALUES (
                SYSDATE,                                    -- Fecha
                USER,                                       -- Usuario
                $$PLSQL_UNIT,                               -- Causante
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500));    -- Descripcion
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error
    END F_OBTENER_PLAN_CUENTA;

-----------------------------------------------------------------------------------------------------------

    FUNCTION F_CONTAR_PRODUCTOS_CUENTA( P_CUENTA_ID IN CUENTA.ID%TYPE ) 
        RETURN NUMBER 
    IS
        V_TOTAL     NUMBER;
        V_CUENTA    CUENTA%ROWTYPE;
        V_MENSAJE   VARCHAR2(500);
    BEGIN
        
        SELECT * INTO V_CUENTA FROM CUENTA WHERE ID = P_CUENTA_ID;
        
        IF V_CUENTA IS NULL THEN
            RAISE NO_DATA_FOUND;
        END IF;
        
        SELECT COUNT(*) INTO V_TOTAL
            FROM PRODUCTO
            WHERE CUENTA_ID = P_CUENTA_ID;
    
        RETURN V_TOTAL;

    EXCEPTION
        WHEN OTHERS THEN
            INSERT INTO TRAZA VALUES (
                SYSDATE,                                    -- Fecha
                USER,                                       -- Usuario
                $$PLSQL_UNIT,                               -- Causante
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500));    -- Descripcion
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error
    END F_CONTAR_PRODUCTOS_CUENTA;

-----------------------------------------------------------------------------------------------------------

    FUNCTION F_VALIDAR_ATRIBUTOS_PRODUCTO(
        P_PRODUCTO_GTIN IN PRODUCTO.GTIN%TYPE,
        P_CUENTA_ID     IN PRODUCTO.CUENTA_ID%TYPE
    ) 
        RETURN BOOLEAN 
    IS
        V_TOTAL_ATRIBUTOS       NUMBER;
        V_ATRIBUTOS_CON_VALOR   NUMBER;
        V_AUX                   PRODUCTO.GTIN%TYPE;
        V_MENSAJE               VARCHAR2(500);
    BEGIN
    
        SELECT GTIN INTO V_AUX
            FROM PRODUCTO
            WHERE GTIN = P_PRODUCTO_GTIN AND CUENTA_ID = P_CUENTA_ID;

        IF V_AUX IS NULL THEN 
            RAISE NO_DATA_FOUND;
        END IF;

        SELECT COUNT(*) INTO V_TOTAL_ATRIBUTOS
            FROM ATRIBUTOS;

        SELECT COUNT(DISTINCT ATRIBUTO_ID) INTO V_ATRIBUTOS_CON_VALOR
            FROM ATRIBUTO_PRODUCTO
            WHERE PRODUCTO_GTIN = P_PRODUCTO_GTIN AND CUENTA_ID = P_CUENTA_ID;

        RETURN V_TOTAL_ATRIBUTOS = V_ATRIBUTOS_CON_VALOR;

    EXCEPTION
        WHEN OTHERS THEN
            INSERT INTO TRAZA VALUES (
                SYSDATE,                                    -- Fecha
                USER,                                       -- Usuario
                $$PLSQL_UNIT,                               -- Causante
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500));    -- Descripcion
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error
    
    END F_VALIDAR_ATRIBUTOS_PRODUCTO;

-----------------------------------------------------------------------------------------------------------









-----------------------------------------------------------------------------------------------------------










-----------------------------------------------------------------------------------------------------------










-----------------------------------------------------------------------------------------------------------









-----------------------------------------------------------------------------------------------------------








-----------------------------------------------------------------------------------------------------------







-----------------------------------------------------------------------------------------------------------



END;
/
