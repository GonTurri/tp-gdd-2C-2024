USE GD2C2024;
GO

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

CREATE TABLE PIZZA_VIERNES_UADE.BI_concepto_facturacion (
    id DECIMAL(18,0) PRIMARY KEY IDENTITY(1,1),
    tipo NVARCHAR(50)
);

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
    ubicacion_almacenes_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_ubicacion(id) NOT NULL,
    tipo_envio_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tipo_envio(id) NOT NULL,
	costo_total_envios DECIMAL(18,2),
	cant_envios_cumplidos DECIMAL(18,0),
	cant_envios_totales DECIMAL(18,0),
    PRIMARY KEY(tiempo_id, ubicacion_cliente_id, ubicacion_almacenes_id, tipo_envio_id)
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
    cantidad_ventas DECIMAL(18,0)
    PRIMARY KEY(tiempo_id, ubicacion_almacenes_id, rubro_id,rango_etario_id,ubicacion_clientes_id,rango_horario_ventas_id)
);

CREATE TABLE PIZZA_VIERNES_UADE.BI_hechos_publicaciones (
    tiempo_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_tiempo(id) NOT NULL,
    rubro_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_rubro(id) NOT NULL,
    marca_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_marca(cod_marca) NOT NULL,
    publicacion_id DECIMAL(18, 0) FOREIGN KEY REFERENCES PIZZA_VIERNES_UADE.BI_publicacion(cod_publicacion) NOT NULL,
    dias_vigencia_publicacion DECIMAL(18,0),
    stock_inicial DECIMAL(18,0)
    PRIMARY KEY(tiempo_id, rubro_id,marca_id,publicacion_id)
);

-- CREACION DE FUNCIONES AUXILIARES

GO

CREATE FUNCTION PIZZA_VIERNES_UADE.get_rango_edad (@fecha_nacimiento DATE) RETURNS INT AS
BEGIN
    DECLARE @edad INT;

    SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE());

    DECLARE @id_rango INT;
    SET @id_rango = CASE WHEN @edad < 25 THEN 1
                         WHEN @edad BETWEEN 25 AND 35 THEN 2 
                         WHEN @edad > 35 AND @edad <= 50 THEN 3
                         WHEN @edad > 50 THEN 4
                    END;
    RETURN @id_rango
END

GO

CREATE FUNCTION PIZZA_VIERNES_UADE.get_rango_horario (@horario DATETIME) RETURNS INT AS
BEGIN
    DECLARE @hora INT;

    SET @hora = DATEPART(HOUR, @horario)

    DECLARE @id_rango INT;
    SET @id_rango = CASE WHEN @hora >= 0 AND @hora < 6 THEN 1
                         WHEN @hora >= 6 AND @hora < 12 THEN 2
                         WHEN @hora >= 12 AND @hora < 18 THEN 3
                         WHEN @hora >= 18 AND @hora < 24 THEN 4
                    END;
    RETURN @id_rango
END

GO

CREATE FUNCTION PIZZA_VIERNES_UADE.get_cuatrimestre (@fecha DATE) RETURNS INT AS
BEGIN
    DECLARE @cuatrimestre INTEGER,
            @mes INTEGER;

    SET @mes = MONTH(@fecha);

    SET @cuatrimestre = CASE WHEN @mes BETWEEN 1 AND 4 THEN 1
                             WHEN @mes BETWEEN 5 AND 8 THEN 2
                             WHEN @mes BETWEEN 9 AND 12 THEN 3
                        END;
                        
    RETURN @cuatrimestre;
END

GO

CREATE FUNCTION PIZZA_VIERNES_UADE.get_tiempo (@fecha DATE) RETURNS INT AS
BEGIN
    DECLARE @tiempo_id INTEGER;

    SET @tiempo_id = (SELECT id FROM PIZZA_VIERNES_UADE.BI_tiempo
                        WHERE anio = YEAR(@fecha) AND mes = MONTH(@fecha));
                        
    RETURN @tiempo_id;
