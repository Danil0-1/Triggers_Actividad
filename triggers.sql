-- 1. Validar stock antes de agregar detalle de producto
DELIMITER $$
CREATE TRIGGER trg_before_insert_detalle
BEFORE INSERT ON detalles_pedido
FOR EACH ROW
BEGIN
    IF NEW.cantidad < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad debe ser al menos 1';
    END IF;
END $$
DELIMITER ;

-- 2. Descontar stock tras agregar ingredientes extra
DELIMITER $$
CREATE TRIGGER trg_after_insert_ingredientes_extra
AFTER INSERT ON extras_pedido
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;

    SELECT stock INTO stock_actual
    FROM ingredientes
    WHERE id_ingrediente = NEW.id_ingrediente;

    IF stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para este ingrediente.';
    END IF;

    UPDATE ingredientes
    SET stock = stock - NEW.cantidad
    WHERE id_ingrediente = NEW.id_ingrediente;
END $$
DELIMITER ;

-- 3. Registrar auditoría de cambios de precio
DELIMITER $$
CREATE TRIGGER trg_after_update_precio
AFTER UPDATE ON precios_producto
FOR EACH ROW
BEGIN
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO auditoria_precios (
            id_producto,
            id_presentacion,
            precio_anterior,
            precio_nuevo
        ) VALUES (
            NEW.id_producto,
            NEW.id_presentacion,
            OLD.precio,
            NEW.precio
        );
    END IF;
END $$
DELIMITER ;

-- 4. Impedir precio cero o negativo
DELIMITER $$
CREATE TRIGGER trg_before_update_precio
BEFORE UPDATE ON precios_producto
FOR EACH ROW
BEGIN
    IF NEW.precio <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio debe ser mayor a cero.';
    END IF;
END $$
DELIMITER ;

-- 5. Generar factura automática
DELIMITER $$
CREATE TRIGGER trg_after_insert_pedido
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
    INSERT INTO facturas (
        total,
        fecha,
        id_pedido,
        id_cliente
    )
    VALUES (
        NEW.total,
        NOW(),
        NEW.id_pedido,
        NEW.id_cliente
    );
END $$
DELIMITER ;

-- 6. Actualizar estado del pedido tras facturar (solo si agregaste columna `estado`)
-- Necesitas primero agregar la columna si no existe:
-- ALTER TABLE pedidos ADD estado VARCHAR(50) DEFAULT 'Pendiente';

DELIMITER $$
CREATE TRIGGER trg_after_insert_factura
AFTER INSERT ON facturas
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET estado = 'Facturado'
    WHERE id_pedido = NEW.id_pedido;
END $$
DELIMITER ;

-- 7. Evitar eliminación de combos en uso
DELIMITER $$
CREATE TRIGGER trg_before_delete_combo
BEFORE DELETE ON combos
FOR EACH ROW
BEGIN
    DECLARE combo_usado INT;

    SELECT COUNT(*) INTO combo_usado
    FROM detalles_combos
    WHERE id_combo = OLD.id_combo;

    IF combo_usado > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar el combo porque está en uso.';
    END IF;
END $$
DELIMITER ;

-- 8. Limpiar relaciones tras borrar un detalle
DELIMITER $$
DROP TRIGGER IF EXISTS trg_after_delete_detalle;
CREATE TRIGGER trg_after_delete_detalle
AFTER DELETE ON detalles_pedido
FOR EACH ROW
BEGIN
    DELETE FROM extras_pedido
    WHERE id_detalle = OLD.id_detalle;

    DELETE FROM detalles_productos
    WHERE id_detalle = OLD.id_detalle;

    DELETE FROM detalles_combos
    WHERE id_detalle = OLD.id_detalle;
END $$
DELIMITER ;

-- 9. Control de stock mínimo tras actualización
DELIMITER $$
CREATE TRIGGER trg_after_update_stock
AFTER UPDATE ON ingredientes
FOR EACH ROW
BEGIN
    DECLARE stock_minimo INT DEFAULT 5;

    IF NEW.stock < stock_minimo AND OLD.stock >= stock_minimo THEN
        INSERT INTO alertas_stock (
            id_ingrediente,
            stock_actual,
            fecha_alerta
        )
        VALUES (
            NEW.id_ingrediente,
            NEW.stock,
            NOW()
        );
    END IF;
END $$
DELIMITER ;

-- 10. Registrar creación de nuevos clientes
DELIMITER $$
CREATE TRIGGER trg_after_insert_cliente
AFTER INSERT ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO registro_clientes (
        id_cliente,
        nombre,
        telefono
    ) VALUES (
        NEW.id_cliente,
        NEW.nombre,
        NEW.telefono
    );
END $$
DELIMITER ;
