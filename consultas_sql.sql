-- 1- Agregar un nuevo propietario
SELECT * FROM tourism.owners

INSERT INTO tourism.owners (
    first_name, 
    last_name, 
    company_name, 
    email, 
    phone, 
    address_line1, 
	city,
	country,
	postal_code,
    tax_identification_
) 
VALUES (
    'Carlos', 
    'Mendoza', 
    'Mendoza Luxury Rentals S.A.', 
    'carlos.mendoza@email.com', 
    '+34 600 123 456', 
    'Calle Mayor 45, Madrid, España', 
	'Madrid'
	'España'
	'2012'
    'ESA12345678Z'
);

-- 2- Crear alojamiento vinculado
SELECT * FROM tourism.accommodations

INSERT INTO tourism.accommodations(
	owner_id,
	accommodation_type_id,
	location_id,
	name,
	description,
	max_guests,
	bedroom_count,
	bathroom_count,
	base_price_per_night,
	currency_code,
	check_in_time,
	check_out_time,
	is_active
)
VALUES 
(
    '1', 
    '1', 
    '10', 
    'Apartamento Loft con Vista al Mar', 
    'Hermoso loft totalmente equipado en el corazón de la ciudad, ideal para parejas o viajes de negocios.', 
    '2', 
    '1', 
    '1', 
    '85.00', 
    'USD', 
    '15:00:00', 
    '11:00:00', 
    'TRUE'
);

-- 3- Registrar huésped y reserva
SELECT * FROM tourism.booking_guests

INSERT INTO tourism.booking_guests(
	booking_id,
	first_name,
	last_name,
	age,
	document_number
)
VALUES
(
	'18', 
    'Carlos', 
    'Mendoza', 
    '34', 
    'PAS12345678'
)

-- 4- Registrar pago
SELECT * FROM tourism.payments

INSERT INTO tourism.payments(
	booking_id,
	payment_date,	
	amount,
	payment_method,
	payment_status,
	transaction_reference,
	notes
)
VALUES
(
    '4', 
    '2026-06-09 18:45:22.347692', 
    '50.00', 
    'DebitCard', 
    'Failed', 
    'TXN-ERROR-004', 
    'Intento de pago rechazado por fondos insuficientes. Se notificó al cliente para reintentar.'
);

-- 5- Filtrar activos
SELECT * FROM tourism.accommodations
WHERE is_active = 'true'


-- 6- Filtrar por nacionalidad
SELECT * FROM tourism.guests

SELECT nationality, COUNT(*) AS "Huéspedes por país"
FROM tourism.guests
GROUP BY nationality

-- 7- Uso de BETWEEN
SELECT * FROM tourism.bookings

SELECT COUNT(*) AS "Reservas en el 2025"
FROM tourism.bookings
WHERE check_in_date
BETWEEN '2025-01-01' AND '2025-12-31'
 
SELECT * FROM tourism.accommodations

-- 8- Modificar precio
UPDATE tourism.accommodations
SET
base_Price_per_night = '500.30',
updated_at = NOW()
WHERE accommodation_id = 5
RETURNING accommodation_id, base_Price_per_night

SELECT * FROM tourism.accommodations

SELECT * FROM tourism.bookings

-- 9. Actualizar estado
UPDATE tourism.bookings
SET
booking_status_id = '6',
updated_at = NOW()
WHERE booking_id = 8
RETURNING booking_id, booking_status_id

SELECT * FROM tourism.bookings

--10- DELETE WHERE
SELECT * FROM tourism.reviews

DELETE FROM tourism.reviews 
WHERE booking_id = 39;

SELECT * FROM tourism.bookings
SELECT * FROM tourism.guests

-- 11- 	INNER JOIN
SELECT
huesped.first_name AS "Nombre",
huesped.last_name AS "Apellido",
reservas.check_in_date AS "fecha de ingreso",
reservas.check_in_date AS "fecha de egreso"
FROM tourism.bookings reservas
INNER JOIN tourism.guests huesped ON reservas.booking_id = huesped.guest_id

--12- INNER JOIN múltiple	
SELECT 
	  a.accommodation_id,
	  a.name AS alojamiento_nombre,
	  a.description AS alojamiento_descripcion,
	  a.max_guests AS capacidad_max_huespedes,
	  a.base_price_per_night AS precio_por_noche,
	  a.currency_code AS moneda,
	  at.type_name AS tipo_alojamiento,
	  o.first_name || ' ' || o.last_name AS propietario_nombre,
	  o.email AS propietario_email,
	  l.city AS ciudad,
	  l.state AS estado,
	  l.country AS pais,
	  l.address_line1 AS direccion,
	  am.amenity_name AS comodidad