END

GO

CREATE FUNCTION PIZZA_VIERNES_UADE.get_estado_envio(@fecha_programada DATE,
                                                    @hora_inicio DECIMAL(18,0),
                                                    @hora_fin DECIMAL(18,0),
                                                    @fecha_hora_entrega DATETIME) RETURNS CHAR(1) AS
BEGIN
    DECLARE @estado CHAR(1);
    DECLARE @fecha_entrega DATE;
    DECLARE @hora_entrega DECIMAL(18,0);

    SET @fecha_entrega = CONVERT(DATE, @fecha_hora_entrega);
    SET @hora_entrega = DATEPART(HOUR, @fecha_hora_entrega);

    SET @estado = CASE WHEN @fecha_hora_entrega IS NOT NULL AND @fecha_entrega <= @fecha_programada 
                    AND @hora_entrega BETWEEN @hora_inicio AND @hora_fin
                    THEN 'C' ELSE 'N'
    END;

    RETURN @estado;
END;

-- MIGRACION DE TABLAS

GO 

-- LLENADO DE DIMENSIONES
CREATE OR ALTER PROCEDURE PIZZA_VIERNES_UADE.BI_llenar_dimensiones AS 
BEGIN

    -- LLENADO DE DIMENSION PUBLICACION
    INSERT INTO PIZZA_VIERNES_UADE.BI_publicacion (cod_publicacion)
    SELECT DISTINCT cod_publicacion FROM PIZZA_VIERNES_UADE.publicacion;

    -- LLENADO DE DIMENSION MARCA
    INSERT INTO PIZZA_VIERNES_UADE.BI_marca (cod_marca, marca)
    SELECT DISTINCT cod_marca, descripcion FROM PIZZA_VIERNES_UADE.producto_marca;

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
    SELECT DISTINCT r.descripcion, s.descripcion 
    FROM PIZZA_VIERNES_UADE.subrubro s 
    JOIN PIZZA_VIERNES_UADE.rubro r ON s.cod_rubro = r.cod_rubro
    
    -- LLENADO DE DIMENSION RANGO ETARIO CLIENTES
    INSERT INTO PIZZA_VIERNES_UADE.BI_rango_etario_clientes (rango)
    VALUES ('< 25'), ('25-35'), ('35-50'), ('> 50');

    -- LLENADO DE DIMENSION RANGO HORARIO VENTAS
    INSERT INTO PIZZA_VIERNES_UADE.BI_rango_horario_ventas (rango)
    VALUES ('0:00 - 6:00'), ('6:00 - 12:00'), ('12:00 - 18:00'), ('18:00 - 24:00');
    
    -- LLENADO DE DIMENSION UBICACION
    INSERT INTO PIZZA_VIERNES_UADE.BI_ubicacion (localidad, provincia)
    SELECT DISTINCT l.nom_localidad, p.nom_provincia
    FROM PIZZA_VIERNES_UADE.localidad l
    JOIN PIZZA_VIERNES_UADE.provincia p ON p.cod_provincia = l.cod_provincia

    -- LLENADO DE DIMENSION TIEMPO
    INSERT INTO PIZZA_VIERNES_UADE.BI_tiempo (anio,cuatrimestre,mes)
    (
        SELECT DISTINCT YEAR(fecha_inicio), PIZZA_VIERNES_UADE.get_cuatrimestre(fecha_inicio), 
        MONTH(fecha_inicio) FROM PIZZA_VIERNES_UADE.publicacion

        UNION SELECT DISTINCT YEAR(fecha_hora),PIZZA_VIERNES_UADE.get_cuatrimestre(fecha_hora),
        MONTH(fecha_hora) FROM PIZZA_VIERNES_UADE.venta

        UNION SELECT DISTINCT YEAR(fecha),PIZZA_VIERNES_UADE.get_cuatrimestre(fecha),
        MONTH(fecha) FROM PIZZA_VIERNES_UADE.pago

        UNION SELECT DISTINCT YEAR(fecha),PIZZA_VIERNES_UADE.get_cuatrimestre(fecha),
        MONTH(fecha) FROM PIZZA_VIERNES_UADE.factura

        UNION SELECT DISTINCT YEAR(fecha_hora_entrega),PIZZA_VIERNES_UADE.get_cuatrimestre(fecha_hora_entrega),
        MONTH(fecha_hora_entrega) FROM PIZZA_VIERNES_UADE.envio
    )
