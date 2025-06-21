-- Clientes
INSERT INTO clientes (nombre, telefono, direccion) VALUES
('Juan Pérez', '3111111111', 'Calle 123 #45-67'),
('Ana Gómez', '3122222222', 'Carrera 10 #20-30'),
('Luis Rojas', '3133333333', 'Av. Siempre Viva 742');

-- Métodos de pago
INSERT INTO metodos_pago (nombre_metodo) VALUES
('Efectivo'),
('Tarjeta de crédito'),
('Nequi'),
('Transferencia');

-- Categorías de productos
INSERT INTO categorias_producto (nombre_categoria) VALUES
('Bebida'),
('Comida'),
('Postre');

-- Productos
INSERT INTO productos (nombre_producto, id_categoria) VALUES
('Hamburguesa Clásica', 2),
('Gaseosa Cola', 1),
('Malteada Fresa', 1),
('Brownie', 3);

-- Presentaciones
INSERT INTO presentaciones (nombre_presentacion) VALUES
('Pequeña'),
('Mediana'),
('Grande');

-- Precios por presentación
INSERT INTO precios_producto (id_producto, id_presentacion, precio) VALUES
(1, 2, 12000.00),
(2, 1, 3000.00),
(3, 3, 8000.00),
(4, 2, 6000.00);

-- Combos
INSERT INTO combos (nombre_combo, precio) VALUES
('Combo Hamburguesa', 15000.00),
('Combo Postre', 12000.00);

-- Productos por combo
INSERT INTO combos_productos (id_combo, id_producto) VALUES
(1, 1),
(1, 2),
(2, 4),
(2, 3);

-- Ingredientes
INSERT INTO ingredientes (nombre_ingrediente, stock, precio) VALUES
('Lechuga', 100, 200.00),
('Tomate', 80, 300.00),
('Queso', 50, 1000.00),
('Tocineta', 40, 1500.00);

-- Pedidos
INSERT INTO pedidos (fecha_recogida, total, id_cliente, id_metodo_pago) VALUES
('2025-06-20 12:30:00', 15000.00, 1, 1),
('2025-06-20 13:00:00', 18000.00, 2, 2);

-- Facturas
INSERT INTO facturas (total, fecha, id_pedido, id_cliente) VALUES
(15000.00, '2025-06-20 12:35:00', 1, 1),
(18000.00, '2025-06-20 13:05:00', 2, 2);

-- Detalles del pedido
INSERT INTO detalles_pedido (id_pedido, cantidad) VALUES
(1, 1),
(2, 2);

-- Productos en detalle de pedido
INSERT INTO detalles_productos (id_detalle, id_producto) VALUES
(1, 1),
(1, 2),
(2, 4);

-- Combos en detalle de pedido
INSERT INTO detalles_combos (id_detalle, id_combo) VALUES
(2, 1);

-- Ingredientes extra
INSERT INTO extras_pedido (id_detalle, id_ingrediente, cantidad) VALUES
(1, 3, 2),
(1, 4, 1);

-- Resumen ventas
INSERT INTO resumen_ventas (fecha, total_pedidos, total_ingresos) VALUES
('2025-06-20', 2, 33000.00);

-- Alertas de stock
INSERT INTO alertas_stock (id_ingrediente, stock_actual, fecha_alerta) VALUES
(3, 5, '2025-06-20 14:00:00'),
(4, 3, '2025-06-20 14:05:00');

-- Datos extra de prueba
INSERT INTO categorias_producto(nombre_categoria) VALUES ('Bebida');
INSERT INTO productos(nombre_producto, id_categoria) VALUES ('Cola', 1);
INSERT INTO presentaciones(nombre_presentacion) VALUES ('Botella 500ml');
INSERT INTO precios_producto(id_producto, id_presentacion, precio) VALUES (1, 1, 3500);
