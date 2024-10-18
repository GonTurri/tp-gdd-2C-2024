USE GD2C2024
GO

CREATE SCHEMA PIZZA_VIERNES_UADE
GO

CREATE TABLE PIZZA_VIERNES_UADE.provincia (
	cod_provincia decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	nom_provincia nvarchar(50) NOT NULL UNIQUE
);

CREATE TABLE PIZZA_VIERNES_UADE.localidad (
	cod_localidad decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	nom_localidad nvarchar(50) NOT NULL,
	cod_provincia decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.provincia(cod_provincia) NOT NULL
);

CREATE TABLE PIZZA_VIERNES_UADE.almacen (
	cod_almacen decimal(18,0) PRIMARY KEY NOT NULL,
	calle nvarchar(50) NOT NULL,
	nro_calle decimal(18,0) NOT NULL,
	costo_dia_al decimal(18,0) NOT NULL,
	cod_localidad decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.localidad(cod_localidad) NOT NULL
);

-- constraint para que no haya un almacen con numero de calle negativo
ALTER TABLE PIZZA_VIERNES_UADE.almacen ADD CONSTRAINT almacen_nro_calle_negativo
CHECK (nro_calle >= 0);

-- constraint para que no haya un almacen con costo dia al negativo
ALTER TABLE PIZZA_VIERNES_UADE.almacen ADD CONSTRAINT costo_dia_al_negativo
CHECK (costo_dia_al >= 0);

CREATE TABLE PIZZA_VIERNES_UADE.usuario (
	cod_usuario decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	nombre nvarchar(50) NOT NULL,
	pass nvarchar(50) NOT NULL,
	fecha_creacion date NOT NULL
);

CREATE TABLE PIZZA_VIERNES_UADE.cliente (
	cod_cliente decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	nombre nvarchar(50) NOT NULL,
	apellido nvarchar(50) NOT NULL,
	fecha_nac date NOT NULL,
	mail nvarchar(50) NOT NULL,
	dni decimal(18,0) NOT NULL,
	cod_usuario decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.usuario(cod_usuario) NOT NULL
);

-- no ponemos unique constraint para el dni pues en la Republica Argentina es posible que haya duplicados

-- constraint para evitar fecha de nacimiento futura
ALTER TABLE PIZZA_VIERNES_UADE.cliente ADD CONSTRAINT cliente_fecha_nac_futura
CHECK (fecha_nac <= GETDATE());

-- constraint para que no haya un dni negativo
ALTER TABLE PIZZA_VIERNES_UADE.cliente ADD CONSTRAINT cliente_dni_negativo
CHECK (dni > 0);

CREATE TABLE PIZZA_VIERNES_UADE.vendedor (
	cod_vendedor decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	razon_social nvarchar(50) NOT NULL,
	cuit nvarchar(50) NOT NULL UNIQUE,
	mail nvarchar(50) NOT NULL,
	cod_usuario decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.usuario(cod_usuario) NOT NULL
);

CREATE TABLE PIZZA_VIERNES_UADE.domicilio (
	cod_domicilio decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	calle nvarchar(50) NOT NULL,
	nro_calle decimal(18,0) NOT NULL,
	piso decimal(18,0) NOT NULL,
	depto nvarchar(50) NOT NULL,
	cp nvarchar(50) NOT NULL,
	cod_usuario decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.usuario(cod_usuario) NOT NULL,
	cod_localidad decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.localidad(cod_localidad) NOT NULL
);

-- constraint para que no haya un nro de calle negativo
ALTER TABLE PIZZA_VIERNES_UADE.domicilio ADD CONSTRAINT domicilio_nro_calle_negativo
CHECK (nro_calle >= 0);

CREATE TABLE PIZZA_VIERNES_UADE.factura (
	nro_factura decimal(18,0) PRIMARY KEY NOT NULL,
	fecha date NOT NULL,
	total decimal(18,0) NOT NULL,
	cod_vendedor decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.vendedor(cod_vendedor) NOT NULL
);

-- constraint para que no haya una factura con total negativo
ALTER TABLE PIZZA_VIERNES_UADE.factura ADD CONSTRAINT factura_total_negativo
CHECK (total >= 0);

CREATE TABLE PIZZA_VIERNES_UADE.concepto_factura (
	cod_concepto_factura decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	concepto nvarchar(50) NOT NULL
);

CREATE TABLE PIZZA_VIERNES_UADE.producto_modelo (
	cod_modelo decimal(18,0) PRIMARY KEY NOT NULL,
	descripcion nvarchar(50) NOT NULL
);

