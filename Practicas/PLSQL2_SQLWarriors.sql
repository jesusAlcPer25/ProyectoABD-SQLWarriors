CREATE OR REPLACE PACKAGE PKG_ADMIN_PRODUCTOS_AVANZADO AS

    EXCEPTION EXCEPTION_PLAN_NO_ASIGNADO;

    FUNCTION F_VALIDAR_PLAN_SUFICIENTE
        (
            p_cuenta_id IN CUENTA.ID%TYPE
        )
        RETURN VARCHAR2;

    FUNCTION F_LISTA_CATEGORIAS_PRODUCTO
        (
            p_producto_gtin IN PRODUCTO.GTIN%TYPE,
            p_cuenta_id IN PRODUCTO.CUENTA_ID%TYPE
        )
        RETURN VARCHAR2;

    PROCEDURE P_MIGRAR_PRODUCTOS_A_CATEGORIA
        (
            p_cuenta_id IN CUENTA.ID%TYPE, 
            p_categoria_origen_id IN CATEGORIA.ID%TYPE,
            p_categoria_destino_id IN CATEGORIA.ID%TYPE
        );

    PROCEDURE P_REPLICAR_ATRIBUTOS
        (
            p_cuenta_id IN CUENTA.ID%TYPE, 
            p_producto_gtin_origen IN PRODUCTO.GTIN%TYPE,
            p_producto_gtin_destino IN PRODUCTO.GTIN%TYPE
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

    FUNCTION F_VALIDAR_PLAN_SUFICIENTE(P_CUENTA_ID IN CUENTA.ID%TYPE) 
        RETURN VARCHAR2 
    AS
        V_PLAN                          PLAN%ROWTYPE;
        V_CUENTA                        CUENTA.ID%TYPE;

        V_NUM_PRODUCTOS                 NUMBER;
        V_NUM_ACTIVOS                   NUMBER;
        V_NUM_CATEGORIAS_PRODUCTO       NUMBER;
        V_NUM_CATEGORIAS_ACTIVOS        NUMBER;
        V_NUM_RELACIONES                NUMBER;

        V_LIM_PRODUCTOS                 PLAN.PRODUCTOS%TYPE;
        V_LIM_ACTIVOS                   PLAN.ACTIVOS%TYPE;
        V_LIM_CATEGORIAS_PRODUCTO       PLAN.CATEGORIASPRODUCTO%TYPE;
        V_LIM_CATEGORIAS_ACTIVOS        PLAN.CATEGORIASACTIVOS%TYPE;
        V_LIM_RELACIONES                PLAN.RELACIONES%TYPE;

    BEGIN
    -- Comprobacion de que la cuenta existe y tiene un plan asociado
        SELECT ID INTO V_CUENTA
            FROM CUENTA
            WHERE ID = P_CUENTA_ID;

        IF V_CUENTA IS NULL THEN
            LOG_ERROR('Cuenta no encontrada con ID=' || P_CUENTA_ID);
            RAISE NO_DATA_FOUND;
        END IF;

        V_PLAN := F_OBTENER_PLAN_CUENTA(P_CUENTA_ID);

        IF V_PLAN IS NULL THEN
            LOG_ERROR('Plan no asignado a la cuenta con ID = '||P_CUENTA_ID);
            RAISE EXCEPTION_PLAN_NO_ASIGNADO;
        END IF;

    -- Carga de limites del plan asociado
        SELECT PRODUCTOS, ACTIVOS, CATEGORIASPRODUCTO, CATEGORIASACTIVOS, RELACIONES
        INTO V_LIM_PRODUCTOS, V_LIM_ACTIVOS, V_LIM_CATEGORIAS_PRODUCTO, V_LIM_CATEGORIAS_ACTIVOS, V_LIM_RELACIONES
        FROM PLAN 
        WHERE ID = V_PLAN.ID;

    -- Carga de conteos reales
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
            FROM RELACIONADO
            WHERE CUENTA_ID = P_CUENTA_ID;
            
    -- Comparaciones
        IF V_NUM_PRODUCTOS > V_LIM_PRODUCTOS THEN
            RETURN 'INSUFICIENTE: PRODUCTOS';
        ELSIF V_NUM_ACTIVOS > V_LIM_ACTIVOS THEN
            RETURN 'INSUFICIENTE: ACTIVOS';
        ELSIF V_NUM_CATEGORIAS_PRODUCTO > V_LIM_CATEGORIAS_PRODUCTO THEN
            RETURN 'INSUFICIENTE: CATEGORIAS_PRODUCTO';
        ELSIF V_NUM_CATEGORIAS_ACTIVOS > V_LIM_CATEGORIAS_ACTIVOS THEN
            RETURN 'INSUFICIENTE: CATEGORIAS_ACTIVOS';
        ELSIF V_NUM_RELACIONES > V_LIM_RELACIONES THEN
            RETURN 'INSUFICIENTE: RELACIONES';
        ELSE
            RETURN 'SUFICIENTE';
        END IF;

    EXCEPTION   -- Si ocurre cualquier error lo guardamos en la tabla traza
        WHEN OTHERS THEN 
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));   -- Muestra el error por terminal
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
        RETURN VARCHAR2
    IS
        CURSOR CUR_CATEGORIAS IS
            SELECT C.NOMBRE
            FROM CATEGORIA C
            JOIN CATEGORIA_PRODUCTO CP
            ON CP.CATEGORIA_ID = C.ID AND CP.CATEGORIA_CUENTA_ID = C.CUENTA_ID
            WHERE CP.PRODUCTO_GTIN = p_producto_gtin AND CP.PRODUCTO_CUENTA_ID = p_cuenta_id;

        V_LISTA_CATEGORIAS      VARCHAR2(1000) := '';
        V_FIRST                 BOOLEAN := TRUE;
        V_PRODUCTO              PRODUCTO%ROWTYPE;

    BEGIN
    -- Comprobacion de que el producto existe
        BEGIN
            SELECT GTIN, CUENTA_ID INTO V_PRODUCTO
            FROM PRODUCTO
            WHERE GTIN = p_producto_gtin AND CUENTA_ID = p_cuenta_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                LOG_ERROR('Producto no encontrado con ID =' || p_cuenta_id || ' y GTIN = '|| p_producto_gtin);
                RAISE;
        END;
    -- Obtencion de las categorias a las que pertenece un producto
        FOR CATEGORIA IN CUR_CATEGORIAS LOOP
            IF V_FIRST THEN 
                V_LISTA_CATEGORIAS := CATEGORIA.NOMBRE;
                V_FIRST := FALSE;
            ELSE
                V_LISTA_CATEGORIAS := V_LISTA_CATEGORIAS || ' ; ' || CATEGORIA.NOMBRE;
            END IF;

        END LOOP;
    -- Devolución según si está vacía o no
        IF V_LISTA_CATEGORIAS IS NULL OR V_LISTA_CATEGORIAS = '' THEN
            RETURN 'Sin categoría';
        ELSE
            RETURN V_LISTA_CATEGORIAS;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));   -- Muestra el error por terminal
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
        CURSOR CUR_PRODUCTOS IS
            SELECT CP.PRODUCTO_GTIN
            FROM categoria_producto CP
            JOIN CATEGORIA C ON C.ID = CP.CATEGORIA_ID
            WHERE CP.CATEGORIA_ID = p_categoria_origen_id
            AND C.CUENTA_ID = p_cuenta_id
            FOR UPDATE;

       /*  V_CUENTA                CUENTA.ID%TYPE;
        V_CAT_ORIGEN            CATEGORIA.ID%TYPE;
        V_CAT_DESTINO           CATEGORIA.ID%TYPE; */

    BEGIN
    -- Validación: cuenta
        DECLARE
            V_AUX       NUMBER;
        BEGIN
            SELECT 1 INTO V_AUX FROM CUENTA WHERE ID = p_cuenta_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                LOG_ERROR('Cuenta no encontrada con ID=' || p_cuenta_id);
                RAISE;
        END;
    -- Validación: categoría origen
        DECLARE
            V_AUX       NUMBER;
        BEGIN
            SELECT 1 INTO V_AUX 
            FROM CATEGORIA 
            WHERE ID = p_categoria_origen_id AND CUENTA_ID = p_cuenta_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                LOG_ERROR('Categoría de origen no encontrada o no pertenece a la cuenta. ID = ' || p_categoria_origen_id);
                RAISE;
        END;
    -- Validación: categoría destino
        DECLARE
            V_AUX       NUMBER;
        BEGIN
            SELECT 1 INTO V_AUX 
            FROM CATEGORIA 
            WHERE ID = p_categoria_destino_id AND CUENTA_ID = p_cuenta_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                LOG_ERROR('Categoría de destino no encontrada o no pertenece a la cuenta. ID = ' || p_categoria_destino_id);
                RAISE;
        END;