END

GO 

-- LLENADO DE HECHOS
CREATE OR ALTER PROCEDURE PIZZA_VIERNES_UADE.BI_llenar_hechos AS
BEGIN

    -- LLENADO DE HECHOS DE FACTURACION
    INSERT INTO PIZZA_VIERNES_UADE.BI_hechos_facturacion (tiempo_id, ubicacion_id, concepto_facturacion_id, total_facturado)
    SELECT PIZZA_VIERNES_UADE.get_tiempo(f.fecha), u.id, bcp.id, SUM(df.sub_total)
    FROM PIZZA_VIERNES_UADE.factura f
    INNER JOIN PIZZA_VIERNES_UADE.detalle_factura df ON df.nro_factura = f.nro_factura
    INNER JOIN PIZZA_VIERNES_UADE.concepto_factura cf ON cf.cod_concepto_factura = df.cod_concepto_factura
    INNER JOIN PIZZA_VIERNES_UADE.vendedor v ON v.cod_vendedor = f.cod_vendedor
    INNER JOIN PIZZA_VIERNES_UADE.domicilio d ON d.cod_usuario = v.cod_usuario
    INNER JOIN PIZZA_VIERNES_UADE.localidad l ON l.cod_localidad = d.cod_localidad  
    INNER JOIN PIZZA_VIERNES_UADE.provincia p ON p.cod_provincia = l.cod_provincia
    INNER JOIN PIZZA_VIERNES_UADE.BI_concepto_facturacion bcp ON bcp.tipo = cf.concepto
    INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion u ON u.provincia = p.nom_provincia AND u.localidad = l.nom_localidad
    GROUP BY PIZZA_VIERNES_UADE.get_tiempo(f.fecha), u.id, bcp.id

    -- LLENADO DE HECHOS DE PAGO
    INSERT INTO PIZZA_VIERNES_UADE.BI_hechos_pagos (tiempo_id, ubicacion_id, tipo_medio_pago_id, total_pagos_en_cuotas, total_pagos_sin_cuotas)
    SELECT PIZZA_VIERNES_UADE.get_tiempo(p.fecha), u.id, btmp.id,  
    COALESCE(SUM(CASE WHEN dp.cant_cuotas > 1 THEN p.importe ELSE 0 END), 0) AS total_pagos_en_cuotas,
    COALESCE(SUM(CASE WHEN dp.cant_cuotas = 1 THEN p.importe ELSE 0 END), 0) AS total_pagos_sin_cuotas
    FROM PIZZA_VIERNES_UADE.pago p
    INNER JOIN PIZZA_VIERNES_UADE.medio_pago mp ON mp.cod_medio_pago = p.cod_medio_pago
    INNER JOIN PIZZA_VIERNES_UADE.detalle_pago dp ON dp.nro_pago = p.nro_pago
    INNER JOIN PIZZA_VIERNES_UADE.tipo_medio_pago tmp ON tmp.cod_tipo_medio_pago = mp.cod_tipo_medio_pago
    INNER JOIN PIZZA_VIERNES_UADE.envio e ON e.cod_venta = p.cod_venta
    INNER JOIN PIZZA_VIERNES_UADE.domicilio d ON d.cod_domicilio = e.cod_domicilio
    INNER JOIN PIZZA_VIERNES_UADE.localidad l ON l.cod_localidad = d.cod_localidad  
    INNER JOIN PIZZA_VIERNES_UADE.provincia pr ON pr.cod_provincia = l.cod_provincia
    INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion u ON u.provincia = pr.nom_provincia AND u.localidad = l.nom_localidad
    INNER JOIN PIZZA_VIERNES_UADE.BI_tipo_medio_pago btmp ON btmp.descripcion = tmp.descripcion
    GROUP BY PIZZA_VIERNES_UADE.get_tiempo(p.fecha), u.id, btmp.id;

    -- LLENADO DE HECHOS PUBICACIONES
    INSERT INTO PIZZA_VIERNES_UADE.BI_hechos_publicaciones (tiempo_id, rubro_id, marca_id, publicacion_id, dias_vigencia_publicacion, stock_inicial)
    SELECT PIZZA_VIERNES_UADE.get_tiempo(p.fecha_inicio), br.id, bm.cod_marca, bp.cod_publicacion, DATEDIFF(DAY, p.fecha_inicio, p.fecha_fin), p.stock
    FROM PIZZA_VIERNES_UADE.publicacion p
    INNER JOIN PIZZA_VIERNES_UADE.producto pr ON pr.id_producto = p.id_producto
    INNER JOIN PIZZA_VIERNES_UADE.producto_marca pm ON pm.cod_marca = pr.cod_marca
    INNER JOIN PIZZA_VIERNES_UADE.subrubro s ON s.cod_subrubro = pr.cod_subrubro
    INNER JOIN PIZZA_VIERNES_UADE.rubro r ON r.cod_rubro = s.cod_rubro
    INNER JOIN PIZZA_VIERNES_UADE.BI_rubro br ON br.rubro = r.descripcion AND br.subrubro = s.descripcion
    INNER JOIN PIZZA_VIERNES_UADE.BI_marca bm ON bm.marca = pm.descripcion
    INNER JOIN PIZZA_VIERNES_UADE.BI_publicacion bp ON bp.cod_publicacion = p.cod_publicacion
    
    -- LLENADO DE HECHOS DE VENTAS
    INSERT INTO PIZZA_VIERNES_UADE.BI_hechos_ventas (tiempo_id, ubicacion_almacenes_id, rubro_id, rango_etario_id, ubicacion_clientes_id, 
    rango_horario_ventas_id, valor_ventas, cantidad_ventas)
    SELECT PIZZA_VIERNES_UADE.get_tiempo(v.fecha_hora), ual.id, br.id, PIZZA_VIERNES_UADE.get_rango_edad(c.fecha_nac), ucli.id, 
        PIZZA_VIERNES_UADE.get_rango_horario(v.fecha_hora), SUM(v.total), COUNT(v.cod_venta)
    FROM PIZZA_VIERNES_UADE.venta v
    INNER JOIN PIZZA_VIERNES_UADE.detalle_venta dv ON dv.cod_venta = v.cod_venta
    INNER JOIN PIZZA_VIERNES_UADE.publicacion p ON p.cod_publicacion = dv.cod_publicacion
    INNER JOIN PIZZA_VIERNES_UADE.producto pr ON pr.id_producto = p.id_producto
    INNER JOIN PIZZA_VIERNES_UADE.subrubro s ON s.cod_subrubro = pr.cod_subrubro
    INNER JOIN PIZZA_VIERNES_UADE.rubro r ON r.cod_rubro = s.cod_rubro
    INNER JOIN PIZZA_VIERNES_UADE.BI_rubro br ON br.subrubro = s.descripcion AND br.rubro = r.descripcion
    INNER JOIN PIZZA_VIERNES_UADE.almacen a ON a.cod_almacen = p.cod_almacen
    INNER JOIN PIZZA_VIERNES_UADE.localidad la ON la.cod_localidad = a.cod_localidad --localidad almacen
    INNER JOIN PIZZA_VIERNES_UADE.provincia pa ON pa.cod_provincia = la.cod_provincia --provincia almacen
    INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion ual ON ual.provincia = pa.nom_provincia AND ual.localidad = la.nom_localidad --ubicacion almacen
    INNER JOIN PIZZA_VIERNES_UADE.cliente c ON c.cod_cliente = v.cod_cliente
    INNER JOIN PIZZA_VIERNES_UADE.domicilio d ON d.cod_usuario = c.cod_usuario
    INNER JOIN PIZZA_VIERNES_UADE.localidad lc ON lc.cod_localidad = d.cod_localidad  --localidad cliente
    INNER JOIN PIZZA_VIERNES_UADE.provincia pc ON pc.cod_provincia = lc.cod_provincia --provincia cliente
    INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion ucli ON ucli.provincia = pc.nom_provincia AND ucli.localidad = lc.nom_localidad --ubicacion cliente
    GROUP BY PIZZA_VIERNES_UADE.get_tiempo(v.fecha_hora), ual.id, br.id, PIZZA_VIERNES_UADE.get_rango_edad(c.fecha_nac), ucli.id, PIZZA_VIERNES_UADE.get_rango_horario(v.fecha_hora)

    -- LLENADO DE HECHOS DE ENVIO
    INSERT INTO PIZZA_VIERNES_UADE.BI_hechos_envios (tiempo_id, ubicacion_cliente_id, ubicacion_almacenes_id, tipo_envio_id,
		costo_total_envios,
		cant_envios_cumplidos,
		cant_envios_totales)
    SELECT PIZZA_VIERNES_UADE.get_tiempo(e.fecha_hora_entrega), u.id,u1.id, bte.id,
        SUM(e.costo),
        COUNT(CASE WHEN PIZZA_VIERNES_UADE.get_estado_envio(e.fecha_programada, e.hora_inicio, e.hora_fin, e.fecha_hora_entrega) = 'C' THEN 1 ELSE 0 END),
        COUNT(*)
    FROM PIZZA_VIERNES_UADE.envio e
    INNER JOIN PIZZA_VIERNES_UADE.BI_tipo_envio bte ON bte.tipo = e.tipo
    INNER JOIN PIZZA_VIERNES_UADE.domicilio d ON d.cod_domicilio = e.cod_domicilio
    INNER JOIN PIZZA_VIERNES_UADE.localidad l ON l.cod_localidad = d.cod_localidad  
    INNER JOIN PIZZA_VIERNES_UADE.provincia p ON p.cod_provincia = l.cod_provincia 
    INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion u ON u.provincia = p.nom_provincia AND u.localidad = l.nom_localidad
    INNER JOIN PIZZA_VIERNES_UADE.venta v ON v.cod_venta = e.cod_venta
    INNER JOIN PIZZA_VIERNES_UADE.detalle_venta dv ON v.cod_venta = dv.cod_venta
    INNER JOIN PIZZA_VIERNES_UADE.publicacion pub ON pub.cod_publicacion = dv.cod_publicacion
    INNER JOIN PIZZA_VIERNES_UADE.almacen a ON a.cod_almacen = pub.cod_almacen
    INNER JOIN PIZZA_VIERNES_UADE.localidad l2 ON l2.cod_localidad = a.cod_localidad
    INNER JOIN PIZZA_VIERNES_UADE.provincia p2 ON p2.cod_provincia = l2.cod_provincia
    INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion u1 ON u1.provincia = p2.nom_provincia AND u1.localidad = l2.nom_localidad
    GROUP BY PIZZA_VIERNES_UADE.get_tiempo(e.fecha_hora_entrega), u.id, u1.id, bte.id;
