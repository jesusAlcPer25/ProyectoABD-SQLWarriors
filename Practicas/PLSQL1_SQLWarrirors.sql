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

    EXCEPTION EXCEPTION_PLAN_NO_ASIGNADO;
    EXCEPTION INVALID_DATA;
    EXCEPTION EXCEPTION_ASOCIACION_DUPLICADA;
    EXCEPTION EXCEPTION_USUARIO_EXISTE;
    
    FUNCTION F_OBTENER_PLAN_CUENTA
        (
            P_CUENTA_ID IN CUENTA.ID%TYPE
        ) 
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

------------------------------------------------------ Para modificar el cuerpo del paquete --------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY PKG_ADMIN_PRODUCTOS AS

  -- Si se crea una funcion aqui pero no se especifica arriba, la funcion es privada al paquete

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 1
---------------------------------------------------------------------------------------------------------------------------------------------------

    FUNCTION F_OBTENER_PLAN_CUENTA
        (
            P_CUENTA_ID IN CUENTA.ID%TYPE
        ) 
        RETURN PLAN%ROWTYPE 
    AS
        V_PLAN              PLAN%ROWTYPE;
        V_PLAN_ID           PLAN.ID%TYPE;
        -- V_CUENTA            CUENTA%ROWTYPE;
        -- V_CUENTA_CONTADOR   NUMBER;
        V_MENSAJE           VARCHAR2(500);
    BEGIN
        
        BEGIN
            SELECT PLAN INTO V_PLAN_ID
            FROM CUENTA
            WHERE ID = P_CUENTA_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                INSERT INTO TRAZA VALUES (
                    SYSDATE, USER, $$PLSQL_UNIT,
                    'Cuenta no encontrada con ID=' || P_CUENTA_ID
                );
                RAISE;
        END;
        
        /* SELECT COUNT(*) INTO V_CUENTA_CONTADOR 
            FROM CUENTA 
            WHERE ID = P_CUENTA_ID;

        IF V_CUENTA_CONTADOR = 0 THEN
            INSERT INTO TRAZA VALUES (SYSDATE, USER, $$PLSQL_UNIT, SUBSTR(SQLCODE||' '||SQLERRM, 1, 500));
            RAISE NO_DATA_FOUND;
        END IF; */

        IF V_PLAN_ID IS NULL THEN
            INSERT INTO TRAZA VALUES (SYSDATE, USER, $$PLSQL_UNIT, 'Plan no asignado a la cuenta con ID = '||P_CUENTA_ID);
            RAISE EXCEPTION_PLAN_NO_ASIGNADO;
        END IF;

        /* SELECT * INTO V_CUENTA FROM CUENTA WHERE ID = P_CUENTA_ID;
        
        IF V_CUENTA.PLAN IS NULL THEN
            INSERT INTO TRAZA VALUES (SYSDATE, USER, $$PLSQL_UNIT, 'Plan no asignado a la cuenta con ID'||P_CUENTA_ID);
            RAISE EXCEPTION_PLAN_NO_ASIGNADO;
        END IF; */
        
        SELECT * INTO V_PLAN FROM PLAN WHERE ID = V_PLAN_ID;
        
        RETURN V_PLAN;
    EXCEPTION   -- Si ocurre cualquier error lo guardamos en la tabla traza
        WHEN OTHERS THEN 
            INSERT INTO TRAZA VALUES (
                SYSDATE,                                    -- Fecha
                USER,                                       -- Usuario
                $$PLSQL_UNIT,                               -- Causante
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500)      -- Descripcion
            );
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error
    END F_OBTENER_PLAN_CUENTA;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 2
---------------------------------------------------------------------------------------------------------------------------------------------------

    FUNCTION F_CONTAR_PRODUCTOS_CUENTA
        ( 
            P_CUENTA_ID IN CUENTA.ID%TYPE
        ) 
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
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500)      -- Descripcion
            );
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error
    END F_CONTAR_PRODUCTOS_CUENTA;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 3