CREATE TABLE PIZZA_VIERNES_UADE.producto_marca (
	cod_marca decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	descripcion nvarchar(50) NOT NULL
);

CREATE TABLE PIZZA_VIERNES_UADE.rubro (
	cod_rubro decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	descripcion nvarchar(50) NOT NULL
);

CREATE TABLE PIZZA_VIERNES_UADE.tipo_medio_pago (
	cod_tipo_medio_pago decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	descripcion nvarchar(50) NOT NULL
);

CREATE TABLE PIZZA_VIERNES_UADE.medio_pago (
	cod_medio_pago decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	medio nvarchar(50) NOT NULL,
	cod_tipo_medio_pago decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.tipo_medio_pago(cod_tipo_medio_pago) NOT NULL
);

CREATE TABLE PIZZA_VIERNES_UADE.venta (
	cod_venta decimal(18,0) PRIMARY KEY NOT NULL,
	fecha_hora datetime NOT NULL,
	total decimal(18,2) NOT NULL,
	cod_cliente decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.cliente(cod_cliente) NOT NULL
);

-- TODO: GESTION DE VENTAS QUE PERTENECEN A OTROS VENDEDORES

-- constraint para que no haya una venta con total negativo
ALTER TABLE PIZZA_VIERNES_UADE.venta ADD CONSTRAINT venta_total_negativo
CHECK (total >= 0);

CREATE TABLE PIZZA_VIERNES_UADE.pago (
	nro_pago decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	importe decimal(18,2) NOT NULL,
	cod_venta decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.venta(cod_venta) NOT NULL,
	cod_medio_pago decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.medio_pago(cod_medio_pago) NOT NULL
);

-- constraint para que no haya un pago con importe negativo
ALTER TABLE PIZZA_VIERNES_UADE.pago ADD CONSTRAINT pago_importe_negativo
CHECK (importe >= 0);

CREATE TABLE PIZZA_VIERNES_UADE.detalle_pago (
	nro_pago decimal(18,0) PRIMARY KEY FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.pago(nro_pago) NOT NULL,
	nro_tarjeta nvarchar(50) NOT NULL,
	fecha_ven_tarjeta date NOT NULL,
	cant_cuotas decimal(18,0) NOT NULL
);

-- constraint para que no haya una cantidad de cuotas menor a 1
ALTER TABLE PIZZA_VIERNES_UADE.detalle_pago ADD CONSTRAINT cant_cuotas_negativo
CHECK (cant_cuotas >= 1);

CREATE TABLE PIZZA_VIERNES_UADE.envio (
	nro_envio decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	fecha_programada date NOT NULL,
	hora_inicio decimal(18,0) NOT NULL,
	hora_fin decimal(18,0) NOT NULL,
	costo decimal(18,2) NOT NULL,
	fecha_hora_entrega datetime NULL,
	tipo nvarchar(50) NOT NULL,
	cod_venta decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.venta(cod_venta) NOT NULL,
	cod_domicilio decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.domicilio(cod_domicilio) NOT NULL
);

-- constraint para que no haya un envio con costo negativo
ALTER TABLE PIZZA_VIERNES_UADE.envio ADD CONSTRAINT costo_envio_negativo
CHECK (costo >= 0);

-- constrraint para que las horas de inicio y fin tengan valores validos
ALTER TABLE PIZZA_VIERNES_UADE.envio ADD CONSTRAINT hora_en_rango
CHECK (hora_fin BETWEEN 0 AND 23 AND hora_inicio BETWEEN 0 AND 23);

-- contraint para que la hora inicio sea menor a la hora fin
ALTER TABLE PIZZA_VIERNES_UADE.envio ADD CONSTRAINT horas_coherentes_envio
CHECK (hora_fin >= hora_inicio);

CREATE TABLE PIZZA_VIERNES_UADE.subrubro (
	cod_subrubro decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	descripcion nvarchar(50) NOT NULL,
	cod_rubro decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.rubro(cod_rubro) NOT NULL
);

CREATE TABLE PIZZA_VIERNES_UADE.producto (
	id_producto decimal(18,0) PRIMARY KEY IDENTITY(1,1) NOT NULL,
	cod_producto nvarchar(50) NOT NULL,
	cod_marca decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.producto_marca(cod_marca) NOT NULL,
	cod_modelo decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.producto_modelo(cod_modelo) NOT NULL,
	descripcion nvarchar(50) NOT NULL,
	precio decimal(18,2) NOT NULL,
	cod_subrubro decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.subrubro(cod_subrubro) NOT NULL
);

