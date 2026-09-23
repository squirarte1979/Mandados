# Mandados Quirarte Araiza — paquete para revisión de publicación

## Qué contiene
- Logo **original** del proyecto en `public/logo-mandados.png`, mostrado completo en todas las pantallas.
- Catálogo con **ilustraciones emoji** por producto, búsqueda, categorías, cantidades, borrador automático y resumen. No hay precios inventados por producto.
- Acceso por enlace de correo con límite de reenvío y mensajes en español.
- Pedidos, historial, lista habitual, administración y tickets conservados del proyecto original.
- `supabase-schema-v7-security.sql`: corrección de permisos que **no se aplica automáticamente** al desplegar.

## Antes de publicar — obligatorio
1. **Respalda Supabase** y confirma que se ejecutaron los esquemas base, v3, v5 y v6. Ejecuta **solo** `supabase-schema-v7-security.sql` en SQL Editor. Si ya se ejecutó v7, no lo ejecutes de nuevo sin revisar sus políticas.
2. En Supabase > Authentication > URL Configuration, establece la URL real de tu dominio y la URL de redirección `https://TU-DOMINIO/**`. Verifica un acceso real por correo. Para uso público, configura un proveedor SMTP propio en Supabase: el bloqueo `email rate limit exceeded` **no se arregla únicamente con código**.
3. Crea un usuario de prueba, completa perfil y dirección, envía un pedido de prueba y comprueba que se muestre en administración. Captura dos tickets, comprueba el total de compra + 20 %, cambia el estado y revisa el historial del cliente.
4. Confirma que un cliente normal no puede acceder a datos de otros clientes ni convertirse en administrador.
5. Instala dependencias y ejecuta `npm run build` antes de desplegar. No incluyas claves privadas ni la clave `service_role` en el repositorio.
6. Para publicar en Vercel, sube los **archivos de la carpeta** `Mandados-main` a tu repositorio (no el ZIP dentro del repositorio). Verifica que las variables públicas de Supabase estén configuradas. Comprueba el despliegue de prueba antes de pasar a producción.

## Importante
Este paquete es el código listo para revisión y despliegue, **no una certificación de que tu Supabase real ya esté configurado o probado**. La web publicada no se ha modificado desde aquí.
