# Mandados Quirarte Araiza — v0.5

Sistema web móvil para recibir mandados semanales con la línea gráfica aprobada.

## Flujo del cliente
- Acceso por correo sin contraseña.
- Un perfil y una sola dirección de entrega.
- Catálogo de frutas, verduras, cremería/huevo/tortillas y productos libres.
- No se muestran precios mientras se arma el pedido.
- Cada pedido es independiente y recibe folio.
- Historial, usar pedido anterior como base y lista habitual.
- Estados: Recibido → Comprando → Listo → En reparto → Entregado.
- Cuando administración captura el total real de la compra, el cliente ve Compra + Servicio 20% + Total a pagar.

## Administración
- Lista de pedidos y datos del cliente.
- No se capturan costos producto por producto.
- Se captura únicamente `Total pagado en la compra`.
- La base de datos calcula automáticamente 20% de servicio y el total final.
- Botón para preparar aviso por WhatsApp.
- Reporte semanal.

## Puesta en marcha
1. Crea un proyecto en Supabase.
2. En SQL Editor ejecuta, en orden: `supabase-schema.sql`, `supabase-schema-v3.sql`, `supabase-schema-v5.sql`.
3. Copia `.env.example` como `.env.local` y coloca las dos claves públicas de Supabase.
4. En Supabase > Authentication > URL Configuration agrega tu dominio de Vercel y, para pruebas, `http://localhost:3000`.
5. Instala y prueba: `npm install` y luego `npm run build`.
6. Sube esta carpeta a tu repositorio de GitHub.
7. Importa ese repositorio en Vercel y agrega las mismas variables de entorno.
8. Crea tu usuario desde `/login` y hazlo administrador con la instrucción SQL que aparece al final de `supabase-schema-v3.sql`.

## Variables de entorno
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`

## Rutas
- `/` Inicio + nuevo mandado
- `/login` Acceso
- `/cuenta` Perfil y única dirección
- `/pedidos` Historial
- `/pedidos/[id]` Detalle y total final
- `/lista-habitual` Lista frecuente
- `/admin` Administración
- `/admin/reportes` Reporte semanal

## Nota
El 20% se calcula también en PostgreSQL mediante trigger, no sólo visualmente en el navegador. Así el total queda consistente aunque después se cambie la interfaz.

## v0.6 - Varios tickets por pedido
- Administración puede agregar tantos tickets como sean necesarios a un mismo pedido.
- Cada ticket puede incluir el nombre del lugar (opcional) y su importe.
- La suma de todos los tickets se convierte en el total de compra.
- El sistema calcula automáticamente 20% de servicio sobre esa suma.
- Se pueden eliminar tickets capturados por error y los totales se recalculan.
- Ejecutar `supabase-schema-v6.sql` después de las migraciones anteriores.
