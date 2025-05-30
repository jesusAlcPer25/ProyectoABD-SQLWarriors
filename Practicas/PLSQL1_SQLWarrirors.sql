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
    
    PROCEDURE P_BORRAR_USUARIO
        (
            p_usuario IN USUARIO%ROWTYPE
        );

END;
/

------------------------------------------------------ Para modificar el cuerpo del paquete --------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY PKG_ADMIN_PRODUCTOS AS

  -- Si se crea una funcion aqui pero no se especifica arriba, la funcion es privada al paquete

    PROCEDURE LOG_ERROR (p_mensaje IN VARCHAR2)
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO TRAZA VALUES (SYSDATE, USER, $$PLSQL_UNIT, p_mensaje);
        COMMIT;
    END LOG_ERROR;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 1
---------------------------------------------------------------------------------------------------------------------------------------------------

    FUNCTION F_OBTENER_PLAN_CUENTA (
        P_CUENTA_ID IN CUENTA.ID%TYPE
    ) 
        RETURN PLAN%ROWTYPE 
    AS
        V_PLAN              PLAN%ROWTYPE;
        V_PLAN_ID           NUMBER;
    BEGIN
        BEGIN
            SELECT COUNT(*) INTO V_PLAN_ID
            FROM CUENTA
            WHERE ID = P_CUENTA_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                LOG_ERROR('Cuenta no encontrada con ID=' || P_CUENTA_ID);
                RAISE;
        END;

        IF V_PLAN_ID == 0 THEN
            LOG_ERROR('Plan no asignado a la cuenta con ID = '||P_CUENTA_ID);
            RAISE EXCEPTION_PLAN_NO_ASIGNADO;
        END IF;
        
        SELECT * INTO V_PLAN FROM PLAN WHERE ID = V_PLAN_ID;
        
        RETURN V_PLAN;
        
    EXCEPTION   -- Si ocurre cualquier error lo guardamos en la tabla traza
        WHEN OTHERS THEN 
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SUBSTR(SQLCODE||' '||SQLERRM, 1, 500));   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error
    END F_OBTENER_PLAN_CUENTA;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 2
---------------------------------------------------------------------------------------------------------------------------------------------------

    FUNCTION F_CONTAR_PRODUCTOS_CUENTA ( 
        P_CUENTA_ID IN CUENTA.ID%TYPE
    ) 
        RETURN NUMBER 
    IS
        V_TOTAL     NUMBER;
        V_CUENTA    NUMBER;
    BEGIN
        
        SELECT COUNT(*) INTO V_CUENTA 
        FROM CUENTA 
        WHERE ID = P_CUENTA_ID;
        
        IF V_CUENTA == 0 THEN
            LOG_ERROR('Cuenta no encontrada con ID=' || P_CUENTA_ID);
            RAISE NO_DATA_FOUND;
        END IF;
        
        SELECT COUNT(*) INTO V_TOTAL
            FROM PRODUCTO
            WHERE CUENTA_ID = P_CUENTA_ID;
    
        RETURN V_TOTAL;

    EXCEPTION
        WHEN OTHERS THEN 
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SUBSTR(SQLCODE||' '||SQLERRM, 1, 500));   -- Muestra el error por terminal
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
    BEGIN
    
        SELECT GTIN INTO V_AUX
            FROM PRODUCTO
            WHERE GTIN = P_PRODUCTO_GTIN AND CUENTA_ID = P_CUENTA_ID;

        IF V_AUX IS NULL THEN
            LOG_ERROR('Cuenta no encontrada con ID=' || P_CUENTA_ID);
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
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SUBSTR(SQLCODE||' '||SQLERRM, 1, 500));   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error
    
    END F_VALIDAR_ATRIBUTOS_PRODUCTO;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 4