---------------------------------------------------------------------------------------------------------------------------------------------------

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
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500)      -- Descripcion
            );
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error
    
    END F_VALIDAR_ATRIBUTOS_PRODUCTO;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 4
---------------------------------------------------------------------------------------------------------------------------------------------------

    FUNCTION F_NUM_CATEGORIAS_CUENTA( p_cuenta_id IN CUENTA.ID%TYPE ) 
        RETURN NUMBER 
    IS
        V_TOTAL             NUMBER;
        V_CUENTA            CUENTA%ROWTYPE;
        V_MENSAJE           VARCHAR2(500);
    BEGIN
        
        SELECT * INTO V_CUENTA FROM CUENTA WHERE ID = P_CUENTA_ID;
        
        IF V_CUENTA IS NULL THEN
            RAISE NO_DATA_FOUND;
        END IF;

        SELECT COUNT(*) INTO V_TOTAL
            FROM CATEGORIA
            WHERE CUENTA_ID = p_cuenta_id;

        RETURN V_TOTAL;

    EXCEPTION
        WHEN OTHERS THEN 
            INSERT INTO TRAZA VALUES (
                SYSDATE,                                    -- Fecha
                USER,                                       -- Usuario
                $$PLSQL_UNIT,                               -- Causante
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500)      -- Descripcion
            );
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error

    END F_NUM_CATEGORIAS_CUENTA;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 5
---------------------------------------------------------------------------------------------------------------------------------------------------

    PROCEDURE P_ACTUALIZAR_NOMBRE_PRODUCTO(
        P_PRODUCTO_GTIN IN PRODUCTO.GTIN%TYPE,
        p_cuenta_id     IN PRODUCTO.CUENTA_ID%TYPE,
        p_nuevo_nombre  IN PRODUCTO.NOMBRE%TYPE
    ) 
    IS
        V_AUX           PRODUCTO.GTIN%TYPE;
        V_MENSAJE       VARCHAR2(500);
    BEGIN

        SELECT GTIN INTO V_AUX
            FROM PRODUCTO
            WHERE GTIN = P_PRODUCTO_GTIN AND CUENTA_ID = P_CUENTA_ID;

        IF V_AUX IS NULL THEN 
            RAISE NO_DATA_FOUND;
        END IF;
    
        IF p_nuevo_nombre IS NULL OR TRIM(p_nuevo_nombre) = '' THEN
        RAISE INVALID_DATA;
        END IF;

        UPDATE PRODUCTO
            SET NOMBRE = p_nuevo_nombre
            WHERE GTIN = P_PRODUCTO_GTIN AND CUENTA_ID = p_cuenta_id;

    EXCEPTION
        WHEN OTHERS THEN 
            INSERT INTO TRAZA VALUES (
                SYSDATE,                                    -- Fecha
                USER,                                       -- Usuario
                $$PLSQL_UNIT,                               -- Causante
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500)      -- Descripcion
            );
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error

    END P_ACTUALIZAR_NOMBRE_PRODUCTO;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 6
---------------------------------------------------------------------------------------------------------------------------------------------------

    PROCEDURE P_ASOCIAR_ACTIVO_A_PRODUCTO(
        p_producto_gtin        IN PRODUCTO.GTIN%TYPE,
        p_producto_cuenta_id   IN PRODUCTO.CUENTA_ID%TYPE,
        p_activo_id            IN ACTIVOS.ID%TYPE,
        p_activo_cuenta_id     IN ACTIVOS.CUENTA_ID%TYPE
    ) IS
        V_AUX           PRODUCTO.GTIN%TYPE;
        V_GTIN          PRODUCTO.GTIN%TYPE;
        V_ACTIVO        ACTIVO.ID%TYPE;
        v_mensaje       VARCHAR2(500);
    BEGIN

        SELECT GTIN, CUENTA_ID INTO V_GTIN
            FROM PRODUCTO
            WHERE GTIN = P_PRODUCTO_GTIN AND CUENTA_ID = p_producto_cuenta_id;

        SELECT ID INTO V_ACTIVO
            FROM ACTIVO
            WHERE P_ACTIVO_ID = P_ACTIVO_CUENTA_ID;

        IF V_GTIN IS NULL OR V_ACTIVO IS NULL THEN 
            RAISE NO_DATA_FOUND;
        END IF;
        
