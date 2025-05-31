-- 1. Comprobar si hay datos suficientes para integridad referencial
    DBMS_OUTPUT.PUT_LINE('1. Datos para integridad referencial:');
    BEGIN
        -- Verificar que hay datos en tablas relacionadas
        SELECT COUNT(*) INTO v_count FROM producto WHERE cuenta_id IN (SELECT id FROM cuenta);
        
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Existen ' || v_count || ' productos con cuentas válidas');
            v_passed_count := v_passed_count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('No hay datos suficientes para comprobar integridad');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al verificar: ' || SQLERRM);
    END;

    -- 2. Comprobar mayúsculas/minúsculas en objetos
    DBMS_OUTPUT.PUT_LINE('2. Mayúsculas/minúsculas en objetos:');
    BEGIN
        SELECT COUNT(*) INTO v_count FROM user_objects 
        WHERE object_type IN ('PROCEDURE','FUNCTION','PACKAGE','TRIGGER') 
        AND REGEXP_LIKE(object_name, '^[A-Z]');
        
        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Todos los objetos tienen nombres en minúsculas');
            v_passed_count := v_passed_count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Hay ' || v_count || ' objetos con mayúsculas');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al verificar: ' || SQLERRM);
    END;

    -- 3. Comprobar elementos adicionales
    DBMS_OUTPUT.PUT_LINE('3. Elementos adicionales:');
    BEGIN
        v_count := 0;
        
        -- Verificar triggers adicionales
        SELECT COUNT(*) INTO v_count FROM user_triggers 
        WHERE trigger_name NOT LIKE 'BIN$%'  -- Excluir objetos en papelera
        AND trigger_name NOT IN (SELECT trigger_name FROM user_triggers WHERE base_object_type = 'TABLE');
        
        -- Verificar vistas adicionales
        SELECT COUNT(*) + v_count INTO v_count FROM user_views 
        WHERE view_name NOT LIKE 'BIN$%';
        
        -- Verificar jobs adicionales
        SELECT COUNT(*) + v_count INTO v_count FROM user_scheduler_jobs;
        
        IF v_count >= 2 THEN  -- Considerando que al menos 2 elementos adicionales son requeridos
            DBMS_OUTPUT.PUT_LINE('Existen ' || v_count || ' elementos adicionales (triggers, vistas, jobs)');
            v_passed_count := v_passed_count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Solo hay ' || v_count || ' elementos adicionales');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al verificar: ' || SQLERRM);
    END;

    -- Resultado final
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
    DBMS_OUTPUT.PUT_LINE('RESULTADO FINAL:');
    DBMS_OUTPUT.PUT_LINE(v_passed_count || ' de ' || v_total_tests || ' pruebas pasadas');
    
    IF v_passed_count = v_total_tests THEN
        DBMS_OUTPUT.PUT_LINE('TODOS LOS PUNTOS DE MISCELÁNEA CUMPLIDOS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('HAY PUNTOS PENDIENTES EN MISCELÁNEA');
    END IF;
END;
/