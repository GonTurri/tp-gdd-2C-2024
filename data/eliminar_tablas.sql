USE GD2C2024
GO

-- borrar triggers



-- DROP TABLES
DROP TABLE [PIZZA_VIERNES_UADE].[detalle_factura]
DROP TABLE [PIZZA_VIERNES_UADE].[detalle_venta]
DROP TABLE [PIZZA_VIERNES_UADE].[publicacion]
DROP TABLE [PIZZA_VIERNES_UADE].[producto]
DROP TABLE [PIZZA_VIERNES_UADE].[subrubro]
DROP TABLE [PIZZA_VIERNES_UADE].[envio]
DROP TABLE [PIZZA_VIERNES_UADE].[detalle_pago]
DROP TABLE [PIZZA_VIERNES_UADE].[pago]
DROP TABLE [PIZZA_VIERNES_UADE].[venta]
DROP TABLE [PIZZA_VIERNES_UADE].[medio_pago]
DROP TABLE [PIZZA_VIERNES_UADE].[tipo_medio_pago]
DROP TABLE [PIZZA_VIERNES_UADE].[rubro]
DROP TABLE [PIZZA_VIERNES_UADE].[producto_marca]
DROP TABLE [PIZZA_VIERNES_UADE].[producto_modelo]
DROP TABLE [PIZZA_VIERNES_UADE].[concepto_factura]
DROP TABLE [PIZZA_VIERNES_UADE].[factura]
DROP TABLE [PIZZA_VIERNES_UADE].[domicilio]
DROP TABLE [PIZZA_VIERNES_UADE].[vendedor]
DROP TABLE [PIZZA_VIERNES_UADE].[cliente]
DROP TABLE [PIZZA_VIERNES_UADE].[usuario]
DROP TABLE [PIZZA_VIERNES_UADE].[almacen]
DROP TABLE [PIZZA_VIERNES_UADE].[localidad]
DROP TABLE [PIZZA_VIERNES_UADE].[provincia]
GO

-- DROP PROCEDURES
DROP PROCEDURE PIZZA_VIERNES_UADE.migrar_todo

--GO

DROP SCHEMA [PIZZA_VIERNES_UADE]
GO


-- USE [GD2C2021]
-- GO

-- DROP TRIGGER [BRAVO].[fecha_alta_camion]
-- DROP TRIGGER [BRAVO].[finalizar_orden_on_delete]
-- DROP TRIGGER [BRAVO].[actualizar_dias_reales_ejec]
-- GO

-- DROP TABLE [BRAVO].[tareas_x_orden_trabajo]
-- DROP TABLE [BRAVO].[materiales_x_tarea]
-- DROP TABLE [BRAVO].[tarea]
-- DROP TABLE [BRAVO].[material]
-- DROP TABLE [BRAVO].[viaje_x_tipos_paquete]
-- DROP TABLE [BRAVO].[tipo_paquete]
-- DROP TABLE [BRAVO].[mecanico]
-- DROP TABLE [BRAVO].[taller]
-- DROP TABLE [BRAVO].[viaje]
-- DROP TABLE [BRAVO].[chofer]
-- DROP TABLE [BRAVO].[recorrido]
-- DROP TABLE [BRAVO].[orden_trabajo]
-- DROP TABLE [BRAVO].[camion]
-- DROP TABLE [BRAVO].[modelo_camion]
-- GO

-- DROP PROCEDURE [BRAVO].[migrar_todo]
-- GO

-- DROP SCHEMA [BRAVO]
-- GO