/* 
        SELECT ID INTO V_CUENTA
            FROM CUENTA
            WHERE ID = p_cuenta_id;
        
        SELECT ID INTO V_CAT_ORIGEN
            FROM CATEGORIA
            WHERE ID = P_CATEGORIA_ORIGEN_ID AND CUENTA_ID = p_cuenta_id;

        SELECT ID INTO V_CAT_DESTINO
            FROM CATEGORIA
            WHERE ID = P_CATEGORIA_DESTINO_ID AND CUENTA_ID = p_cuenta_id;

        IF (V_CUENTA IS NULL) OR (V_CAT_ORIGEN IS NULL) OR (V_CAT_DESTINO IS NULL) THEN
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            RAISE NO_DATA_FOUND;
        END IF; 
*/
    -- Obtención de productos y actualización de la categoría
        FOR producto IN CUR_PRODUCTOS LOOP
            UPDATE categoria_producto
            SET CATEGORIA_ID = p_categoria_destino_id
            WHERE CATEGORIA_ID = p_categoria_origen_id
                AND CATEGORIA_CUENTA_ID = p_cuenta_id
                AND PRODUCTO_GTIN = producto.PRODUCTO_GTIN
                AND PRODUCTO_CUENTA_ID = producto.PRODUCTO_CUENTA_ID;
            /* DELETE FROM categoria_producto
            WHERE PRODUCTO_GTIN = producto.PRODUCTO_GTIN AND CATEGORIA_ID = p_categoria_origen_id;

            INSERT INTO PROD_CAT(PRODUCTO_GTIN, CATEGORIA_ID)VALUES (producto.PRODUCTO_GTIN, p_categoria_destino_id);
             */
        END LOOP;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            LOG_ERROR(SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLCODE || ' ' || SUBSTR(SQLERRM, 1, 500));   -- Muestra el error por terminal
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
        CURSOR CUR_ATRIBUTOS_ORIGEN IS
            SELECT ATRIBUTO_ID, ATRIBUTO_CUENTA_ID, VALOR
            FROM ATRIBUTO_PRODUCTO
            WHERE PRODUCTO_GTIN = p_producto_gtin_origen AND PRODUCTO_CUENTA_ID = p_cuenta_id
            FOR UPDATE;

        v_valor_origen          ATRIBUTO_PRODUCTO.VALOR%TYPE;
        /* V_PRODUCTO_ORIGEN       PRODUCTO.GTIN%TYPE;
        V_PRODUCTO_DESTINO      PRODUCTO.GTIN%TYPE;
        V_ATRIBUTO_AUX          ATRIBUTO_PRODUCTO.ID%TYPE;
        v_atributo              ATRIBUTO_PRODUCTO%ROWTYPE; */

    BEGIN
    -- Verificar existencia de producto origen
        DECLARE
            V_AUX       NUMBER;
        BEGIN
            SELECT 1 INTO V_AUX
            FROM PRODUCTO
            WHERE GTIN = p_producto_gtin_origen AND CUENTA_ID = p_cuenta_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                LOG_ERROR('Producto de origen no encontrado. GTIN = ' || p_producto_gtin_origen);
                RAISE;
        END;
    -- Verificar existencia de producto destino
        DECLARE
            V_AUX       NUMBER;
        BEGIN
            SELECT 1 INTO V_AUX
            FROM PRODUCTO
            WHERE GTIN = p_producto_gtin_destino AND CUENTA_ID = p_cuenta_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                LOG_ERROR('Producto de destino no encontrado. GTIN = ' || p_producto_gtin_destino);
                RAISE;
        END;

    -- Obtención de atributos y réplica
        FOR atr IN CUR_ATRIBUTOS_ORIGEN LOOP
            BEGIN

                SELECT VALOR INTO v_valor_origen
                FROM ATRIBUTO_PRODUCTO
                WHERE PRODUCTO_GTIN = p_producto_gtin_destino AND PRODUCTO_CUENTA_ID = p_cuenta_id
                    AND ATRIBUTO_ID = atr.ATRIBUTO_ID AND ATRIBUTO_CUENTA_ID = atr.ATRIBUTO_CUENTA_ID;
                -- Actualización
                UPDATE ATRIBUTO_PRODUCTO
                SET VALOR = atr.VALOR
                WHERE PRODUCTO_GTIN = p_producto_gtin_destino AND PRODUCTO_CUENTA_ID = p_cuenta_id
                    AND ATRIBUTO_ID = atr.ATRIBUTO_ID AND ATRIBUTO_CUENTA_ID = atr.ATRIBUTO_CUENTA_ID;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                -- Inserción si no existe
                    INSERT INTO ATRIBUTO_PRODUCTO (VALOR, PRODUCTO_GTIN, PRODUCTO_CUENTA_ID, ATRIBUTO_ID, ATRIBUTO_CUENTA_ID) 
                    VALUES (atr.VALOR, p_producto_gtin_destino, p_cuenta_id, atr.ATRIBUTO_ID, atr.ATRIBUTO_CUENTA_ID);
            END;
        END LOOP;

        COMMIT;

        /* SELECT GTIN, CUENTA_ID INTO V_PRODUCTO_ORIGEN
        FROM PRODUCTO
        WHERE GTIN = p_producto_gtin_origen AND CUENTA_ID = p_cuenta_id;

        SELECT GTIN, CUENTA_ID INTO V_PRODUCTO_DESTINO
        FROM PRODUCTO
        WHERE GTIN = p_producto_gtin_destino AND CUENTA_ID = p_cuenta_id;

        IF (V_PRODUCTO_ORIGEN IS NULL) OR (V_PRODUCTO_ORIGEN) THEN
            RAISE NO_DATA_FOUND;
        END IF; */
        /* FOR v_atributo IN CUR_ATRIBUTOS_ORIGEN LOOP
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
        END LOOP; */
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            LOG_ERROR('Error replicando atributos: ' || SQLCODE || ' - ' || SUBSTR(SQLERRM, 1, 500));
            DBMS_OUTPUT.PUT_LINE('Error replicando atributos: ' || SQLCODE || ' - ' || SUBSTR(SQLERRM, 1, 500));   -- Muestra el error por terminal
            RAISE; 
    END P_REPLICAR_ATRIBUTOS;