-------------------------------------- PREGUNTAR PROFE --------------------------------------
        BEGIN
            SELECT PRODUCTO_GTIN, ACTIVO_ID INTO V_AUX
                FROM PROD_ACT
                WHERE PRODUCTO_GTIN = p_producto_gtin AND ACTIVO_ID = p_activo_id;
            
            RAISE EXCEPTION_ASOCIACION_DUPLICADA;

        EXCEPTION
            WHEN EXCEPTION_ASOCIACION_DUPLICADA THEN 
                RAISE;
        END;
---------------------------------------------------------------------------------------------

        INSERT INTO PROD_ACT (PRODUCTO_GTIN, ACTIVO_ID)
            VALUES (p_producto_gtin, p_activo_id);

    EXCEPTION
        WHEN OTHERS THEN 
            INSERT INTO TRAZA VALUES (
                SYSDATE,                                    -- Fecha
                USER,                                       -- Usuario
                $$PLSQL_UNIT,                               -- Causante
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500)      -- Descripcion
            );
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error

    END P_ASOCIAR_ACTIVO_A_PRODUCTO;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 7
---------------------------------------------------------------------------------------------------------------------------------------------------

    PROCEDURE P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES(
        p_producto_gtin     IN PRODUCTO.GTIN%TYPE,
        p_cuenta_id         IN PRODUCTO.CUENTA_ID%TYPE
    ) IS
        V_AUX               PRODUCTO.GTIN%TYPE;
        v_mensaje           VARCHAR2(500);
    BEGIN
        SELECT GTIN INTO V_AUX
        FROM PRODUCTO
        WHERE GTIN = p_producto_gtin AND CUENTA_ID = p_cuenta_id;

        IF V_AUX IS NULL THEN 
            RAISE NO_DATA_FOUND;
        END IF;

        DELETE FROM ACT_PRO
        WHERE PRODUCTO_GTIN = p_producto_gtin;

        DELETE FROM ATRIBUTO_PRODUCTO
        WHERE PRODUCTO_GTIN = p_producto_gtin AND CUENTA_ID = p_cuenta_id;

        DELETE FROM PROD_CAT
        WHERE PRODUCTO_GTIN = p_producto_gtin;

        DELETE FROM RELACIONADO
        WHERE PRODUCTO1 = p_producto_gtin OR PRODUCTO2 = p_producto_gtin;

        DELETE FROM PRODUCTO
        WHERE GTIN = p_producto_gtin AND CUENTA_ID = p_cuenta_id;

    EXCEPTION
        WHEN OTHERS THEN 
            INSERT INTO TRAZA VALUES (
                SYSDATE,                                    -- Fecha
                USER,                                       -- Usuario
                $$PLSQL_UNIT,                               -- Causante
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500)      -- Descripcion
            );
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error

    END P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 8
