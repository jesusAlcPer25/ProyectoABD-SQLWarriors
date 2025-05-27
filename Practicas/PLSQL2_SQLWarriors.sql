CREATE OR REPLACE PACKAGE PKG_ADMIN_PRODUCTOS_AVANZADO AS

    EXCEPTION EXCEPTION_PLAN_NO_ASIGNADO;

    FUNCTION F_VALIDAR_PLAN_SUFICIENTE(p_cuenta_id IN CUENTA.ID%TYPE)
        RETURN VARCHAR2;

    FUNCTION F_LISTA_CATEGORIAS_PRODUCTO(
                                        p_producto_gtin IN PRODUCTO.GTIN%TYPE,
                                        p_cuenta_id IN PRODUCTO.CUENTA_ID%TYPE
                                        ) RETURN VARCHAR2;

    PROCEDURE P_MIGRAR_PRODUCTOS_A_CATEGORIA(
                                            p_cuenta_id IN CUENTA.ID%TYPE, 
                                            p_categoria_origen_id IN CATEGORIA.ID%TYPE,
                                            p_categoria_destino_id IN CATEGORIA.ID%TYPE
                                            );

    PROCEDURE  P_REPLICAR_ATRIBUTOS(
                                    p_cuenta_id IN CUENTA.ID%TYPE, 
                                    p_producto_gtin_origen IN PRODUCTO.GTIN%TYPE,
                                    p_producto_gtin_destino IN PRODUCTO.GTIN%TYPE
                                    );    
END;
/

------------------------------------------------------ Para modificar el cuerpo del paquete --------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY PKG_ADMIN_PRODUCTOS AS

  -- Si se crea una funcion aqui pero no se especifica arriba, la funcion es privada al paquete

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 1
---------------------------------------------------------------------------------------------------------------------------------------------------

    FUNCTION F_VALIDAR_PLAN_SUFICIENTE(P_CUENTA_ID IN CUENTA.ID%TYPE) 
        RETURN VARCHAR2 
    AS
        V_PLAN                          PLAN%ROWTYPE;
        V_CUENTA                        CUENTA.ID%TYPE:

        V_NUM_PRODUCTOS                 NUMBER;
        V_NUM_ACTIVOS                   NUMBER;
        V_NUM_CATEGORIAS_PRODUCTO       NUMBER;
        V_NUM_CATEGORIAS_ACTIVO         NUMBER;
        V_NUM_RELACIONES                NUMBER;

        V_MENSAJE            VARCHAR2(500);
    BEGIN
        SELECT ID INTO V_CUENTA
            FROM CUENTA
            WHERE ID = P_CUENTA_ID;

        IF V_CUENTA IS NULL THEN
            RAISE NO_DATA_FOUND;
        END IF;

        V_PLAN := F_OBTENER_PLAN_CUENTA(P_CUENTA_ID);

        IF V_PLAN IS NULL THEN
            EXCEPTION_PLAN_NO_ASIGNADO;
        END IF;

        SELECT COUNT(*) INTO V_NUM_PRODUCTOS
            FROM PRODUCTO
            WHERE CUENTA_ID = P_CUENTA_ID;

        SELECT COUNT(*) INTO V_NUM_ACTIVOS
            FROM ACTIVO
            WHERE CUENTA_ID = P_CUENTA_ID;

        SELECT COUNT(*) INTO V_NUM_CATEGORIAS_PRODUCTO
            FROM CATEGORIA_PRODUCTO
            WHERE CUENTA_ID = P_CUENTA_ID;

        SELECT COUNT(*) INTO V_NUM_CATEGORIAS_ACTIVO
            FROM CATEGORIA_ACTIVO
            WHERE CUENTA_ID = P_CUENTA_ID;

        SELECT COUNT(*) INTO V_NUM_RELACIONES
            FROM RELACION
            WHERE CUENTA_ID = P_CUENTA_ID;

        IF V_NUM_PRODUCTOS > V_PLAN.PRODUCTOS THEN
            RETURN 'INSUFICIENTE: PRODUCTOS';
        ELSIF V_NUM_ACTIVOS > V_PLAN.ACTIVOS THEN
            RETURN 'INSUFICIENTE: ACTIVOS';
        ELSIF V_NUM_CATEGORIAS_PRODUCTO > V_PLAN.CATEGORIASPRODUCTO THEN
            RETURN 'INSUFICIENTE: CATEGORIAS_PRODUCTO';
        ELSIF V_NUM_CATEGORIAS_ACTIVO > V_PLAN.CATEGORIAS_ACTIVOS THEN
            RETURN 'INSUFICIENTE: CATEGORIAS_ACTIVOS';
        ELSIF V_NUM_RELACIONES > V_PLAN.RELACIONES THEN
            RETURN 'INSUFICIENTE: RELACIONES';
        ELSE
            RETURN 'SUFICIENTE';
        END IF;
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

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 2
---------------------------------------------------------------------------------------------------------------------------------------------------

    FUNCTION F_LISTA_CATEGORIAS_PRODUCTO(
        p_producto_gtin IN PRODUCTO.GTIN%TYPE,
        p_cuenta_id IN PRODUCTO.CUENTA_ID%TYPE
    )
        RETURN VARCHAR2;
    IS
        V_LISTA_CATEGORIAS VARCHAR2(1000) := '';

        CURSOR C_CATEGORIAS IS
            SELECT CP.NOMBRE
            FROM PROD_CAT PC
            JOIN CATEGORIA_PRODUCTO CP ON CP.ID = PC.CATEGORIA_ID
            WHERE PC.PRODUCTO_GTIN = p_producto_gtin AND CP.CUENTA_ID = p_cuenta_id;

        V_CATEGORIA_NOMBRE CATEGORIA_PRODUCTO.NOMBRE%TYPE;
        
        V_PRODUCTO PRODUCTO%ROWTYPE;

        V_MENSAJE VARCHAR2(500);
    BEGIN
        SELECT GTIN, CUENTA_ID INTO V_PRODUCTO
            FROM PRODUCTO
            WHERE GTIN = p_producto_gtin AND CUENTA_ID = p_cuenta_id;
        
        IF V_PRODUCTO IS NULL THEN
            RAISE NO_DATA_FOUND;
        END IF;

        FOR CATEGORIA IN C_CATEGORIAS LOOP
            IF V_LISTA_CATEGORIAS IS NOT NULL AND V_LISTA_CATEGORIAS != '' THEN
                V_LISTA_CATEGORIAS := V_LISTA_CATEGORIAS || ' ; ';
            END IF;

            V_LISTA_CATEGORIAS := V_LISTA_CATEGORIAS || CATEGORIA.NOMBRE;
        END LOOP;

        IF V_LISTA_CATEGORIAS IS NULL OR V_LISTA_CATEGORIAS = '' THEN
            RETURN 'Sin categoría';
        ELSE
            RETURN V_LISTA_CATEGORIAS;
        END IF;

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
    END F_LISTA_CATEGORIAS_PRODUCTO;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 3