-- constraint para que no haya un producto con precio negativo
ALTER TABLE PIZZA_VIERNES_UADE.producto ADD CONSTRAINT producto_precio_negativo
CHECK (precio >= 0);

CREATE TABLE PIZZA_VIERNES_UADE.publicacion (
	cod_publicacion decimal(18,0) PRIMARY KEY NOT NULL,
	descripcion nvarchar(50) NOT NULL,
	stock decimal(18,0) NOT NULL,
	fecha_inicio date NOT NULL,
	fecha_fin date NOT NULL,
	precio decimal(18,2) NOT NULL,
	costo decimal(18,2) NOT NULL,
	porc_venta decimal(18,2) NOT NULL,
	cod_almacen decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.almacen(cod_almacen) NOT NULL,
	cod_vendedor decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.vendedor(cod_vendedor) NOT NULL,
	id_producto decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.producto(id_producto) NOT NULL
);

-- constraint para que no haya una publicacion con stock negativo
ALTER TABLE PIZZA_VIERNES_UADE.publicacion ADD CONSTRAINT publicacion_stock_negativo
CHECK (stock >= 0);

-- contraint para que la fecha inicio sea menor a la fecha fin
ALTER TABLE PIZZA_VIERNES_UADE.publicacion ADD CONSTRAINT publicacion_fechas_coherentes
CHECK (fecha_fin >= fecha_inicio);

-- constraint para que no haya una publicacion con precio negativo
ALTER TABLE PIZZA_VIERNES_UADE.publicacion ADD CONSTRAINT publicacion_precio_negativo
CHECK (precio >= 0);

-- constraint para que no haya una publicacion con costo negativo
ALTER TABLE PIZZA_VIERNES_UADE.publicacion ADD CONSTRAINT publicacion_costo_negativo
CHECK (costo >= 0);

-- constraint para que no haya una publicacion con porcentaje negativo
ALTER TABLE PIZZA_VIERNES_UADE.publicacion ADD CONSTRAINT publicacion_porc_negativo
CHECK (porc_venta >= 0);

CREATE TABLE PIZZA_VIERNES_UADE.detalle_venta (
	cod_venta decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.venta(cod_venta) NOT NULL,
	cod_publicacion decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.publicacion(cod_publicacion) NOT NULL,
	detalle_cant decimal(18,0) NOT NULL,
	detalle_precio decimal(18,2) NOT NULL,
	detalle_sub_tot decimal(18,2) NOT NULL,
	PRIMARY KEY (cod_venta, cod_publicacion)
);

-- constraint para que no haya un detalle de venta con detalle cant negativo
ALTER TABLE PIZZA_VIERNES_UADE.detalle_venta ADD CONSTRAINT detalle_venta_detalle_cant_negativo
CHECK (detalle_cant >= 0);

-- constraint para que no haya un detalle de venta con precio negativo
ALTER TABLE PIZZA_VIERNES_UADE.detalle_venta ADD CONSTRAINT detalle_venta_detalle_precio_negativo
CHECK (detalle_precio >= 0);

-- constraint para que no haya un detalle de venta con sub total negativo
ALTER TABLE PIZZA_VIERNES_UADE.detalle_venta ADD CONSTRAINT detalle_venta_detalle_sub_total_negativo
CHECK (detalle_sub_tot >= 0); 