END

GO

EXEC PIZZA_VIERNES_UADE.BI_llenar_dimensiones;
EXEC PIZZA_VIERNES_UADE.BI_llenar_hechos;

GO

--CREACION DE VISTAS

CREATE VIEW PIZZA_VIERNES_UADE.BI_promedio_tiempo_publicaciones AS 
SELECT r.rubro, r.subrubro, t.cuatrimestre, t.anio, CAST(AVG(dias_vigencia_publicacion) AS decimal(18,2)) as tiempo_promedio_vigente
FROM PIZZA_VIERNES_UADE.BI_hechos_publicaciones p
INNER JOIN PIZZA_VIERNES_UADE.BI_tiempo t ON t.id = p.tiempo_id
INNER JOIN PIZZA_VIERNES_UADE.BI_rubro r ON r.id = p.rubro_id
GROUP BY r.rubro, r.subrubro, t.cuatrimestre, t.anio

GO

CREATE VIEW PIZZA_VIERNES_UADE.BI_promedio_stock_inicial AS 
SELECT m.marca,t.anio, AVG(stock_inicial) as stock_promedio
FROM PIZZA_VIERNES_UADE.BI_hechos_publicaciones p
INNER JOIN PIZZA_VIERNES_UADE.BI_tiempo t ON t.id = p.tiempo_id
INNER JOIN PIZZA_VIERNES_UADE.BI_marca m ON m.cod_marca = p.marca_id
GROUP BY m.marca, t.anio