FROM 
	    tourism.accommodations a
	INNER JOIN 
	    tourism.accommodation_types at ON a.accommodation_type_id = at.accommodation_type_id
	INNER JOIN 
	    tourism.owners o ON a.owner_id = o.owner_id
	INNER JOIN 
	    tourism.locations l ON a.location_id = l.location_id
	INNER JOIN 
	    tourism.accommodation_amenities aa ON a.accommodation_id = aa.accommodation_id
	INNER JOIN 
	    tourism.amenities am ON aa.amenity_id = am.amenity_id
	WHERE 
	    a.is_active = true
	ORDER BY 
	    a.accommodation_id, am.amenity_name;

--13- JOIN combinado
SELECT 
    p.payment_id,
    p.payment_date,
    p.amount AS monto_pagado,
    p.payment_method AS metodo_pago,
    p.payment_status AS estado_pago,
    b.booking_reference AS referencia_reserva,
    b.check_in_date,
    b.check_out_date,
    b.total_amount AS total_reserva,
    bs.status_name AS estado_reserva,
    CONCAT(g.first_name, ' ', g.last_name) AS nombre_huesped,
    g.email AS email_huesped,
    a.name AS nombre_alojamiento
FROM 
    tourism.payments p
INNER JOIN 
    tourism.bookings b ON p.booking_id = b.booking_id
INNER JOIN 
    tourism.booking_statuses bs ON b.booking_status_id = bs.booking_status_id
INNER JOIN 
    tourism.guests g ON b.guest_id = g.guest_id
INNER JOIN 
    tourism.accommodations a ON b.accommodation_id = a.accommodation_id
ORDER BY 
    p.payment_date DESC;


-- 14- Incluye nulls
SELECT 
    b.booking_id,
    b.booking_reference,
    b.check_in_date,
    b.check_out_date,
    r.review_id -- Este campo vendrá como NULL
FROM 
    tourism.bookings b
LEFT JOIN 
    tourism.reviews r ON b.booking_id = r.booking_id
WHERE 
    r.review_id IS NULL;

-- 15- Filtrar null
SELECT 
    a.accommodation_id,
    a.name AS nombre_alojamiento,
    at.type_name AS tipo,
    l.city AS ciudad,
    l.country AS pais
FROM 
    tourism.accommodations a
LEFT JOIN 
    tourism.bookings b ON a.accommodation_id = b.accommodation_id
-- Traemos los datos de soporte (tipo y ubicación) para que el resultado sea más informativo
LEFT JOIN 
    tourism.accommodation_types at ON a.accommodation_type_id = at.accommodation_type_id
LEFT JOIN 
    tourism.locations l ON a.location_id = l.location_id
WHERE 
    b.booking_id IS NULL; -- Filtramos para quedarnos solo con los alojamientos SIN reservas

-- 16- SUM
SELECT 
    SUM(amount) AS total_ingreso
FROM 
    tourism.payments;

-- 17- AVG
SELECT 
    ROUND(AVG(rating), 2) AS promedio_rating
FROM 
    tourism.reviews;

-- 18- COUNT + LIMIT
SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    t.type_name AS tipo,
    l.city AS ciudad,
    l.country AS pais,
    COUNT(b.booking_id) AS total_reservas
FROM 
    tourism.accommodations a
INNER JOIN 
    tourism.bookings b ON a.accommodation_id = b.accommodation_id
INNER JOIN 
    tourism.accommodation_types t ON a.accommodation_type_id = t.accommodation_type_id
INNER JOIN 
    tourism.locations l ON a.location_id = l.location_id
GROUP BY 
    a.accommodation_id, 
    a.name, 
    t.type_name, 
    l.city, 
    l.country
ORDER BY 
    total_reservas DESC
LIMIT 5;


-- 19- GROUP BY + HAVING
SELECT 
    g.guest_id,
    g.first_name,
    g.last_name,
    g.email,
    COUNT(b.booking_id) AS total_reservas
FROM 
    tourism.guests g
INNER JOIN 
    tourism.bookings b ON g.guest_id = b.guest_id
GROUP BY 
    g.guest_id, 
    g.first_name, 
    g.last_name, 
    g.email
HAVING 
    COUNT(b.booking_id) > 3
ORDER BY 
    total_reservas DESC;

-- 20- Subquery
SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    t.type_name AS tipo,
    l.city AS ciudad,
    l.country AS pais,
    a.base_price_per_night AS precio_por_noche,
    a.currency_code AS moneda
FROM 
    tourism.accommodations a
JOIN 
    tourism.accommodation_types t ON a.accommodation_type_id = t.accommodation_type_id
JOIN 
    tourism.locations l ON a.location_id = l.location_id
WHERE 
    a.base_price_per_night = (
        SELECT MAX(base_price_per_night) 
        FROM tourism.accommodations
    );


	







	
	





