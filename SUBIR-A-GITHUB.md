# Publicación de Mandados — instrucciones cortas

## Estado real
El paquete contiene el proyecto Next.js completo, el logotipo original, catálogo con ilustraciones emoji y los cambios de interfaz. `npm run check:release` pasó la verificación estática. **No se completó `npm install` ni `npm run build` en este entorno** y **no se probó el Supabase de producción**. Por tanto, no se debe considerar un despliegue validado.

## 1. Subir el código sin reemplazar producción
En GitHub, abre `squirarte1979/Mandados` y crea una rama nueva desde `main`, por ejemplo `publicacion-mandados`. En esa rama, sube **el contenido de esta carpeta**, manteniendo `app/`, `components/`, `lib/`, `public/` y los archivos de la raíz. No subas el ZIP como único archivo ni incluyas `.env.local`, claves privadas o `node_modules`. Si GitHub móvil no permite subir carpetas, hazlo desde una computadora o usa GitHub Desktop.

## 2. Probar la compilación
En una computadora con Node.js compatible: `npm install`, `npm run check:release` y `npm run build`. En Vercel revisa el despliegue de vista previa de la rama. Si el build falla, no fusiones la rama a `main`.

## 3. Configurar el correo en Supabase
Comprueba Authentication > URL Configuration: dominio de producción y dominio de vista previa autorizados en Redirect URLs. El error `email rate limit exceeded` depende del límite del proveedor de correo de Supabase: para uso público revisa la configuración de SMTP y sus límites. La espera de la interfaz no incrementa la cuota de Supabase.

## 4. Aplicar la migración de seguridad
Haz un respaldo y verifica que ya se aplicaron el esquema base, v3, v5 y v6. Después ejecuta `supabase-schema-v7-security.sql` en SQL Editor de Supabase. **Subir el SQL a GitHub no lo ejecuta.** Si no puedes confirmar el estado de las migraciones, no ejecutes archivos a ciegas.

## 5. Prueba mínima antes de pasar a main
Con una cuenta normal: iniciar sesión, guardar dirección, agregar productos, enviar pedido, consultar folio e historial y repetir un pedido. Con la cuenta administradora: ver el pedido, agregar dos tickets, comprobar suma + 20 %, actualizar estado y comprobar la vista del cliente. Confirma que la cuenta normal no ve `/admin` ni puede editar el estado o el total desde la API.

## 6. Publicar
Solo cuando build, correo, migración y pedido de prueba funcionen, fusiona la rama en `main` y verifica el despliegue de producción en Vercel.

## Importante sobre el diseño
Las ilustraciones son emojis de producto (no fotografías ni SVG personalizados). El catálogo no muestra precios por producto: los importes se determinan con los tickets reales y 20 % de servicio.