GO

CREATE VIEW PIZZA_VIERNES_UADE.BI_promedio_mensual_ventas AS 
SELECT u.provincia, t.mes, t.anio, AVG(valor_ventas) as valor_ventas_promedio
FROM PIZZA_VIERNES_UADE.BI_hechos_ventas v
INNER JOIN PIZZA_VIERNES_UADE.BI_tiempo t ON t.id = v.tiempo_id
INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion u ON u.id = v.ubicacion_almacenes_id
GROUP BY u.provincia, t.mes, t.anio

GO

CREATE VIEW PIZZA_VIERNES_UADE.BI_rendimiento_rubros AS 
    SELECT tmp.provincia, tmp.localidad, tmp.cuatrimestre, tmp.anio, tmp.rango, tmp.rubro, tmp.ventas_totales, tmp.ranking
    FROM (
        SELECT u.provincia,u.localidad,t.cuatrimestre,t.anio,rec.rango,r.rubro,
            SUM(v.valor_ventas) AS ventas_totales,
            ROW_NUMBER() OVER (
                PARTITION BY u.provincia, u.localidad, t.cuatrimestre, t.anio, rec.rango
                ORDER BY SUM(v.valor_ventas) DESC
            ) AS ranking
        FROM PIZZA_VIERNES_UADE.BI_hechos_ventas v
        INNER JOIN PIZZA_VIERNES_UADE.BI_tiempo t ON t.id = v.tiempo_id
        INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion u ON u.id = v.ubicacion_clientes_id
        INNER JOIN PIZZA_VIERNES_UADE.BI_rango_etario_clientes rec ON rec.id = v.rango_etario_id
        INNER JOIN PIZZA_VIERNES_UADE.BI_rubro r ON r.id = v.rubro_id
        GROUP BY u.provincia, u.localidad, t.cuatrimestre, t.anio, rec.rango, r.rubro
    ) AS tmp
    WHERE ranking <= 5
