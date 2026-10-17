# Pagos y webhooks (S; C si cobra)

Comprobar: precios y montos calculados en el servidor a partir de IDs de producto; webhooks con firma verificada (cuerpo crudo + secreto + tolerancia de tiempo) e idempotentes (guardar el ID del evento y rechazar repetidos); el estado de pago sale del webhook o de la API del proveedor, no del redirect del navegador; auditoría de cada evento de pago.
No hacer: aceptar monto, moneda, descuento o precio desde el cliente; procesar un webhook sin verificar su firma; guardar datos de tarjeta (usar el checkout del proveedor).