---------------------------------------------------------------------------------------------------------------------------------------------------

    FUNCTION F_NUM_CATEGORIAS_CUENTA ( 
        p_cuenta_id IN CUENTA.ID%TYPE
    ) 
        RETURN NUMBER 
    IS
        V_TOTAL             NUMBER;
        V_CUENTA            CUENTA%ROWTYPE;
    BEGIN
        
        SELECT * INTO V_CUENTA FROM CUENTA WHERE ID = P_CUENTA_ID;
        
        IF V_CUENTA IS NULL THEN
            LOG_ERROR('Cuenta no encontrada con ID=' || P_CUENTA_ID);
            RAISE NO_DATA_FOUND;
        END IF;

        SELECT COUNT(*) INTO V_TOTAL
            FROM CATEGORIA
            WHERE CUENTA_ID = p_cuenta_id;

        RETURN V_TOTAL;

    EXCEPTION
        WHEN OTHERS THEN 
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SUBSTR(SQLCODE||' '||SQLERRM, 1, 500));   -- Muestra el error por terminal
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
    ) IS
        V_GTIN          PRODUCTO.GTIN%TYPE;
    BEGIN

        SELECT GTIN INTO V_GTIN
            FROM PRODUCTO
            WHERE GTIN = P_PRODUCTO_GTIN AND CUENTA_ID = P_CUENTA_ID;

        IF V_GTIN IS NULL THEN
            INSERT INTO TRAZA VALUES (SYSDATE, USER, $$PLSQL_UNIT,'Cuenta no encontrada con ID=' || P_CUENTA_ID);
            RAISE NO_DATA_FOUND;
        END IF;
    
        IF p_nuevo_nombre IS NULL OR TRIM(p_nuevo_nombre) = '' THEN
            INSERT INTO TRAZA VALUES (SYSDATE, USER, $$PLSQL_UNIT,'Nombre introducido nulo = ' || p_nuevo_nombre);
            RAISE INVALID_DATA;
        END IF;

        UPDATE PRODUCTO
            SET NOMBRE = p_nuevo_nombre
            WHERE GTIN = P_PRODUCTO_GTIN AND CUENTA_ID = p_cuenta_id;

    EXCEPTION
        WHEN OTHERS THEN 
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('ERROR: ' ||  SUBSTR(SQLCODE||' '||SQLERRM, 1, 500));   -- Muestra el error por terminal
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
        V_AUX           NUMBER;
        V_GTIN          PRODUCTO.GTIN%TYPE;
        V_ACTIVO_ID     ACTIVO.ID%TYPE;
    BEGIN

        SELECT GTIN, CUENTA_ID INTO V_GTIN
            FROM PRODUCTO
            WHERE GTIN = P_PRODUCTO_GTIN AND CUENTA_ID = p_producto_cuenta_id;

        SELECT ID INTO V_ACTIVO_ID
            FROM ACTIVO
            WHERE P_ACTIVO_ID = P_ACTIVO_CUENTA_ID;

        IF V_GTIN IS NULL OR V_ACTIVO_ID IS NULL THEN
            INSERT INTO TRAZA VALUES (SYSDATE, USER, $$PLSQL_UNIT,'Producto o activo no existente. GTIN = '||V_GTIN|| ' V_ACTIVO = '||V_ACTIVO ); 
            RAISE NO_DATA_FOUND;
        END IF;
        
        BEGIN
            SELECT 1 INTO V_AUX 
                FROM producto_activo
                WHERE PRODUCTO_GTIN = p_producto_gtin
                        AND PRODUCTO_CUENTA_ID = p_producto_cuenta_id
                        AND ACTIVO_ID = p_activo_id
                        AND ACTIVO_CUENTA_ID = p_activo_cuenta_id;

            INSERT INTO TRAZA VALUES (SYSDATE, USER, $$PLSQL_UNIT,'Asociación ya existe entre producto y activo.');

            RAISE EXCEPTION_ASOCIACION_DUPLICADA;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                NULL;   -- No existe la asociación, seguimos
        END;

        INSERT INTO producto_activo (
                producto_gtin, producto_cuenta_id,
                activo_id, activo_cuenta_id
            )
            VALUES (
                p_producto_gtin, p_producto_cuenta_id,
                p_activo_id, p_activo_cuenta_id
            );

    EXCEPTION
        WHEN OTHERS THEN 
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SUBSTR(SQLCODE||' '||SQLERRM, 1, 500));   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error

    END P_ASOCIAR_ACTIVO_A_PRODUCTO;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 7
---------------------------------------------------------------------------------------------------------------------------------------------------

    PROCEDURE P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES (
        p_producto_gtin     IN PRODUCTO.GTIN%TYPE,
        p_cuenta_id         IN PRODUCTO.CUENTA_ID%TYPE
    ) IS
        V_AUX               PRODUCTO.GTIN%TYPE;
    BEGIN
        SELECT GTIN INTO V_AUX
        FROM PRODUCTO
        WHERE GTIN = p_producto_gtin AND CUENTA_ID = p_cuenta_id;

        IF V_AUX IS NULL THEN
            INSERT INTO TRAZA VALUES (SYSDATE, USER, $$PLSQL_UNIT,'Producto no encontrado para eliminar. GTIN = '||V_AUX); 
            RAISE NO_DATA_FOUND;
        END IF;

        DELETE FROM producto_activo
        WHERE PRODUCTO_GTIN = p_producto_gtin AND PRODUCTO_CUENTA_ID = p_cuenta_id;

        DELETE FROM atributo_producto
        WHERE PRODUCTO_GTIN = p_producto_gtin AND CUENTA_ID = p_cuenta_id;

        DELETE FROM categoria_producto
        WHERE PRODUCTO_GTIN = p_producto_gtin AND PRODUCTO_CUENTA_ID = p_cuenta_id; 

        DELETE FROM relacionado
        WHERE (PRODUCTO_GTIN = p_producto_gtin AND PRODUCTO_CUENTA_ID = p_cuenta_id)
            OR (PRODUCTO_RELACIONADO_GTIN = p_producto_gtin AND PRODUCTO_RELACIONADO_CUENTA_ID = p_cuenta_id);

        DELETE FROM producto
        WHERE GTIN = p_producto_gtin AND CUENTA_ID = p_cuenta_id;

    EXCEPTION
        WHEN OTHERS THEN 
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SUBSTR(SQLCODE||' '||SQLERRM, 1, 500));   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error

    END P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 8