GO 


-- IGNORAR ESTA VISTA, FUE DESESTIMADA
CREATE VIEW PIZZA_VIERNES_UADE.BI_volumen_ventas AS 
SELECT t.anio, t.mes, r.rango, SUM(cantidad_ventas) AS volumen_ventas
FROM PIZZA_VIERNES_UADE.BI_hechos_ventas v
INNER JOIN PIZZA_VIERNES_UADE.BI_tiempo t ON t.id = v.tiempo_id
INNER JOIN PIZZA_VIERNES_UADE.BI_rango_horario_ventas r ON r.id = rango_horario_ventas_id
GROUP BY t.anio, t.mes, r.rango

GO

CREATE VIEW PIZZA_VIERNES_UADE.BI_pagos_en_cuotas AS 
SELECT tmp.anio, tmp.mes, tmp.descripcion, tmp.provincia, tmp.localidad, tmp.total_pagos_en_cuotas, tmp.ranking 
FROM (
    SELECT t.anio, t.mes, mp.descripcion, u.provincia, u.localidad, 
        SUM(total_pagos_en_cuotas) AS total_pagos_en_cuotas,
        ROW_NUMBER() OVER (
            PARTITION BY t.anio,t.mes,mp.descripcion
            ORDER BY SUM(p.total_pagos_en_cuotas) DESC
        ) AS ranking
    FROM PIZZA_VIERNES_UADE.BI_hechos_pagos p
    INNER JOIN PIZZA_VIERNES_UADE.BI_tiempo t ON t.id = p.tiempo_id
    INNER JOIN PIZZA_VIERNES_UADE.BI_tipo_medio_pago mp ON mp.id = p.tipo_medio_pago_id
    INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion u ON u.id = p.ubicacion_id
    GROUP BY t.anio, t.mes, mp.descripcion, u.provincia, u.localidad
) AS tmp
WHERE tmp.ranking <= 3 

