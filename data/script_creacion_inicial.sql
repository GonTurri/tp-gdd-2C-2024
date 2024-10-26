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
	cod_usuario decimal(18,0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.usuario(cod_usuario) NOT NULL UNIQUE
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
	fecha date NOT NULL,
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
		precio decimal (18,2) NOT NULL,
		cantidad decimal(18, 0) NOT NULL,
		sub_total decimal(18, 2) NOT NULL
	);

-- constraint para que no haya un detalle con precio negativo
ALTER TABLE PIZZA_VIERNES_UADE.detalle_factura ADD CONSTRAINT detalle_fact_precio_negativo
CHECK (precio >= 0);

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
		JOIN venta v ON i.cod_venta=v.cod_venta WHERE i.fecha_programada < v.fecha_hora OR i.fecha_hora_entrega < v.fecha_hora
	
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
	WHERE i.fecha_hora < p.fecha_inicio OR i.fecha_hora > p.fecha_fin

	IF (@cantidad_con_fecha_inconsistente >= 1)
		BEGIN
			DECLARE @msg_error varchar;
				SET @msg_error = 'La fecha de venta esta fuera del rango de fechas de la publicacion asociada';
				ROLLBACK;
				THROW 50001, @msg_error, 1;
		END;
END;

GO

CREATE OR ALTER PROCEDURE PIZZA_VIERNES_UADE.migrar_usuarios_clientes_vendedores_y_domicilios AS
BEGIN
	CREATE TABLE PIZZA_VIERNES_UADE.#tabla_temporal (
		nombre nvarchar(50),
		apellido nvarchar(50),
		fecha_nac DATE,
		cli_mail nvarchar(50),
		dni decimal(18,0),
		cuit nvarchar(50),
		ven_mail nvarchar(50),
		razon_social nvarchar(50),
		cod_usuario decimal(18,0) IDENTITY(1,1),
		usuario_nombre nvarchar(50),
		usuario_pass nvarchar(50),
		usuario_fecha_creacion date,
		calle nvarchar(50),
		cp nvarchar(50),
		depto nvarchar(50),
		nro_calle decimal(18,0),
		piso decimal(18,0),
		cod_localidad decimal(18,0)
	);

	INSERT INTO PIZZA_VIERNES_UADE.#tabla_temporal (nombre,	apellido, fecha_nac, cli_mail, dni, cuit, ven_mail, razon_social, usuario_nombre, usuario_pass, usuario_fecha_creacion, calle, cp, depto, nro_calle, piso, cod_localidad)
	SELECT DISTINCT
		CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_FECHA_NAC, CLIENTE_MAIL, CLIENTE_DNI, null as VENDEDOR_CUIT, null as VENDEDOR_MAIL, null as VENDEDOR_RAZON_SOCIAL,
		CLI_USUARIO_NOMBRE as USUARIO_NOMBRE, CLI_USUARIO_PASS as USUARIO_PASS, CLI_USUARIO_FECHA_CREACION as USUARIO_FECHA_CREACION,
		CLI_USUARIO_DOMICILIO_CALLE as DOMICILIO_CALLE, CLI_USUARIO_DOMICILIO_CP as DOMICILIO_CP,
		CLI_USUARIO_DOMICILIO_DEPTO as DOMICILIO_DEPTO, CLI_USUARIO_DOMICILIO_NRO_CALLE as DOMICILIO_NRO_CALLE, 
		CLI_USUARIO_DOMICILIO_PISO as DOMICILIO_PISO, l.cod_localidad
	FROM gd_esquema.Maestra mas 
	INNER JOIN PIZZA_VIERNES_UADE.provincia p ON p.nom_provincia = mas.CLI_USUARIO_DOMICILIO_PROVINCIA
	INNER JOIN PIZZA_VIERNES_UADE.localidad l ON l.cod_provincia = p.cod_provincia AND l.nom_localidad = CLI_USUARIO_DOMICILIO_LOCALIDAD
	WHERE CLI_USUARIO_NOMBRE IS NOT NULL
	UNION
	SELECT DISTINCT
		null , null, null, null, null, VENDEDOR_CUIT, VENDEDOR_MAIL, VENDEDOR_RAZON_SOCIAL,
		VEN_USUARIO_NOMBRE, VEN_USUARIO_PASS, VEN_USUARIO_FECHA_CREACION,
		VEN_USUARIO_DOMICILIO_CALLE, VEN_USUARIO_DOMICILIO_CP,
		VEN_USUARIO_DOMICILIO_DEPTO, VEN_USUARIO_DOMICILIO_NRO_CALLE, 
		VEN_USUARIO_DOMICILIO_PISO, l.cod_localidad
	FROM gd_esquema.Maestra mas 
	INNER JOIN PIZZA_VIERNES_UADE.provincia p ON p.nom_provincia = mas.VEN_USUARIO_DOMICILIO_PROVINCIA
	INNER JOIN PIZZA_VIERNES_UADE.localidad l ON l.cod_provincia = p.cod_provincia AND l.nom_localidad = VEN_USUARIO_DOMICILIO_LOCALIDAD
	WHERE VEN_USUARIO_NOMBRE IS NOT NULL

	-- MIGRACION DE USUARIOS
	INSERT INTO PIZZA_VIERNES_UADE.usuario (nombre, pass, fecha_creacion) 
	SELECT usuario_nombre,usuario_pass,usuario_fecha_creacion FROM PIZZA_VIERNES_UADE.#tabla_temporal
	ORDER BY cod_usuario

	--MIGRACION DE CLIENTES
	INSERT INTO PIZZA_VIERNES_UADE.cliente (nombre, apellido, fecha_nac, mail, dni, cod_usuario)
	SELECT nombre, apellido, fecha_nac, cli_mail, dni, cod_usuario
	FROM PIZZA_VIERNES_UADE.#tabla_temporal
	WHERE razon_social IS NULL;

	-- MIGRACION DE VENDEDORES
	INSERT INTO PIZZA_VIERNES_UADE.vendedor(razon_social, cuit, mail, cod_usuario)
	SELECT razon_social, cuit, ven_mail, cod_usuario
	FROM PIZZA_VIERNES_UADE.#tabla_temporal
	WHERE dni IS NULL;

	-- MIGRACION DE DOMICILIOS
	INSERT INTO PIZZA_VIERNES_UADE.domicilio (calle, cp, depto, nro_calle, piso, cod_localidad, cod_usuario)
	SELECT calle, cp, depto, nro_calle, piso, cod_localidad, cod_usuario FROM PIZZA_VIERNES_UADE.#tabla_temporal;

	DROP TABLE PIZZA_VIERNES_UADE.#tabla_temporal

