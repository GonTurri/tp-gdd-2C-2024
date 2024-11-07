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
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
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
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1)
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
