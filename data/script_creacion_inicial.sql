USE GD2C2024
GO

CREATE SCHEMA PIZZA_VIERNES_UADE
GO

CREATE TABLE PIZZA_VIERNES_UADE.provincia (
	cod_provincia decimal(18,0) PRIMARY KEY,
	nom_provincia nvarchar(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.localidad (
	cod_localidad decimal(18,0) PRIMARY KEY,
	nom_localidad nvarchar(50),
	cod_provincia decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.provincia(cod_provincia)
);

CREATE TABLE PIZZA_VIERNES_UADE.almacen (
	cod_almacen decimal(18,0) PRIMARY KEY,
	calle nvarchar(50),
	nro_calle decimal(18,0),
	costo_dia_al decimal(18,0),
	cod_localidad decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.localidad(cod_localidad)
);

CREATE TABLE PIZZA_VIERNES_UADE.usuario (
	cod_usuario decimal(18,0) PRIMARY KEY,
	nombre nvarchar(50),
	pass nvarchar(50),
	fecha_creacion date
);

CREATE TABLE PIZZA_VIERNES_UADE.cliente (
	cod_cliente decimal(18,0) PRIMARY KEY,
	nombre nvarchar(50),
	apellido nvarchar(50),
	fecha_nac date,
	mail nvarchar(50),
	dni decimal(18,0),
	cod_usuario decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.usuario(cod_usuario)
);

CREATE TABLE PIZZA_VIERNES_UADE.vendedor (
	cod_vendedor decimal(18,0) PRIMARY KEY,
	razon_social nvarchar(50),
	cuit nvarchar(50),
	mail nvarchar(50),
	cod_usuario decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.usuario(cod_usuario)
);

CREATE TABLE PIZZA_VIERNES_UADE.domicilio (
	cod_domicilio decimal(18,0) PRIMARY KEY,
	calle nvarchar(50),
	nro_calle nvarchar(50),
	piso decimal(18,0),
	depto nvarchar(50),
	cp nvarchar(50),
	cod_localidad decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.localidad(cod_localidad)
);

CREATE TABLE PIZZA_VIERNES_UADE.factura (
	nro_factura decimal(18,0) PRIMARY KEY,
	fecha date,
	total decimal(18,0),
	cod_vendedor decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.vendedor(cod_vendedor)
);

CREATE TABLE PIZZA_VIERNES_UADE.concepto_factura (
	cod_concepto_factura decimal(18,0) PRIMARY KEY,
	concepto nvarchar(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.producto_modelo (
	cod_modelo decimal(18,0) PRIMARY KEY,
	descripcion nvarchar(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.producto_marca (
	cod_marca decimal(18,0) PRIMARY KEY,
	descripcion nvarchar(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.rubro (
	cod_rubro decimal(18,0) PRIMARY KEY,
	descripcion nvarchar(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.tipo_medio_pago (
	cod_tipo_medio_pago decimal(18,0) PRIMARY KEY,
	descripcion nvarchar(50)
);

CREATE TABLE PIZZA_VIERNES_UADE.medio_pago (
	cod_medio_pago decimal(18,0) PRIMARY KEY,
	medio nvarchar(50),
	cod_tipo_medio_pago decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.tipo_medio_pago(cod_tipo_medio_pago)
);

CREATE TABLE PIZZA_VIERNES_UADE.venta (
	cod_venta decimal(18,0) PRIMARY KEY,
	fecha_hora datetime,
	total decimal(18,2),
	cod_cliente decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.cliente(cod_cliente)
);


CREATE TABLE PIZZA_VIERNES_UADE.pago (
	nro_pago decimal(18,0) PRIMARY KEY,
	importe decimal(18,2),
	cod_venta decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.venta(cod_venta),
	cod_medio_pago decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.medio_pago(cod_medio_pago)
);

CREATE TABLE PIZZA_VIERNES_UADE.detalle_pago (
	nro_pago decimal(18,0) PRIMARY KEY FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.pago(nro_pago),
	nro_tarjeta nvarchar(50),
	fecha_ven_tarjeta date,
	cant_cuotas decimal(18,0)
);

CREATE TABLE PIZZA_VIERNES_UADE.envio (
	nro_envio decimal(18,0) PRIMARY KEY,
	fecha_programada date,
	hora_inicio decimal(18,0),
	hora_fin decimal(18,0),
	costo decimal(18,2),
	fecha_hora_entrega datetime,
	tipo nvarchar(50),
	cod_venta decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.venta(cod_venta),
	cod_domicilio decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.domicilio(cod_domicilio)
);