CREATE TABLE
	PIZZA_VIERNES_UADE.detalle_factura (
		cod_detalle_factura decimal(18, 0) PRIMARY KEY IDENTITY (1, 1) NOT NULL,
		cod_concepto_factura decimal(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.concepto_factura (cod_concepto_factura) NOT NULL,
		nro_factura decimal(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.factura (nro_factura) NOT NULL,
		cod_publicacion decimal(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.publicacion (cod_publicacion) NOT NULL,
		cantidad decimal(18, 0) NOT NULL,
		sub_total decimal(18, 2) NOT NULL
	);

-- constraint para que no haya un detalle con cantidad negativa
ALTER TABLE PIZZA_VIERNES_UADE.detalle_factura ADD CONSTRAINT detalle_fact_cant_negativo
CHECK (cantidad >= 0);

-- constraint para que no haya un detalle con sub total negativo
ALTER TABLE PIZZA_VIERNES_UADE.detalle_factura ADD CONSTRAINT detalle_fact_sub_total_negativo
CHECK (sub_total >= 0);

GO

-- CREACION DE TRIGGERS

-- trigger para que una factura no haga referencia a publicaciones creadas en fechas posteriores
CREATE or ALTER TRIGGER tr_check_fechas_factura_publicacion ON PIZZA_VIERNES_UADE.detalle_factura
AFTER insert, update AS
BEGIN	
	DECLARE @cantidad_con_fecha_inconsistente INT;
	SELECT @cantidad_con_fecha_inconsistente =  COUNT(*) FROM inserted i
	JOIN publicacion p ON i.cod_publicacion=p.cod_publicacion
	JOIN factura f ON i.nro_factura=f.nro_factura
	WHERE p.fecha_inicio > f.fecha
	IF (@cantidad_con_fecha_inconsistente >= 1)
		BEGIN
			DECLARE @msg_error varchar;
			SET @msg_error = 'Error: No se puede agregar un detalle por una publicacion iniciada posteriormente a la cracion de la factura' ;
			ROLLBACK;
			THROW 50001, @msg_error, 1;
	END
END;

GO

-- trigger para que un envio no tenga fecha anterior a la venta
CREATE or ALTER TRIGGER tr_check_fecha_envio ON PIZZA_VIERNES_UADE.envio
AFTER insert, update AS
BEGIN
	DECLARE @cantidad_con_fecha_inconsistente INT;
		SELECT  @cantidad_con_fecha_inconsistente =  COUNT(*) FROM inserted i
		JOIN venta v ON i.cod_venta=v.cod_venta WHERE i.fecha_programada < v.fecha OR i.fecha_hora_entrega < v.fecha
	
		IF (@cantidad_con_fecha_inconsistente >=1)
			BEGIN
				DECLARE @msg_error varchar;
				SET @msg_error = 'La fecha programada o de entrega del envio es anterior a la fecha de la venta';
				ROLLBACK;
				THROW 50001, @msg_error, 1;
			END;
END;

GO

-- trigger para que una venta no tenga fecha fuera del rango de la publicacion asociada
CREATE or ALTER TRIGGER tr_check_fecha_venta ON PIZZA_VIERNES_UADE.venta
AFTER INSERT, UPDATE AS
BEGIN
	DECLARE @cantidad_con_fecha_inconsistente INT;
	SELECT @cantidad_con_fecha_inconsistente = COUNT(*) FROM inserted i
	JOIN detalle_venta dv ON i.cod_venta = dv.cod_venta
	JOIN publicacion p ON dv.cod_publicacion = p.cod_publicacion
	WHERE i.GETDATE(fecha_hora) < p.fecha_inicio OR i.GETDATE(fecha_hora) > p.fecha_fin

	IF (@cantidad_con_fecha_inconsistente >= 1)
		BEGIN
			DECLARE @msg_error varchar;
				SET @msg_error = 'La fecha de venta esta fuera del rango de fechas de la publicacion asociada';
				ROLLBACK;
				THROW 50001, @msg_error, 1;
		END;
END;

GO


CREATE or ALTER PROCEDURE PIZZA_VIERNES_UADE.migrar_todo AS
BEGIN

	-- MIGRACION DE PROVINCIAS
	INSERT INTO PIZZA_VIERNES_UADE.provincia (nom_provincia)
	(SELECT DISTINCT ALMACEN_PROVINCIA FROM gd_esquema.Maestra WHERE ALMACEN_PROVINCIA IS NOT NULL UNION 
	SELECT DISTINCT CLI_USUARIO_DOMICILIO_PROVINCIA FROM gd_esquema.Maestra  WHERE CLI_USUARIO_DOMICILIO_PROVINCIA IS NOT NULL
	UNION SELECT DISTINCT VEN_USUARIO_DOMICILIO_PROVINCIA FROM gd_esquema.Maestra WHERE VEN_USUARIO_DOMICILIO_PROVINCIA IS NOT NULL)

	--MIGRACION DE LOCALIDADES POR FAVOR REVISAR PORQUE SON COMO 17K
	INSERT INTO PIZZA_VIERNES_UADE.localidad (cod_provincia,nom_localidad)
	SELECT cod_provincia, localidad  FROM PIZZA_VIERNES_UADE.provincia p JOIN (
	SELECT DISTINCT ALMACEN_PROVINCIA as provincia, ALMACEN_Localidad as localidad FROM gd_esquema.Maestra WHERE ALMACEN_Localidad IS NOT NULL
	UNION
	SELECT DISTINCT VEN_USUARIO_DOMICILIO_PROVINCIA, VEN_USUARIO_DOMICILIO_LOCALIDAD FROM gd_esquema.Maestra
	WHERE VEN_USUARIO_DOMICILIO_LOCALIDAD IS NOT NULL 
	UNION
	SELECT DISTINCT CLI_USUARIO_DOMICILIO_PROVINCIA, CLI_USUARIO_DOMICILIO_LOCALIDAD FROM gd_esquema.Maestra
	WHERE CLI_USUARIO_DOMICILIO_LOCALIDAD IS NOT NULL) m ON m.provincia = p.nom_provincia

	-- MIGRACION DE RUBROS
	INSERT INTO PIZZA_VIERNES_UADE.rubro (descripcion) 
	SELECT DISTINCT PRODUCTO_RUBRO_DESCRIPCION FROM gd_esquema.Maestra WHERE PRODUCTO_RUBRO_DESCRIPCION IS NOT NULL

	--MIGRACION DE SUBRUBROS, TODO TAMBIEN REVISAR
	INSERT INTO PIZZA_VIERNES_UADE.subrubro (descripcion,cod_rubro) 
	SELECT PRODUCTO_SUB_RUBRO, cod_rubro FROM PIZZA_VIERNES_UADE.rubro r INNER JOIN
	(SELECT DISTINCT PRODUCTO_SUB_RUBRO, PRODUCTO_RUBRO_DESCRIPCION FROM gd_esquema.Maestra WHERE PRODUCTO_SUB_RUBRO IS NOT NULL) m
	ON r.descripcion = m.PRODUCTO_RUBRO_DESCRIPCION

	--MIGRACION DE TIPOS DE MEDIOS DE PAGO
	INSERT INTO PIZZA_VIERNES_UADE.tipo_medio_pago (descripcion)
	SELECT DISTINCT PAGO_TIPO_MEDIO_PAGO FROM gd_esquema.Maestra WHERE PAGO_TIPO_MEDIO_PAGO IS NOT NULL

	--MIGRACION DE MEDIOS DE PAGO
	INSERT INTO PIZZA_VIERNES_UADE.medio_pago (medio, cod_tipo_medio_pago)
	SELECT m.PAGO_MEDIO_PAGO, tmp.cod_tipo_medio_pago FROM PIZZA_VIERNES_UADE.tipo_medio_pago tmp INNER JOIN
	(SELECT DISTINCT PAGO_MEDIO_PAGO, PAGO_TIPO_MEDIO_PAGO FROM gd_esquema.Maestra WHERE PAGO_MEDIO_PAGO IS NOT NULL) m
	ON tmp.descripcion = m.PAGO_TIPO_MEDIO_PAGO

	--MIGRACION DE CONCEPTOS DE FACTURA
	INSERT INTO PIZZA_VIERNES_UADE.concepto_factura (concepto)
	SELECT DISTINCT FACTURA_DET_TIPO FROM gd_esquema.Maestra WHERE FACTURA_DET_TIPO IS NOT NULL

	--MIGRACION DE MODELOS
	INSERT INTO PIZZA_VIERNES_UADE.producto_modelo (cod_modelo, descripcion)
	SELECT DISTINCT PRODUCTO_MOD_CODIGO, PRODUCTO_MOD_DESCRIPCION FROM gd_esquema.Maestra 
	WHERE PRODUCTO_MOD_CODIGO IS NOT NULL AND PRODUCTO_MOD_DESCRIPCION IS NOT NULL

	--MIGRACION DE MARCAS
	INSERT INTO PIZZA_VIERNES_UADE.producto_marca (descripcion)
	SELECT DISTINCT PRODUCTO_MARCA FROM gd_esquema.Maestra WHERE PRODUCTO_MARCA IS NOT NULL

	--MIGRACION DE ALMACENES
	INSERT INTO PIZZA_VIERNES_UADE.almacen (cod_almacen, calle, nro_calle, costo_dia_al, cod_localidad)
	SELECT ALMACEN_CODIGO, ALMACEN_CALLE, ALMACEN_NRO_CALLE, ALMACEN_COSTO_DIA_AL, cod_localidad
	FROM (SELECT DISTINCT m.ALMACEN_CODIGO, m.ALMACEN_CALLE, m.ALMACEN_NRO_CALLE, m.ALMACEN_COSTO_DIA_AL, l.cod_localidad FROM PIZZA_VIERNES_UADE.localidad l
	INNER JOIN PIZZA_VIERNES_UADE.provincia p  ON p.cod_provincia = l.cod_provincia  
	INNER JOIN gd_esquema.Maestra m ON  p.nom_provincia = m.ALMACEN_PROVINCIA AND l.nom_localidad = m.ALMACEN_Localidad
	WHERE ALMACEN_CODIGO IS NOT NULL) sub

	--MIGRACION DE 

END

GO

EXEC PIZZA_VIERNES_UADE.migrar_todo;

GO