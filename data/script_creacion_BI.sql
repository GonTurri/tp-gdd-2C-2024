CREATE TABLE PIZZA_VIERNES_UADE.BI_tiempo (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    anio DECIMAL(18,0),
    cuatrimestre DECIMAL(18,0),
    mes DECIMAL(18,0)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_ubicacion (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    provincia NVARCHAR(50),
    localidad NVARCHAR(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_marca (
    cod_marca DECIMAL(18,0) PRIMARY KEY,
    marca NVARCHAR(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_rubro (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    rubro NVARCHAR(50),
    subrubro NVARCHAR(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_publicacion (
    cod_publicacion DECIMAL(18,0) PRIMARY KEY
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_tipo_medio_pago (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    descripcion NVARCHAR(50),
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_rango_etario_clientes (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    rango NVARCHAR(255)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_rango_horario_ventas (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    rango NVARCHAR(255)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_tipo_envio (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    tipo NVARCHAR(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_envio (
    id DECIMAL(18,0) PRIMARY KEY
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_concepto_facturacion (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    tipo NVARCHAR(50)
);

-- CREATE TABLE PIZZA_VIERNES_UADE.BI_hechos (
--     tiempo_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tiempo(id) NOT NULL,
--     ubicacion_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_ubicacion(id) NOT NULL,
--     rubro_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_rubro(id) NOT NULL,
--     tipo_medio_pago_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tipo_medio_pago(id) NOT NULL,
--     rango_etario_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_rango_etario_clientes(id) NOT NULL,
--     tipo_envio_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tipo_envio(id) NOT NULL,
--     rango_horario_ventas_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_rango_horario_ventas(id) NOT NULL,
--     concepto_facturacion_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_concepto_facturacion(id) NOT NULL,
--     producto_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_producto(id) NOT NULL,
--     total_facturado DECIMAL(18,2),
--     costo_envio DECIMAL(18,2),
--     total_pagado DECIMAL(18,2),
--     PRIMARY KEY(tiempo_id, ubicacion_id, rubro_id, tipo_medio_pago_id, rango_etario_id,
--      tipo_envio_id, rango_horario_ventas_id, concepto_facturacion_id, producto_id)
-- );

CREATE TABLE PIZZA_VIERNES_UADE.BI_hechos_facturacion (
    tiempo_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tiempo(id) NOT NULL,
    ubicacion_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_ubicacion(id) NOT NULL,
    concepto_facturacion_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_concepto_facturacion(id) NOT NULL,
    total_facturado DECIMAL(18,2)
    PRIMARY KEY(tiempo_id, ubicacion_id, concepto_facturacion_id)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_hechos_envios (
    tiempo_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tiempo(id) NOT NULL,
    ubicacion_cliente_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_ubicacion(id) NOT NULL,
    tipo_envio_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tipo_envio(id) NOT NULL,
    envio_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_envio(id) NOT NULL,
    estado CHAR(1), -- 'C' para cumplido 'N' para NO cumplido
    costo_envio DECIMAL(18,2)
    PRIMARY KEY(tiempo_id, ubicacion_cliente_id, tipo_envio_id,envio_id)
);


CREATE TABLE PIZZA_VIERNES_UADE.BI_hechos_pagos (
    tiempo_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tiempo(id) NOT NULL,
    ubicacion_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_ubicacion(id) NOT NULL,
    tipo_medio_pago_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tipo_medio_pago(id) NOT NULL,
    total_pagos_en_cuotas DECIMAL(18,2),
    total_pagos_sin_cuotas DECIMAL(18,2)
    PRIMARY KEY(tiempo_id, ubicacion_id, tipo_medio_pago_id)
);


CREATE TABLE PIZZA_VIERNES_UADE.BI_hechos_ventas (
    tiempo_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tiempo(id) NOT NULL,
    ubicacion_almacenes_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_ubicacion(id) NOT NULL,
    rubro_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_rubro(id) NOT NULL,
    rango_etario_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_rango_etario_clientes(id) NOT NULL,
    ubicacion_clientes_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_ubicacion(id) NOT NULL,
    rango_horario_ventas_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_rango_horario_ventas(id) NOT NULL,
    valor_ventas DECIMAL(18,2),
    cantidad_ventas DECIMAL(18,2)
    PRIMARY KEY(tiempo_id, ubicacion_almacenes_id, rubro_id,rango_etario_id,ubicacion_clientes_id,rango_horario_ventas_id)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_hechos_publicaciones (
    tiempo_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tiempo(id) NOT NULL,
    ubicacion_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_ubicacion(id) NOT NULL,
    rubro_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_rubro(id) NOT NULL,
    marca_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_marca(id) NOT NULL,
    publicacion_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_publicacion(cod_publicacion) NOT NULL,
    dias_vigencia_publicacion DECIMAL(18,0),
    stock_inicial DECIMAL(18,0)
    PRIMARY KEY(tiempo_id, ubicacion_id, rubro_id,marca_id,publicacion_id)
);

-- CREACION DE VISTAS ?? 



-- CREACION DE FUNCIONES AUXILIARES

GO

CREATE FUNCTION PIZZA_VIERNES_UADE.get_rango_edad (@fecha_nacimiento DATE) RETURNS INT AS
BEGIN
    DECLARE @edad INT;

    SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE());

    DECLARE @id_rango INT;
    SET @id_rango = CASE WHEN @edad < 25 THEN 1
                         WHEN @edad >= 25 AND @edad <= 35 THEN 2
                         WHEN @edad > 35 AND @edad <= 50 THEN 3
                         WHEN @edad > 50 THEN 4
                    END;
    RETURN @id_rango
END

GO

CREATE FUNCTION PIZZA_VIERNES_UADE.get_rango_horario (@horario DATE) RETURNS INT AS
BEGIN
    DECLARE @hora INT;

    SET @edad = HOUR(@@horario)

    DECLARE @id_rango INT;
    SET @id_rango = CASE WHEN @edad < 25 THEN 1
                         WHEN @edad >= 25 AND @edad <= 35 THEN 2
                         WHEN @edad > 35 AND @edad <= 50 THEN 3
                         WHEN @edad > 50 THEN 4
                    END;
    RETURN @id_rango
END

-- MIGRACION DE TABLAS

GO 

CREATE OR ALTER PROCEDURE BI_llenar_dimensiones AS 
BEGIN 
    -- LLENADO DE DIMENSION PUBLICACION
    INSERT INTO PIZZA_VIERNES_UADE.BI_publicacion (cod_publicacion)
    SELECT DISTINCT cod_publicacion FROM PIZZA_VIERNES_UADE.publicacion;

    -- LLENADO DE DIMENSION ENVIO
    INSERT INTO PIZZA_VIERNES_UADE.BI_envio (id)
    SELECT DISTINCT envio_id FROM PIZZA_VIERNES_UADE.envio

    -- LLENADO DE DIMENSION MARCA
    INSERT INTO PIZZA_VIERNES_UADE.BI_marca (cod_marca, marca)
    SELECT DISTINCT cod_marca, marca FROM PIZZA_VIERNES_UADE.marca;

    -- LLENADO DE DIMENSION TIPO ENVIO
    INSERT INTO PIZZA_VIERNES_UADE.BI_tipo_envio (tipo)
    SELECT DISTINCT tipo FROM PIZZA_VIERNES_UADE.envio;

    -- LLENADO DE DIMENSION CONCEEPTO FACTURACION
    INSERT INTO PIZZA_VIERNES_UADE.BI_concepto_facturacion (tipo)
    SELECT DISTINCT concepto FROM PIZZA_VIERNES_UADE.concepto_factura;

    -- LLENADO DE DIMENSION TIPO MEDIO PAGO
    INSERT INTO PIZZA_VIERNES_UADE.BI_tipo_medio_pago (descripcion)
    SELECT DISTINCT descripcion FROM PIZZA_VIERNES_UADE.tipo_medio_pago;

    -- LLENADO DE DIMENSION RUBRO
    INSERT INTO PIZZA_VIERNES_UADE.BI_rubro (rubro, subrubro)
    SELECT DISTINCT r.descripcion, s.descripcion FROM PIZZA_VIERNES_UADE.subrubro s 
    JOIN PIZZA_VIERNES_UADE.rubro r ON s.cod_rubro = r.cod_rubro
    
    -- LLENADO DE DIMENSION RANGO ETARIO CLIENTES
    INSERT INTO PIZZA_VIERNES_UADE.BI_rango_etario_clientes (rango)
    VALUES ('< 25'), ('25-35'), ('35-50'), ('> 50');

    -- LLENADO DE DIMENSION RANGO HORARIO VENTAS
    INSERT INTO PIZZA_VIERNES_UADE.BI_rango_horario_ventas (rango)
    VALUES ('0:00 - 6:00'), ('6:00 - 12:00'), ('12:00 - 18:00'), ('18:00 - 24:00');
    
    -- LLENADO DE DIMENSION UBICACION
    INSERT INTO PIZZA_VIERNES_UADE.BI_ubicacion (provincia, localidad)
    SELECT DISTINCT l.localidad, p.provincia FROM PIZZA_VIERNES_UADE.localida
    -- LLENADO DE DIMENSION TIEMPO
    INSERT INTO PIZZA_VIERNES_UADE.BI_tiempo (anio,cuatrimestre,mes)
    (
        SELECT DISTINCT  YEAR(fecha_inicio), PIZZA_VIERNES_UADE.get_cuatrimestre(fecha_inicio), 
        MONTH(fecha_inicio)  FROM PIZZA_VIERNES_UADE.publicacion

        UNION SELECT 

    )
END