---------------------------------------------------------------------------------------------------------------------------------------------------

    PROCEDURE P_ACTUALIZAR_PRODUCTOS( p_cuenta_id IN CUENTA.ID%TYPE )
    IS
        CURSOR cur_productos
        IS
            SELECT GTIN, CUENTA_ID
            FROM PRODUCTO_EXT
            WHERE CUENTA_ID = p_cuenta_id;

        V_AUX               PRODUCTO.GTIN%TYPE;
        V_AUX_2             PRODUCTO.NOMBRE%TYPE;
        v_gtin              PRODUCTO.GTIN%TYPE;
        v_cuenta_id         PRODUCTO.CUENTA_ID%TYPE;
        V_NOMBRE            PRODUCTO.NOMBRE%TYPE;
        v_mensaje           VARCHAR2(500);
    BEGIN
        FOR prod IN cur_productos LOOP
            v_gtin := prod.GTIN;
            v_cuenta_id := prod.CUENTA_ID;
            V_NOMBRE := prod.NOMBRE;

            BEGIN
                SELECT GTIN INTO V_AUX
                    FROM PRODUCTO
                    WHERE GTIN = v_gtin AND CUENTA_ID = v_cuenta_id;

                SELECT NOMBRE INTO V_AUX_2
                    FROM PRODUCTO
                    WHERE GTIN = v_gtin AND CUENTA_ID = v_cuenta_id;

                IF V_AUX IS NULL THEN
                    INSERT INTO PRODUCTO VALUES(
                        SELECT * FROM cur_productos -- Comprobar si hay que añadir mas parametros a producto
                    );
                ELSIF (NOT V_AUX IS NULL) AND (V_NOMBRE != V_AUX_2) THEN
                    P_ACTUALIZAR_NOMBRE_PRODUCTO(v_gtin, v_cuenta_id, V_NOMBRE);
                ELSE
                    P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES(v_gtin, v_cuenta_id);
                END IF;
                
            EXCEPTION
                WHEN OTHERS THEN 
                    INSERT INTO TRAZA VALUES (
                        SYSDATE,                                    -- Fecha
                        USER,                                       -- Usuario
                        $$PLSQL_UNIT,                               -- Causante
                        SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500)      -- Descripcion
                    );
                    V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
                    DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
                    RAISE;                                          -- Para propagar yo el error
            END;

        END LOOP;
        
    END P_ACTUALIZAR_PRODUCTOS;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 9
---------------------------------------------------------------------------------------------------------------------------------------------------

    PROCEDURE P_CREAR_USUARIO(
        p_usuario         IN USUARIO%ROWTYPE,
        p_rol             IN VARCHAR2,
        p_password        IN VARCHAR2
    ) IS
        V_AUX     USUARIO.ID%TYPE;
        v_mensaje   VARCHAR2(500);
    BEGIN
        SELECT ID INTO V_AUX
            FROM USUARIO
            WHERE ID = p_id;

        IF NOT V_AUX IS NULL THEN
            RAISE EXCEPTION_USUARIO_EXISTE;
        END IF;

        BEGIN
            SELECT ID INTO V_AUX
                FROM USUARIO
                WHERE EMAIL = p_usuario.EMAIL;

            IF NOT V_AUX IS NULL THEN
                RAISE EXCEPTION_USUARIO_EXISTE;
            END IF;
        END;

        IF (p_usuario.ID IS NULL) OR (p_usuario.NOMBRE_USUARIO IS NULL) OR (p_usuario.NOMBRECOMPLETO IS NULL) OR (p_usuario.CUENTA_ID IS NULL) THEN
            RAISE INVALID_DATA;
        END IF;

        -- Insertar nuevo usuario
        INSERT INTO USUARIO(ID, NOMBRE_USUARIO, NOMBRECOMPLETO, AVATAR, EMAIL, TELEFONO, CUENTA_ID)
        VALUES (p_usuario.ID, p_usuario.NOMBRE_USUARIO, p_usuario.NOMBRECOMPLETO, p_usuario.AVATAR, p_usuario.EMIAL, p_usuario.TELEFONO, p_usuario.CUENTA_ID);

    EXCEPTION
        WHEN OTHERS THEN 
            INSERT INTO TRAZA VALUES (
                SYSDATE,                                    -- Fecha
                USER,                                       -- Usuario
                $$PLSQL_UNIT,                               -- Causante
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500)      -- Descripcion
            );
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error

    END P_CREAR_USUARIO;

----------------------------------------------------------------------------------------------------------------------------------------------------

END;
/