---------------------------------------------------------------------------------------------------------------------------------------------------

    PROCEDURE P_ACTUALIZAR_PRODUCTOS (
        p_cuenta_id IN CUENTA.ID%TYPE 
    )
    IS
        CURSOR cur_ext IS
            SELECT SKU, NOMBRE, TEXTOCORTO, CREADO
            FROM PRODUCTOS_EXT
            WHERE CUENTA_ID = p_cuenta_id;

        CURSOR cur_eliminar IS
            SELECT GTIN, SKU
            FROM PRODUCTO
            WHERE CUENTA_ID = p_cuenta_id
            AND SKU NOT IN ( SELECT SKU FROM PRODUCTOS_EXT WHERE CUENTA_ID = p_cuenta_id );

        v_prod_gtin          PRODUCTO.GTIN%TYPE;
        v_prod_nombre        PRODUCTO.NOMBRE%TYPE;

    BEGIN
       -- 1. Inserción o actualización
        FOR prod_ex IN cur_ext LOOP
            BEGIN

                SELECT GTIN, NOMBRE INTO v_prod_gtin, v_prod_nombre
                FROM PRODUCTO
                WHERE SKU = prod_ex.SKU AND CUENTA_ID = p_cuenta_id;

                IF prod_ex.NOMBRE != v_prod_nombre THEN
                    P_ACTUALIZAR_NOMBRE_PRODUCTO(v_prod_gtin, p_cuenta_id, prod_ex.NOMBRE);
                END IF;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    INSERT INTO PRODUCTO ( GTIN, SKU, NOMBRE, TEXTOCORTO, CREADO, CUENTA_ID )
                        VALUES (
                            prod_ex.SKU, prod_ex.NOMBRE, prod_ex.TEXTOCORTO, prod_ex.CREADO, p_cuenta_id
                        );
                WHEN OTHERS THEN
                    LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
                    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SUBSTR(SQLCODE || ' ' || SQLERRM, 1, 500));
                    RAISE;
            END;
        END LOOP;

        -- 2. Eliminacion productos que no estén en producto_ext
        FOR prod IN cur_eliminar LOOP
            BEGIN

                P_ELIMINAR_PRODUCTO_Y_ASOCIACIONES(prod.GTIN, p_cuenta_id);
                
            EXCEPTION
                WHEN OTHERS THEN
                    LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
                    DBMS_OUTPUT.PUT_LINE('ERROR AL ELIMINAR: ' || SUBSTR(SQLCODE || ' ' || SQLERRM, 1, 500));
                    RAISE;
            END;
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN 
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SUBSTR(SQLCODE||' '||SQLERRM, 1, 500));   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error
        
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
        v_sql               VARCHAR2(500);
        v_mensaje           VARCHAR2(500);
    BEGIN
        -- Crear usuario 
        v_sql := 'CREATE USER ' || p_usuario.nombreusuario || 
             ' IDENTIFIED BY "' || p_password || '" DEFAULT TABLESPACE TS_PLYTIX ';
        EXECUTE IMMEDIATE v_sql;

        -- Asignacion de rol
        v_sql := 'GRANT ' || p_rol || ' TO ' || p_usuario.nombreusuario;
        EXECUTE IMMEDIATE v_sql;

        IF (p_usuario.ID IS NULL) OR (p_usuario.NOMBREUSUARIO IS NULL) OR (p_usuario.NOMBRECOMPLETO IS NULL) OR (p_usuario.CUENTA_ID IS NULL) THEN
            LOG_ERROR(
                    'Valores nulos en campos NOT NULL. ID= '||p_usuario.ID||
                    'NombreUsuario= '||p_usuario.nombreusuario||
                    'NombreCompleto= '||p_usuario.NOMBRECOMPLETO||
                    'Cuenta_id= '||p_usuario.CUENTA_ID
            );
            RAISE INVALID_DATA;
        END IF;

        -- Insertar nuevo usuario
        INSERT INTO USUARIO VALUES p_usuario;

    EXCEPTION
        WHEN OTHERS THEN 
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error

    END P_CREAR_USUARIO;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 10: Extra 
---------------------------------------------------------------------------------------------------------------------------------------------------

    PROCEDURE P_BORRAR_USUARIO(
        p_usuario         IN USUARIO%ROWTYPE
    ) IS
        v_sql               VARCHAR2(500);
    BEGIN
        -- Crear usuario 
        v_sql := 'DROP USER '|| p_usuario|| ' CASCADE';
        EXECUTE IMMEDIATE v_sql;

    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SUBSTR(SQLCODE||' '||SQLERRM, 1, 500));   -- Muestra el error por terminal
            RAISE;                                          -- Para propagar yo el error

    END P_BORRAR_USUARIO;

----------------------------------------------------------------------------------------------------------------------------------------------------

END;
/
