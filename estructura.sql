-- Active: 1748981230048@@127.0.0.1@3307@Tigres
DROP DATABASE IF EXISTS Tigres;
CREATE DATABASE Tigres;
USE Tigres;

-- Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    direccion VARCHAR(150) NOT NULL
);

-- Métodos de pago
CREATE TABLE IF NOT EXISTS metodos_pago (
    id_metodo_pago INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_metodo VARCHAR(50) NOT NULL
);

-- Pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fecha_recogida DATETIME NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    id_cliente INT UNSIGNED NOT NULL,
    id_metodo_pago INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_metodo_pago) REFERENCES metodos_pago(id_metodo_pago)
);

-- Facturas
CREATE TABLE IF NOT EXISTS facturas (
    id_factura INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    total DECIMAL(10, 2) NOT NULL,
    fecha DATETIME NOT NULL,
    id_pedido INT UNSIGNED NOT NULL,
    id_cliente INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Categorías o tipos de producto
CREATE TABLE IF NOT EXISTS categorias_producto (
    id_categoria INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL
);

-- Productos
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categorias_producto(id_categoria)
);

-- Presentaciones (ej. Grande, Mediano)
CREATE TABLE IF NOT EXISTS presentaciones (
    id_presentacion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_presentacion VARCHAR(50) NOT NULL
);

-- Relación Producto ↔ Presentación con Precio
CREATE TABLE IF NOT EXISTS precios_producto (
    id_producto INT UNSIGNED NOT NULL,
    id_presentacion INT UNSIGNED NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_producto, id_presentacion),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_presentacion) REFERENCES presentaciones(id_presentacion)
);

-- Combos
CREATE TABLE IF NOT EXISTS combos (
    id_combo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_combo VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL
);

-- Relación Combo ↔ Producto
CREATE TABLE IF NOT EXISTS combos_productos (
    id_combo INT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_combo, id_producto),
    FOREIGN KEY (id_combo) REFERENCES combos(id_combo),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Detalles del pedido (agrupador)
CREATE TABLE IF NOT EXISTS detalles_pedido (
    id_detalle INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT UNSIGNED NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- Detalle de producto vendido
CREATE TABLE IF NOT EXISTS detalles_productos (
    id_detalle INT UNSIGNED NOT NULL,
    id_producto INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_detalle, id_producto),
    FOREIGN KEY (id_detalle) REFERENCES detalles_pedido(id_detalle),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Detalle de combo vendido
CREATE TABLE IF NOT EXISTS detalles_combos (
    id_detalle INT UNSIGNED NOT NULL,
    id_combo INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_detalle, id_combo),
    FOREIGN KEY (id_detalle) REFERENCES detalles_pedido(id_detalle),
    FOREIGN KEY (id_combo) REFERENCES combos(id_combo)
);

-- Ingredientes
CREATE TABLE IF NOT EXISTS ingredientes (
    id_ingrediente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_ingrediente VARCHAR(100) NOT NULL,
    stock INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL
);

-- Ingredientes extra por pedido
CREATE TABLE IF NOT EXISTS extras_pedido (
    id_detalle INT UNSIGNED NOT NULL,
    id_ingrediente INT UNSIGNED NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY (id_detalle, id_ingrediente),
    FOREIGN KEY (id_detalle) REFERENCES detalles_pedido(id_detalle),
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente)
);

-- Resumen de ventas diario
CREATE TABLE IF NOT EXISTS resumen_ventas (
    fecha DATE PRIMARY KEY,
    total_pedidos INT,
    total_ingresos DECIMAL(12,2),
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Alertas de bajo stock
CREATE TABLE IF NOT EXISTS alertas_stock (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    id_ingrediente INT UNSIGNED NOT NULL,
    stock_actual INT NOT NULL,
    fecha_alerta DATETIME NOT NULL,
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente)
);

-- Auditoría de cambios de precio
CREATE TABLE IF NOT EXISTS auditoria_precios (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT UNSIGNED NOT NULL,
    id_presentacion INT UNSIGNED NOT NULL,
    precio_anterior DECIMAL(10,2) NOT NULL,
    precio_nuevo DECIMAL(10,2) NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_presentacion) REFERENCES presentaciones(id_presentacion)
);

-- Registro de nuevos clientes
CREATE TABLE IF NOT EXISTS registro_clientes (
    id_registro INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL,
    nombre VARCHAR(100),
    telefono VARCHAR(15),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);