----------------------------------------------------------------------------------------------------------------------------------------------------

END;
/

----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 5
---------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE P_LIMPIA_TRAZA IS
BEGIN
    DELETE FROM traza WHERE fecha < SYSDATE - 365;  -- Más de un año
    COMMIT;
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'J_LIMPIA_TRAZA',
        job_type        => 'STORED_PROCEDURE',
        job_action      => 'P_LIMPIA_TRAZA',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY;BYHOUR=3;BYMINUTE=0',
        enabled         => TRUE,
        comments        => 'Elimina registros de la tabla TRAZA con más de un año.'
    );

    DBMS_SCHEDULER.ENABLE('J_LIMPIA_TRAZA');
END;
/


----------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 6
---------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'J_ACTUALIZA_PRODUCTOS',
        job_type        => 'STORED_PROCEDURE',
        job_action      => 'PKG_ADMIN_PRODUCTOS.P_ACTUALIZAR_PRODUCTOS',
        number_of_arguments => 1,
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=WEEKLY;BYDAY=SUN;BYHOUR=2;BYMINUTE=0',
        enabled         => FALSE,  -- Lo habilitamos luego de definir el parámetro
        comments        => 'Actualiza la tabla de productos desde PRODUCTOS_EXT'
    );

    -- Definir el parámetro p_cuenta_id, por ejemplo, para la cuenta 1
    DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
        job_name  => 'J_ACTUALIZA_PRODUCTOS',
        argument_position => 1,
        argument_value    => '1'
    );

    -- Habilitar el job
    DBMS_SCHEDULER.ENABLE('J_ACTUALIZA_PRODUCTOS');
END;
/