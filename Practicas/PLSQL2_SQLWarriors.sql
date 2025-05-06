CREATE OR REPLACE PACKAGE PKG_ADMIN_PRODUCTOS_AVANZADO AS

    FUNCTION F_VALIDAR_PLAN_SUFICIENTE(p_cuenta_id IN CUENTA.ID%TYPE) RETURN VARCHAR2;

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