GO 

CREATE VIEW PIZZA_VIERNES_UADE.BI_porc_cumplimiento_envios AS 
SELECT u.provincia, t.anio, t.mes, 
    CAST(
        SUM(e.cant_envios_cumplidos) * 100.0 / SUM(e.cant_envios_totales)
    AS decimal(18,2)) AS porc_cumplimiento
FROM PIZZA_VIERNES_UADE.BI_hechos_envios e 
INNER JOIN PIZZA_VIERNES_UADE.BI_tiempo t ON t.id = e.tiempo_id
INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion u ON u.id = e.ubicacion_almacenes_id
GROUP BY u.provincia, t.anio, t.mes

GO

CREATE VIEW PIZZA_VIERNES_UADE.BI_cinco_localidades_mayor_costo_envio AS 
SELECT TOP 5 u.provincia, u.localidad, SUM(e.costo_total_envios) as costo_total_envio
FROM PIZZA_VIERNES_UADE.BI_hechos_envios e 
INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion u ON u.id = e.ubicacion_cliente_id
GROUP BY u.provincia, u.localidad
ORDER BY costo_total_envio DESC

GO

CREATE VIEW PIZZA_VIERNES_UADE.BI_porc_facturacion_x_concepto AS 
SELECT t.anio, t.mes, c.tipo, 
    CAST(
        (SUM(total_facturado)/aux.total_periodo * 100) 
    AS DECIMAL(18,2)) as porcentaje_fact_x_concepto
FROM PIZZA_VIERNES_UADE.BI_hechos_facturacion f 
INNER JOIN PIZZA_VIERNES_UADE.BI_tiempo t ON t.id = f.tiempo_id
INNER JOIN PIZZA_VIERNES_UADE.BI_concepto_facturacion c ON c.id = f.concepto_facturacion_id
INNER JOIN (
    SELECT tiempo_id, SUM(total_facturado) as total_periodo 
    FROM PIZZA_VIERNES_UADE.BI_hechos_facturacion
    GROUP BY tiempo_id
) AS aux ON aux.tiempo_id = t.id
GROUP BY t.anio, t.mes, c.tipo, total_periodo

GO

CREATE VIEW PIZZA_VIERNES_UADE.BI_facturacion_por_provincia AS 
SELECT u.provincia, t.anio, t.cuatrimestre, SUM(total_facturado) as monto_facturado 
FROM PIZZA_VIERNES_UADE.BI_hechos_facturacion f 
INNER JOIN PIZZA_VIERNES_UADE.BI_tiempo t ON t.id = f.tiempo_id
INNER JOIN PIZZA_VIERNES_UADE.BI_ubicacion u ON u.id = f.ubicacion_id
GROUP BY u.provincia, t.anio, t.cuatrimestre