END;

GO

CREATE or ALTER PROCEDURE PIZZA_VIERNES_UADE.migrar_pagos AS
BEGIN
	CREATE TABLE PIZZA_VIERNES_UADE.#tabla_temporal (
		nro_pago decimal(18,0) IDENTITY(1,1),
		importe decimal(18,2),
		fecha date,
		cod_venta decimal(18,0),
		cod_medio_pago decimal(18,0),
		nro_tarjeta nvarchar(50),
		cant_cuotas decimal(18,0),
		fecha_ven_tarjeta date
	);

	INSERT INTO PIZZA_VIERNES_UADE.#tabla_temporal(importe, fecha, cod_venta, cod_medio_pago, nro_tarjeta, cant_cuotas, fecha_ven_tarjeta)
	SELECT DISTINCT PAGO_IMPORTE, PAGO_FECHA, VENTA_CODIGO, mp.cod_medio_pago, PAGO_NRO_TARJETA, PAGO_CANT_CUOTAS, PAGO_FECHA_VENC_TARJETA
	FROM gd_esquema.Maestra mas
	JOIN PIZZA_VIERNES_UADE.tipo_medio_pago tm ON mas.PAGO_TIPO_MEDIO_PAGO = tm.descripcion
	JOIN PIZZA_VIERNES_UADE.medio_pago mp ON mp.cod_tipo_medio_pago = tm.cod_tipo_medio_pago AND mp.medio = mas.PAGO_MEDIO_PAGO
	WHERE PAGO_IMPORTE IS NOT NULL

	INSERT INTO PIZZA_VIERNES_UADE.pago(importe, fecha, cod_venta, cod_medio_pago)
	SELECT importe, fecha, cod_venta, cod_medio_pago
	FROM PIZZA_VIERNES_UADE.#tabla_temporal
	ORDER BY nro_pago;

	INSERT INTO PIZZA_VIERNES_UADE.detalle_pago(nro_pago, nro_tarjeta, fecha_ven_tarjeta, cant_cuotas)
	SELECT nro_pago, nro_tarjeta, fecha_ven_tarjeta, cant_cuotas
	FROM PIZZA_VIERNES_UADE.#tabla_temporal;

	DROP TABLE PIZZA_VIERNES_UADE.#tabla_temporal
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

	--MIGRACION DE PRODUCTOS
	INSERT INTO PIZZA_VIERNES_UADE.producto (cod_producto,cod_marca,cod_modelo,descripcion,precio,cod_subrubro) 
	SELECT cod_producto,cod_marca,cod_modelo,prod_desc,precio,cod_subrubro FROM (
		SELECT DISTINCT PRODUCTO_CODIGO as cod_producto ,cod_marca,PRODUCTO_MOD_CODIGO as cod_modelo ,PRODUCTO_DESCRIPCION as prod_desc,PRODUCTO_PRECIO as precio,
		cod_subrubro FROM gd_esquema.Maestra mas INNER JOIN PIZZA_VIERNES_UADE.producto_marca m ON mas.PRODUCTO_MARCA = m.descripcion
		INNER JOIN PIZZA_VIERNES_UADE.rubro r ON r.descripcion = mas.PRODUCTO_RUBRO_DESCRIPCION
		INNER JOIN PIZZA_VIERNES_UADE.subrubro s ON (mas.PRODUCTO_SUB_RUBRO = s.descripcion AND s.cod_rubro = r.cod_rubro) WHERE PRODUCTO_CODIGO IS NOT NULL
	) tmp

	-- MIGRACION DE USUARIOS, CLIENTES, VENDEDORES Y DOMICILIOS
	EXEC PIZZA_VIERNES_UADE.migrar_usuarios_clientes_vendedores_y_domicilios;

	-- MIGRACION DE PUBLICACIONES
	INSERT INTO PIZZA_VIERNES_UADE.publicacion(cod_publicacion, descripcion, stock, fecha_inicio, fecha_fin, precio, costo, porc_venta, cod_almacen, cod_vendedor, id_producto)
	SELECT PUBLICACION_CODIGO, PUBLICACION_DESCRIPCION, PUBLICACION_STOCK, PUBLICACION_FECHA,
			PUBLICACION_FECHA_V, PUBLICACION_PRECIO, PUBLICACION_COSTO, PUBLICACION_PORC_VENTA, cod_almacen, cod_vendedor, id_producto
		FROM (
			SELECT DISTINCT PUBLICACION_CODIGO, PUBLICACION_DESCRIPCION, PUBLICACION_STOCK, PUBLICACION_FECHA,
			PUBLICACION_FECHA_V, PUBLICACION_PRECIO, PUBLICACION_COSTO, PUBLICACION_PORC_VENTA, cod_almacen, cod_vendedor, id_producto
			FROM gd_esquema.Maestra mas
			JOIN PIZZA_VIERNES_UADE.almacen a ON mas.ALMACEN_CODIGO = a.cod_almacen
			JOIN PIZZA_VIERNES_UADE.vendedor v ON (
				v.cuit = mas.VENDEDOR_CUIT AND
				v.mail = mas.VENDEDOR_MAIL AND
				v.razon_social = mas.VENDEDOR_RAZON_SOCIAL
			) 
			JOIN PIZZA_VIERNES_UADE.producto_marca pma ON pma.descripcion = mas.PRODUCTO_MARCA
			JOIN PIZZA_VIERNES_UADE.producto p ON (
				p.cod_producto = mas.PRODUCTO_CODIGO AND
				p.cod_modelo = mas.PRODUCTO_MOD_CODIGO AND
				p.cod_marca = pma.cod_marca AND
				p.precio = mas.PRODUCTO_PRECIO
			)
			WHERE PUBLICACION_CODIGO IS NOT NULL
		) sub;
	
	--MIGRACION DE FACTURAS
	INSERT INTO PIZZA_VIERNES_UADE.factura(nro_factura, fecha, total, cod_vendedor)
	SELECT FACTURA_NUMERO, FACTURA_FECHA, FACTURA_TOTAL, cod_vendedor FROM (
		SELECT DISTINCT FACTURA_NUMERO,FACTURA_FECHA, FACTURA_TOTAL, p.cod_vendedor
		FROM gd_esquema.Maestra mas 
		INNER JOIN PIZZA_VIERNES_UADE.publicacion p ON p.cod_publicacion = mas.PUBLICACION_CODIGO
		WHERE FACTURA_NUMERO IS NOT NULL
	) sub;

	--MIGRACION DE DETALLES DE FACTURA
	INSERT INTO PIZZA_VIERNES_UADE.detalle_factura(cod_concepto_factura, nro_factura, cod_publicacion, precio, cantidad, sub_total)
	SELECT cod_concepto_factura, nro_factura, cod_publicacion, FACTURA_DET_PRECIO, FACTURA_DET_CANTIDAD, FACTURA_DET_SUBTOTAL FROM (
		SELECT DISTINCT cp.cod_concepto_factura, f.nro_factura, p.cod_publicacion, mas.FACTURA_DET_PRECIO, mas.FACTURA_DET_CANTIDAD, mas.FACTURA_DET_SUBTOTAL
		FROM gd_esquema.Maestra mas
		INNER JOIN PIZZA_VIERNES_UADE.concepto_factura cp ON FACTURA_DET_TIPO = cp.concepto
		INNER JOIN PIZZA_VIERNES_UADE.factura f ON FACTURA_NUMERO = f.nro_factura
		INNER JOIN PIZZA_VIERNES_UADE.publicacion p ON mas.PUBLICACION_CODIGO = p.cod_publicacion
		WHERE FACTURA_DET_PRECIO IS NOT NULL AND FACTURA_DET_CANTIDAD IS NOT NULL AND FACTURA_DET_SUBTOTAL IS NOT NULL
	) sub;

	-- MIGRACION DE VENTAS
	INSERT INTO PIZZA_VIERNES_UADE.venta (cod_venta, fecha_hora, total, cod_cliente)
	SELECT DISTINCT VENTA_CODIGO,VENTA_FECHA, VENTA_TOTAL, c.cod_cliente FROM gd_esquema.Maestra mas 
	INNER JOIN PIZZA_VIERNES_UADE.cliente c ON mas.CLIENTE_NOMBRE = c.nombre AND mas.CLIENTE_APELLIDO = c.apellido 
	AND mas.CLIENTE_DNI = c.dni AND mas.CLIENTE_MAIL = c.mail AND mas.CLIENTE_FECHA_NAC = c.fecha_nac
	WHERE VENTA_CODIGO IS NOT NULL;
	
	-- MIGRACION DE DETALLE VENTAS
	INSERT INTO PIZZA_VIERNES_UADE.detalle_venta(cod_venta, cod_publicacion, detalle_cant, detalle_precio, detalle_sub_tot)
	SELECT DISTINCT VENTA_CODIGO, PUBLICACION_CODIGO, VENTA_DET_CANT, VENTA_DET_PRECIO, VENTA_DET_SUB_TOTAL
	FROM gd_esquema.Maestra
	WHERE VENTA_CODIGO IS NOT NULL AND PUBLICACION_CODIGO IS NOT NULL;

	-- MIGRACION DE PAGOS y DETALLES DE PAGOS
	EXEC PIZZA_VIERNES_UADE.migrar_pagos;


	-- MIGRACION DE ENVIOS
	INSERT INTO PIZZA_VIERNES_UADE.envio (fecha_programada, hora_inicio, hora_fin, costo, fecha_hora_entrega, tipo, cod_venta, cod_domicilio)
	SELECT DISTINCT ENVIO_FECHA_PROGAMADA, ENVIO_HORA_INICIO, ENVIO_HORA_FIN_INICIO, ENVIO_COSTO, ENVIO_FECHA_ENTREGA, ENVIO_TIPO, VENTA_CODIGO, d.cod_domicilio
	FROM gd_esquema.Maestra mas
	INNER JOIN PIZZA_VIERNES_UADE.provincia p  ON p.nom_provincia = mas.CLI_USUARIO_DOMICILIO_PROVINCIA
	INNER JOIN PIZZA_VIERNES_UADE.localidad l  ON l.cod_provincia = p.cod_provincia AND l.nom_localidad = CLI_USUARIO_DOMICILIO_LOCALIDAD
	INNER JOIN PIZZA_VIERNES_UADE.domicilio d ON (
			mas.CLI_USUARIO_DOMICILIO_CALLE = d.calle
			AND mas.CLI_USUARIO_DOMICILIO_CP = d.cp
			AND mas.CLI_USUARIO_DOMICILIO_DEPTO = d.depto
			AND mas.CLI_USUARIO_DOMICILIO_NRO_CALLE = d.nro_calle 
			AND mas.CLI_USUARIO_DOMICILIO_PISO = d.piso
			AND d.cod_localidad = l.cod_localidad
	)
	WHERE ENVIO_COSTO IS NOT NULL;

END;

GO

EXEC PIZZA_VIERNES_UADE.migrar_todo;

GO