---------------------------------------------------------------------------------------------------------------------------------------------------

    PROCEDURE P_MIGRAR_PRODUCTOS_A_CATEGORIA(
        p_cuenta_id             IN CUENTA.ID%TYPE,
        p_categoria_origen_id   IN CATEGORIA.ID%TYPE,
        p_categoria_destino_id  IN CATEGORIA.ID%TYPE
    )
    AS
        V_CUENTA                CUENTA.ID%TYPE;
        V_CAT_ORIGEN            CATEGORIA.ID%TYPE;
        V_CAT_DESTINO           CATEGORIA.ID%TYPE;
        V_MENSAJE               VARCHAR2(500);

        CURSOR C_PRODUCTOS IS
            SELECT PC.PRODUCTO_GTIN
            FROM PROD_CAT PC
            JOIN CATEGORIA C ON C.ID = PC.CATEGORIA_ID
            WHERE PC.CATEGORIA_ID = p_categoria_origen_id
            AND C.CUENTA_ID = p_cuenta_id
            FOR UPDATE;

    BEGIN
        SELECT ID INTO V_CUENTA
            FROM CUENTA
            WHERE ID = P_CUENTA_ID;
        
        SELECT ID INTO V_CAT_ORIGEN
            FROM CATEGORIA
            WHERE ID = P_CATEGORIA_ORIGEN_ID AND CUENTA_ID = P_CUENTA_ID;

        SELECT ID INTO V_CAT_DESTINO
            FROM CATEGORIA
            WHERE ID = P_CATEGORIA_DESTINO_ID AND CUENTA_ID = P_CUENTA_ID;

        IF (V_CUENTA IS NULL) OR (V_CAT_ORIGEN IS NULL) OR (V_CAT_DESTINO IS NULL) THEN
            RAISE NO_DATA_FOUND;
        END IF;

        FOR producto IN c_productos LOOP
            DELETE FROM PROD_CAT
            WHERE PRODUCTO_GTIN = producto.PRODUCTO_GTIN AND CATEGORIA_ID = p_categoria_origen_id;

            INSERT INTO PROD_CAT(PRODUCTO_GTIN, CATEGORIA_ID)VALUES (producto.PRODUCTO_GTIN, p_categoria_destino_id);
        END LOOP;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            INSERT INTO TRAZA VALUES (
                SYSDATE,                                    -- Fecha
                USER,                                       -- Usuario
                $$PLSQL_UNIT,                               -- Causante
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500));    -- Descripcion
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE; 
    END P_MIGRAR_PRODUCTOS_A_CATEGORIA;

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 4
---------------------------------------------------------------------------------------------------------------------------------------------------

    PROCEDURE P_REPLICAR_ATRIBUTOS(
        p_cuenta_id             IN CUENTA.ID%TYPE,
        p_producto_gtin_origen  IN PRODUCTO.GTIN%TYPE,
        p_producto_gtin_destino IN PRODUCTO.GTIN%TYPE
    )
    AS
        V_PRODUCTO_ORIGEN       PRODUCTO.GTIN%TYPE;
        V_PRODUCTO_DESTINO      PRODUCTO.GTIN%TYPE;
        V_ATRIBUTO_AUX          ATRIBUTO_PRODUCTO.ID%TYPE;
        V_MENSAJE               VARCHAR2(500);

        CURSOR C_ATRIBUTOS_ORIGEN IS
            SELECT *
            FROM ATRIBUTO_PRODUCTO
            WHERE PRODUCTO_GTIN = p_producto_gtin_origen;

        v_atributo ATRIBUTO_PRODUCTO%ROWTYPE;

    BEGIN
        -- Verificar existencia de producto origen
        SELECT GTIN, CUENTA_ID INTO V_PRODUCTO_ORIGEN
        FROM PRODUCTO
        WHERE GTIN = p_producto_gtin_origen AND CUENTA_ID = p_cuenta_id;

        SELECT GTIN, CUENTA_ID INTO V_PRODUCTO_DESTINO
        FROM PRODUCTO
        WHERE GTIN = p_producto_gtin_destino AND CUENTA_ID = p_cuenta_id;

        IF (V_PRODUCTO_ORIGEN IS NULL) OR (V_PRODUCTO_ORIGEN) THEN
            RAISE NO_DATA_FOUND;
        END IF;

        FOR v_atributo IN C_ATRIBUTOS_ORIGEN LOOP
            SELECT PRODUCTO_GTIN, CODIGO_ATRIBUTO INTO V_ATRIBUTO_AUX
            FROM ATRIBUTO_PRODUCTO
            WHERE PRODUCTO_GTIN = p_producto_gtin_destino AND CODIGO_ATRIBUTO = v_atributo.CODIGO_ATRIBUTO;

            IF V_ATRIBUTO_AUX IS NULL THEN
                INSERT INTO ATRIBUTO_PRODUCTO (PRODUCTO_GTIN, CODIGO_ATRIBUTO, VALOR) VALUES (p_producto_gtin_destino, v_atributo.CODIGO_ATRIBUTO, v_atributo.VALOR);
            ELSE
                UPDATE ATRIBUTO_PRODUCTO
                    SET VALOR = v_atributo.VALOR
                    WHERE PRODUCTO_GTIN = p_producto_gtin_destino AND CODIGO_ATRIBUTO = v_atributo.CODIGO_ATRIBUTO;
            END IF;
        END LOOP;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            INSERT INTO TRAZA VALUES (
                SYSDATE,                                    -- Fecha
                USER,                                       -- Usuario
                $$PLSQL_UNIT,                               -- Causante
                SQLCODE||' '||SUBSTR(SQL_ERRM, 1, 500));    -- Descripcion
            V_MENSAJE := SUBSTR(SQLCODE||' '||SQLERRM, 1, 500);
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_MENSAJE);   -- Muestra el error por terminal
            RAISE; 
    END P_REPLICAR_ATRIBUTOS;

----------------------------------------------------------------------------------------------------------------------------------------------------