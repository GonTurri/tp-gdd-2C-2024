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

CREATE TABLE PIZZA_VIERNES_UADE.subrubro (
	cod_subrubro decimal(18,0) PRIMARY KEY,
	descripcion nvarchar(50),
	cod_rubro decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.rubro(cod_rubro)
);

CREATE TABLE PIZZA_VIERNES_UADE.producto (
	id_producto decimal(18,0) PRIMARY KEY,
	cod_producto nvarchar(50),
	cod_marca decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.producto_marca(cod_marca),
	cod_modelo decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.producto_modelo(cod_modelo),
	descripcion nvarchar(50),
	precio decimal(18,2),
	cod_subrubro decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.subrubro(cod_subrubro)
);

CREATE TABLE PIZZA_VIERNES_UADE.publicacion (
	cod_publicacion decimal(18,0) PRIMARY KEY,
	descripcion nvarchar(50),
	stock decimal(18,0),
	fecha_inicio date,
	fecha_fin date,
	precio decimal(18,2),
	costo decimal(18,2),
	porc_venta decimal(18,2),
	cod_almacen decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.almacen(cod_almacen),
	cod_vendedor decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.vendedor(cod_vendedor),
	id_producto decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.producto(id_producto)
);

CREATE TABLE PIZZA_VIERNES_UADE.detalle_venta (
	cod_venta decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.venta(cod_venta),
	cod_publicacion decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.publicacion(cod_publicacion),
	detalle_cant decimal(18,0),
	detalle_precio decimal(18,2),
	detalle_sub_tot decimal(18,2),
	PRIMARY KEY (cod_venta, cod_publicacion)
);

CREATE TABLE PIZZA_VIERNES_UADE.detalle_factura (
	cod_detalle_factura decimal(18,0) PRIMARY KEY,
	cod_concepto_factura decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.concepto_factura(cod_concepto_factura),
	nro_factura decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.factura(nro_factura),
	cod_publicacion decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.publicacion(cod_publicacion),
	cantidad decimal(18,0),
	sub_total decimal(18,2)
);

GO

CREATE PROCEDURE PIZZA_VIERNES_UADE.migrar_todo AS
BEGIN
PRINT 'hola mati'
PRINT 'hola banda de Douglas'
END

GO

EXEC PIZZA_VIERNES_UADE.migrar_todo;

GO
