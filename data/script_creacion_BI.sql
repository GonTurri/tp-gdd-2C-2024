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

CREATE TABLE PIZZA_VIERNES_UADE.BI_producto (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    marca NVARCHAR(50),
    modelo NVARCHAR(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_rubro (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    rubro NVARCHAR(50),
    subrubro NVARCHAR(50)
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

CREATE TABLE PIZZA_VIERNES_UADE.BI_concepto_facturacion (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    tipo NVARCHAR(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_hechos (
    tiempo_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tiempo(id) NOT NULL,
    ubicacion_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_ubicacion(id) NOT NULL,
    rubro_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_rubro(id) NOT NULL,
    tipo_medio_pago_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tipo_medio_pago(id) NOT NULL,
    rango_etario_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_rango_etario_clientes(id) NOT NULL,
    tipo_envio_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tipo_envio(id) NOT NULL,
    rango_horario_ventas_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_rango_horario_ventas(id) NOT NULL,
    concepto_facturacion_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_concepto_facturacion(id) NOT NULL,
    producto_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_producto(id) NOT NULL,
    total_facturado DECIMAL(18,2),
    costo_envio DECIMAL(18,2),
    total_pagado DECIMAL(18,2),
    PRIMARY KEY(tiempo_id, ubicacion_id, rubro_id, tipo_medio_pago_id, rango_etario_id,
     tipo_envio_id, rango_horario_ventas_id, concepto_facturacion_id, producto_id)
);